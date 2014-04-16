Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaDPScX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:32:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50411 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaDPScV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:32:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,873,1389772800"; 
   d="scan'208";a="522171221"
Message-ID: <1397673140.2495.4.camel@rzhang-toshiba>
Subject: Re: 3.13.?: Strange / dangerous fan policy...
From: Zhang Rui <rui.zhang@intel.com>
To: Manuel Krause <manuelkrause@netscape.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org
Date: Thu, 17 Apr 2014 02:32:20 +0800
In-Reply-To: <5349D4D6.9060506@netscape.net>
References: <531A1EEE.9090101@netscape.net> <5340BF6E.5040400@roeck-us.net>
	 <5341E09F.6050402@netscape.net> <1705965.XMmsPN5L3N@vostro.rjw.lan>
	 <5347206F.6020201@netscape.net> <5349D4D6.9060506@netscape.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-13 at 02:05 +0200, Manuel Krause wrote:
> On 2014-04-11 00:51, Manuel Krause wrote:
> > On 2014-04-07 13:45, Rafael J. Wysocki wrote:
> >> On Monday, April 07, 2014 01:17:51 AM Manuel Krause wrote:
> >>> On 2014-04-06 04:43, Guenter Roeck wrote:
> >>>> On 04/05/2014 07:37 PM, Manuel Krause wrote:
> >>>>> On 2014-04-01 01:47, Guenter Roeck wrote:
> >>>>>> On 03/31/2014 04:37 PM, Manuel Krause wrote:
> >>>>>>> On 2014-03-20 21:21, Manuel Krause wrote:
> >>>>>>>> On 2014-03-11 22:59, Manuel Krause wrote:
> >>>>>>>>> On 2014-03-10 02:49, Manuel Krause wrote:
> >>>>>>>>>> On 2014-03-09 18:58, Rafael J. Wysocki wrote:
> >>>>>>>>>>> On Sunday, March 09, 2014 01:10:25 AM Manuel Krause
> >>>>>>>>>>> wrote:
> >>>>>>>>>>>> On 2014-03-08 16:59, Guenter Roeck wrote:
> >>>>>>>>>>>>> On 03/08/2014 03:08 AM, Jean Delvare wrote:
> >>>>>>>>>>>>>> On Fri, 7 Mar 2014 14:52:30 -0800, Guenter Roeck
> >>>>>>>>>>>>>> wrote:
> >>>>>>>>>>>>>>> On Fri, Mar 07, 2014 at 11:04:29PM +0100, Manuel
> >>>>>>>>>>>>>>> Krause
> >>>>>>>>>>>>>>> wrote:
> >>>>>>>> [SNIP]
> >>>>>>>>
> >>>>>>>> Long time no reply from you... Have I overseen a unwritten
> >>>>>>>> convention? Or were my charts that unusable for your
> >>>>>>>> analysis/work?
> >>>>>>>>
> >>>>>>>> Two days ago, I tried the 3.14.0-rc7-vanilla. And the
> >>>>>>>> problem
> >>>>>>>> persists. "Strange / dangerous fan policy..."
> >>>>>>>>
> >>>>>>>> Since kernel 3.13.6 I've managed to 'fix' the potential
> >>>>>>>> overheating problem by manually issuing a:
> >>>>>>>> "echo 1 > /sys/class/thermal/cooling_device3/cur_state" *)
> >>>>>>>> _before_ obviously critical temperatures occur. Remind: This
> >>>>>>>> particular setting may only work for my system! ...and keeps
> >>>>>>>> working for 3.14-rc.
> >>>>>>>>
> >>>>>>>> In the following I'd like to present you a modified output
> >>>>>>>> of my
> >>>>>>>> /sys/class/thermal, that I've written a script for (for my
> >>>>>>>> system), that shows the results in the way of
> >>>>>>>> linux/Documentation/thermal/sysfs-api.txt, point 3:
> >>>>>>>> {I've uploded the files to pastebin, to not swamp you and
> >>>>>>>> the
> >>>>>>>> lists with so many lines of logs.}
> >>>>>>>>
> >>>>>>>> For the last good kernel -- 3.12.14 -- in-use:
> >>>>>>>>    http://pastebin.com/HL1PNcda
> >>>>>>>> For my first bad kernel revision 3.13 -- at critical temp:
> >>>>>>>>    http://pastebin.com/98hgf1a9
> >>>>>>>> For the last bad kernel -- 3.14.0-rc7 -- at critical temp:
> >>>>>>>>    http://pastebin.com/MuTwTnjD
> >>>>>>>> For the last bad kernel -- 3.14.0-rc7 -- after issuing the
> >>>>>>>>    *) command:
> >>>>>>>>    http://pastebin.com/2peda54z
> >>>>>>>>
> >>>>>>>> Please, have a look at them! And maybe, give me hints on
> >>>>>>>> how I
> >>>>>>>> can help you to further debug this issue, as my manual
> >>>>>>>> method
> >>>>>>>> works but it's annoying.
> >>>>>>>>
> >>>>>>>> And, PLEASE CC: ME, as I'm not on the lists. Or lead this
> >>>>>>>> Email-thread to someone in charge.
> >>>>>>>>
> >>>>>>>> Thank you for your work && best regards,
> >>>>>>>> Manuel Krause
> >>>>>>>>
> >>>>>>>
> >>>>>>> This is still BUG 71711
> >>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=71711
> >>>>>>>
> >>>>>>> 3.12.15 works very well
> >>>>>>> 3.13.7 fails
> >>>>>>> 3.14.0-rc8 fails
> >>>>>>>
> >>>>>>
> >>>>>> Best you can do would really be to bisect the problem.
> >>>>>> Unfortunately only you (or someone else with an affected
> >>>>>> system)
> >>>>>> can do that. Once the culprit is known it would be much easier
> >>>>>> to get it fixed.
> >>>>>>
> >>>>>> To answer your earlier question: I don't think you did
> >>>>>> anything
> >>>>>> wrong.
> >>>>>> I guess everyone else is just as clueless as I am (if not,
> >>>>>> speak up
> >>>>>> and help ;-).
> >>>>>>
> >>>>>> Guenter
> >>>>>>
> >>>>>
> >>>>> I've now bisected two times. From two different kernel origins,
> >>>>> just to be sure, as I'm new to this stupid-and-lengthy method,
> >>>>> and, to be sure, I haven't given a false positive inbetween due
> >>>>> to boredom.
> >>>>>
> >>>>
> >>>> Not really. Keep in mint that you were able to track down the
> >>>> bad
> >>>> commit
> >>>> among more than 10,000 commits in a reasonably short period
> >>>> of time.
> >>>>
> >>>>> In the end it says each time:
> >>>>> # git bisect bad | tee -a /var/log/bisect.log
> >>>>> cc8ef52707341e67a12067d6ead991d56ea017ca is the first bad
> >>>>> commit
> >>>>> commit cc8ef52707341e67a12067d6ead991d56ea017ca
> >>>>> Author: Zhang Rui <rui.zhang@intel.com>
> >>>>> Date:   Wed Sep 25 20:39:45 2013 +0800
> >>>>>
> >>>>>       ACPI / AC: convert ACPI ac driver to platform bus
> >>>>>
> >>>>>       Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> >>>>>       Signed-off-by: Rafael J. Wysocki
> >>>>> <rafael.j.wysocki@intel.com>
> >>>>>
> >>>> Off to the two of you...
> >>>>
> >>>> Guenter
> >>>>
> >>>>> :040000 040000 5a0d397cfcbf53c03390f2805b83754cb7837d84
> >>>>> 4a2af1454f65d67f1d1a507c08e3b9ef3ffe57e7 M      drivers
> >>>>>
> >>>>>
> >>>>> Please help me, on how I can help debug this more, and please
> >>>>> also read the newest from
> >>>>> https://bugzilla.kernel.org/show_bug.cgi?id=71711
> >>>>>
> >>>>> Manuel Krause
> >>>>>
> >>>>>
> >>>>>
> >>>>
> >>>
> >>> Sorry, that I've forgotton to add the following last night: After
> >>> the first bisection round, I was so glad about a result that
> >>> time, that I reverted this mentioned patch from the 3.13.8
> >>> kernel, but this didn't fix it.
> >>
> >> This means that the commit in question didn't introduce the
> >> problem
> >> you're seeing.
> >>
> >> Please check out commit 7f2dc5c4bcbf (Merge tag
> >> 'dm-3.13-changes' of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm),
> >>
> >> build a kernel from that and see if you can reprocude the
> >> problem with it.
> >> If so, it can be used as your new "first known bad" kernel for
> >> bisection.
> >> Otherwise, you can use it as the "first good" one and commit
> >> cc8ef52707341
> >> as "first known bad".
> >>
> >> Thanks!
> >>
> >
> > Sorry, for any inconvenience, but you should forget about what
> > I've written, that reverting the patch in question from 3.13.x
> > didn't fix it. Of course it didn't fix it, as the patch doesn't
> > cleanly revert from release-kernels at all. My mistake!
> >
> > I' ve been guided by Guenter Roeck through two more bisecting
> > sessions/ways on this, that always pointed to the commit in
> > question.
> >
> > Some citation:
> > Me:
> >>>> O.k. I've now followed your latest directions:
> >>>> git checkout -b testing cc8ef52707341e67a12067d6ead991d56ea017ca
> >>>> => result after rebuild was BAD =>
> >>>> git revert cc8ef52707341e67a12067d6ead991d56ea017ca
> >>>> => result after rebuild was GOOD
> >>>>
> > [ ...]
> >>>> Reverting that commit in question from this very git tree
> >>>> makes the
> >>>> kernel work as expected.
> > [ ... ]
> > Guenter:
> >>> Report the results you have above. That should show without
> >>> question
> >>> that cc8ef52707341e67a12067d6ead991d56ea017ca is the bad commit,
> >>> and it should be easy to reproduce.
> >
> > That seems to be all I can do for you for now. Please let me know
> > of any preliminary patches to test!
> > And I want to add special thanks to Guenter Roeck for his
> > always-just-in-time assistance over so many days,
> >
> > Manuel Krause
> >
> 
> BTW -- applying this patch in question to a 3.12.17 kernel, that 
> worked optimal WITHOUT it, makes it FAIL as described for 3.13.x 
> kernels. (And, yes, the patch applied cleanly, compiled fine and 
> boots nicely.)
> 
could you please apply commit 50a2bc5429f07ec4d53df2d287b03bdbceb281bb
on top of commit cc8ef52707341e67a12067d6ead991d56ea017ca and check if
the problem still exist in 3.12.17 kernel?

thanks,
rui
> Manuel Krause
> 


