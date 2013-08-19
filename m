Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3HSVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3HSVZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:25:26 -0400
Date: Mon, 19 Aug 2013 17:25:12 -0400
From: Dave Jones <davej@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130819212512.GA7918@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Anton Arapov <anton@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Greg KH <gregkh@linuxfoundation.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	linux-kernel@vger.kernel.org
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819155202.GF19070@bandura.laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 05:52:02PM +0200, Anton Arapov wrote:
 > On Mon, Aug 19, 2013 at 11:39:39AM -0400, Theodore Ts'o wrote:
 > > On Mon, Aug 19, 2013 at 05:16:43PM +0200, Anton Arapov wrote:
 > > > > Why not just do that through email?  You'll reach a much wider group of
 > > > > people than the tiny 80 developers at the conference.
 > > > 
 > > > Ouch! Someone to take it as replacement of email - the least I wanted. It will
 > > > go email-way in either case.
 > > > 
 > > > These tiny 80 may give the most valuable feedback on the topic. And often
 > > > it is the most difficult to get attention of them, especially via email.
 > > > In case it fits the conference, it could dilute the heavy topics.
 > > 
 > > Usyually the best thing to do is to start the discussion on the
 > > mailing list (and we can do that on ksummit-2013-discuss, but this is
 > > always why it's sometimes useful to cc lkml on topic proposals, so we
 > > can jump start the discussion), and see if it's controversial or not.
 > 
 > Oh well,... I didn't have a time for this right now, nor project is
 > not exactly in the state I'm willing to show (mostly webui) 
 > 
 > // CC'd: lkml (please don't complain on styles yet, focus on functionality)

I stumbled across this a week or so ago, and had some thoughts back then,
but didn't mail them anywhere because I wasn't sure who ran it, and couldn't
tell how far along it was.

Quick brain dump

* Visiting it with chromium gets an annoying warning about the https server
  identifying as a different server. (does it even need https?)

* There's a lot of tainted kernel traces in there. 99% of kernel developers
  will never care about these in my experience.  You can adjust this on a per-query
  basis it seems, but better would be to turn them off globally, and have them
  available just for people who want to search for 'all' (tainted or untainted) oopses.

  - That the tainted oopses are counted as 'regular' oopses is skewing the 'top bugs'
    on the front page.

  - As well as proprietary, take care of 'out of tree' tainted modules in the same way.

* I clicked through some of the debian oopses, and saw these:
  https://oops.kernel.org/browse-reports/oops-detail/?id=30497
  https://oops.kernel.org/browse-reports/oops-detail/?id=30499
  It would be useful to know if this was the same user. (It seems likely, but
  there's no way to know for sure). You don't need identifying info other than
  "These came from the same system" side-stepping any privacy concerns.

* In the Linked modules section, if there's an out-of-tree/proprietary module,
  we annotate those in oopses with (O), or (P). This seems to be lost in your UI.
  (Bonus points for making them stand out)

* The traces by default lack a lot of information, forcing clicking of the 'show raw oops'
  in every case.  Missing useful info (at least): EIP/RIP, other registers.

* 'Show raw oops' doesn't. (At least on chromium)

* This bug last seen: 2013-08-17
  Also useful here would be something like:
  Seen on: 3.2-rc2, 3.10-rc10  (You can probably just list earliest/latest rather than
   every single kernel it's been seen on, unless you want a 'show all' button)

* Instead of summaries like "general protection fault: 4000 [#1] SMP"
  Decode the EIP/RIP, and call it "general protection fault in i915_gem_do_execbuffer".
  Not only does it make reading summaries easier, it should allow you to detect
  dupes better.  (Sidenote, abrt needs this too, when it files bugzillas)

* Looking over the summaries at https://oops.kernel.org/browse-reports/?distro=Fedora&search=submit
  The first thing that comes to mind is "There's a lot of soft lockup bugs here"
  Some means of grouping similar looking bugs would be useful.
  (In bugzilla, clicking 'sort by summary' kinda gives this, but it still sucks).

* When Arjan ran kerneloops, he would periodically mail out a "top 10 oopses" report
  on the latest tree. That seems like something that would be worth doing again,
  but only after filtering out the tainted stuff as mentioned above.

* Some kind of "find similar bugs in other bug trackers" feature would be really awesome.

* There's a bunch of bugs in there that have been tainted 'W'.  These are almost never useful,
  because we're already deep in "bad shit happened" land at that point.
  It'll also mean you could get flooded with oopses from a single crash if something
  keeps on spewing traces. Just give up after filing the first oops.

* Take for example: https://oops.kernel.org/browse-reports/oops-detail/?id=30410
  This is a 2.6.27.5 kernel bug, that was filed *last week*.
  I'd bet dollars to donuts no-one is going to give a crap about that bug.
  I'm not sure if it's better here to never file 'ancient' bugs, or to periodically
  archive/delete ones that have been in the db more than a few years.  

* Looking at https://oops.kernel.org/browse-reports/?function=ironlake_crtc_disable&search=submit
  It seems the hashing algorithm for detecting dupes could use some work.
  Many of these traces are probably exactly the same problem.
  Are you hashing symbols in the trace beginning with '? ' ? If so, you probably shouldn't be.

	Dave

