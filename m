Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaFCDLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:11:43 -0400
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:39611 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752160AbaFCDLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:11:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:871:960:973:982:988:989:1000:1260:1261:1313:1314:1345:1359:1373:1437:1516:1518:1534:1542:1575:1594:1711:1730:1747:1764:1777:1792:2393:2559:2562:2840:31
X-HE-Tag: hen43_e476ff864244
X-Filterd-Recvd-Size: 4766
Message-ID: <1401765096.7323.61.camel@joe-AO725>
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 20:11:36 -0700
In-Reply-To: <20140603015133.GA20354@thin>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
	 <1401741411.7323.36.camel@joe-AO725> <538CE0E0.8020002@infradead.org>
	 <20140603000246.GC14801@cloud> <538D1FC6.3090500@infradead.org>
	 <20140603015133.GA20354@thin>
Content-Type: multipart/mixed; boundary="=-0vc/hPX1JDVe/vQVrw3I"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0vc/hPX1JDVe/vQVrw3I
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On Mon, 2014-06-02 at 18:51 -0700, Josh Triplett wrote:
> git send-email can invoke 'scripts/get_maintainer.pl --no-rolestats'
> directly via --to-cmd or -cc-cmd; that works fine as long as you don't
> have a cover letter.
> 
> Depending on the system I'm running on, and whether it's more convenient
> to invoke git-send-email or to edit patch mails and send them with 'mutt
> -H', I have a shell pipeline which invokes get_maintainer.pl on an
> entire patch series, collects all the email addresses it returns, and
> inserts them all into each mail as CCs.  (That way, when I send a
> cross-subsystem patch series, I don't get a pile of maintainers confused
> that they only received a couple of the numbered patches.)  One example:

I think that as long as the appropriate mailing lists receive
the cover letter, any real maintainer won't be confused.

> { echo -n "To: " ; for x in *.patch ; do scripts/get_maintainer.pl --no-rolestats < $x | fgrep -v josh@joshtriplett.org ; done | sort -u | sed 's/$/, /;$s/, $//' | tr -d '\n' ; echo ; } | sed -i '/^From:/r/dev/stdin'
> 
> Personally, I'd find it handy if one of the following happened:
> 
> - git send-email (and ideally also git format-patch) grew an option to
>   collect *all* the to-cmd and cc-cmd output from each patch and apply
>   it to every patch (including the cover letter).

The biggest issue with doing that is the
quantity of names and addresses on the [0/n]
patch can easily exceed vger's 1024 byte
maximum header size limit.

I drop all but the primary maintainers and
just cc lists.

I use a couple of scripts for that (attached)
for the "--to_cmd" and "--cc_cmd" options

Another possibility is to add a new "--bcc_cmd"
to git send-email so that vger's header limit
can be worked around.

I had patches to git to do that awhile ago.

> - get_maintainer.pl accepted multiple patchfile names and output the
>   union of the results.  Ideally, get_maintainer.pl would also have a -i
>   option to edit the patch files and insert the addresses in the mail
>   headers.

Why would get_maintainer.pl have any option like that?

Tools for uses.  Scripting.
Aren't we good at that sort of thing?

--=-0vc/hPX1JDVe/vQVrw3I
Content-Type: application/x-shellscript; name="to.sh"
Content-Disposition: attachment; filename="to.sh"
Content-Transfer-Encoding: 7bit

#!/bin/bash

opts="--nogit --nogit-fallback --norolestats --pattern-depth=1"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    maint=$(./scripts/get_maintainer.pl --nol $opts $1)
    if [ "$maint" == "" ] ; then
	echo "linux-kernel@vger.kernel.org"
    else
	echo "$maint"
    fi
fi

--=-0vc/hPX1JDVe/vQVrw3I
Content-Type: application/x-shellscript; name="cc.sh"
Content-Disposition: attachment; filename="cc.sh"
Content-Transfer-Encoding: 7bit

#!/bin/bash

opts="--nogit --nogit-fallback --norolestats"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    ./scripts/get_maintainer.pl $opts $1
fi

--=-0vc/hPX1JDVe/vQVrw3I--

