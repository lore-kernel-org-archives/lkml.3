Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaFCBvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:51:50 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60581 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFCBvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:51:49 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 2 Jun 2014 18:51:33 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
Message-ID: <20140603015133.GA20354@thin>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
 <1401741411.7323.36.camel@joe-AO725>
 <538CE0E0.8020002@infradead.org>
 <20140603000246.GC14801@cloud>
 <538D1FC6.3090500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D1FC6.3090500@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:07:18PM -0700, Randy Dunlap wrote:
> On 06/02/2014 05:02 PM, josh@joshtriplett.org wrote:
> > On Mon, Jun 02, 2014 at 01:38:56PM -0700, Randy Dunlap wrote:
> >> On 06/02/2014 01:36 PM, Joe Perches wrote:
> >>> On Mon, 2014-06-02 at 13:35 -0700, Andrew Morton wrote:
> >>>> On Mon,  2 Jun 2014 10:00:20 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>>>
> >>>>> --- a/MAINTAINERS
> >>>>> +++ b/MAINTAINERS
> >>>>> @@ -7321,6 +7321,7 @@ F:	kernel/rcu/torture.c
> >>>>>  
> >>>>>  RCUTORTURE TEST FRAMEWORK
> >>>>>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>>>> +R:	Josh Triplett <josh@joshtriplett.org>
> >>>>>  L:	linux-kernel@vger.kernel.org
> >>>>>  S:	Supported
> >>>>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >>>>
> >>>> I like the general principle - knowing who to poke regarding a kernel
> >>>> change is useful.
> >>>>
> >>>> I don't care much whether it's "M:" or "R:", although "R:" carries more
> >>>> meaning and hence is probably better.
> >>>>
> >>>> But why not "Cc:"?  That's meaningful too and is more copy-n-paste friendly.
> >>
> >> Josh, what are you assuming that Andrew and I did not?
> > 
> > Not sure what you mean here.  Responding to the text you quoted: I have
> > no particular need to bikeshed the tag name, so if you prefer "Cc" and
> > can convince get_maintainer.pl to handle it, fine by me.
> 
> Sorry, what I meant is that Andrew and I both mentioned copy-paste and
> you replied earlier (and I have already deleted it) that copy-paste shouldn't
> be necessary for someone who is using get_maintainer.pl.
> 
> Do you redirect its output to your patch file and then edit it or does
> get_maintainer.pl work with git-send-email or something else?  if something
> else, what is it, please?

Oh, I see; that was in text you hadn't quoted, so I didn't know what you
were asking. :)

git send-email can invoke 'scripts/get_maintainer.pl --no-rolestats'
directly via --to-cmd or -cc-cmd; that works fine as long as you don't
have a cover letter.

Depending on the system I'm running on, and whether it's more convenient
to invoke git-send-email or to edit patch mails and send them with 'mutt
-H', I have a shell pipeline which invokes get_maintainer.pl on an
entire patch series, collects all the email addresses it returns, and
inserts them all into each mail as CCs.  (That way, when I send a
cross-subsystem patch series, I don't get a pile of maintainers confused
that they only received a couple of the numbered patches.)  One example:

{ echo -n "To: " ; for x in *.patch ; do scripts/get_maintainer.pl --no-rolestats < $x | fgrep -v josh@joshtriplett.org ; done | sort -u | sed 's/$/, /;$s/, $//' | tr -d '\n' ; echo ; } | sed -i '/^From:/r/dev/stdin'

Personally, I'd find it handy if one of the following happened:

- git send-email (and ideally also git format-patch) grew an option to
  collect *all* the to-cmd and cc-cmd output from each patch and apply
  it to every patch (including the cover letter).

- get_maintainer.pl accepted multiple patchfile names and output the
  union of the results.  Ideally, get_maintainer.pl would also have a -i
  option to edit the patch files and insert the addresses in the mail
  headers.
