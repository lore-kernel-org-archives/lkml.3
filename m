Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaFCFKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:10:46 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37695 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaFCFKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:10:44 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 2 Jun 2014 22:10:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
Message-ID: <20140603051026.GA24869@thin>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
 <1401741411.7323.36.camel@joe-AO725>
 <538CE0E0.8020002@infradead.org>
 <20140603000246.GC14801@cloud>
 <538D1FC6.3090500@infradead.org>
 <20140603015133.GA20354@thin>
 <1401765096.7323.61.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401765096.7323.61.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 08:11:36PM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 18:51 -0700, Josh Triplett wrote:
> > git send-email can invoke 'scripts/get_maintainer.pl --no-rolestats'
> > directly via --to-cmd or -cc-cmd; that works fine as long as you don't
> > have a cover letter.
> > 
> > Depending on the system I'm running on, and whether it's more convenient
> > to invoke git-send-email or to edit patch mails and send them with 'mutt
> > -H', I have a shell pipeline which invokes get_maintainer.pl on an
> > entire patch series, collects all the email addresses it returns, and
> > inserts them all into each mail as CCs.  (That way, when I send a
> > cross-subsystem patch series, I don't get a pile of maintainers confused
> > that they only received a couple of the numbered patches.)  One example:
> 
> I think that as long as the appropriate mailing lists receive
> the cover letter, any real maintainer won't be confused.

Not so much "confused" as "annoyed"; I've had people specifically
complain about getting one or two patches but not the cover letter, for
instance.  (And "the appropriate mailing lists" often just mean LKML,
for many patches I've sent; almost nobody sees a patch only sent to
LKML, unless they specifically go looking for it.)

> > { echo -n "To: " ; for x in *.patch ; do scripts/get_maintainer.pl --no-rolestats < $x | fgrep -v josh@joshtriplett.org ; done | sort -u | sed 's/$/, /;$s/, $//' | tr -d '\n' ; echo ; } | sed -i '/^From:/r/dev/stdin'
> > 
> > Personally, I'd find it handy if one of the following happened:
> > 
> > - git send-email (and ideally also git format-patch) grew an option to
> >   collect *all* the to-cmd and cc-cmd output from each patch and apply
> >   it to every patch (including the cover letter).
> 
> The biggest issue with doing that is the
> quantity of names and addresses on the [0/n]
> patch can easily exceed vger's 1024 byte
> maximum header size limit.

Is that the limit on the size of any *one* header, or on the size of all
headers combined?  If the former, there's an easy way around that.  And
if the latter, that seems absurdly small.

Might also help to strip out the names and just insert the addresses;
annoying, but a handy workaround to make it likely that a sensibly sized
patch series won't hit the limit.

> Another possibility is to add a new "--bcc_cmd"
> to git send-email so that vger's header limit
> can be worked around.

That breaks the ability for the recipients to see replies.

> I had patches to git to do that awhile ago.

That'd be handy; did you try submitting them upstream?  What reception
did you get?

> > - get_maintainer.pl accepted multiple patchfile names and output the
> >   union of the results.  Ideally, get_maintainer.pl would also have a -i
> >   option to edit the patch files and insert the addresses in the mail
> >   headers.
> 
> Why would get_maintainer.pl have any option like that?
> 
> Tools for uses.  Scripting.
> Aren't we good at that sort of thing?

Yes, we're good at scripting; we put scripts many people might wish to
use in a scripts/ directory, such as the extremely handy script
get_maintainer.pl that does that sort of thing with patches.  And since
it currently does nothing useful at all with cover letters, it'd be nice
to change that.

If you have objections to putting it directly in get_maintainer.pl, it'd
be easy enough to make a secondary script (patch_add_maintainers?) to
drive it.

- Josh Triplett
