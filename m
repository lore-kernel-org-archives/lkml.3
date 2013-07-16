Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab3GPVW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:22:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45481 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206Ab3GPVWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:22:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        viresh.kumar@linaro.org, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
Date: Tue, 16 Jul 2013 23:32:20 +0200
Message-ID: <2829832.mz5UcF7ZkY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E56382.3020609@gmx.de>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51DF307B.7060307@linux.vnet.ibm.com> <51E56382.3020609@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 05:15:14 PM Toralf Förster wrote:
> On 07/12/2013 12:23 AM, Srivatsa S. Bhat wrote:
> > On 07/12/2013 04:03 AM, Rafael J. Wysocki wrote:
> >> On Friday, July 12, 2013 03:45:17 AM Srivatsa S. Bhat wrote:
> >>>
> >>> Hi,
> >>
> >> Hi,
> >>
> >>> Commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) caused
> >>> some subtle regressions in the cpufreq subsystem during suspend/resume.
> >>> This patchset is aimed at rectifying those problems, by fixing the regression
> >>> as well as achieving the original goal of that commit in a proper way.
> >>>
> >>> Patch 1 reverts the above commit, and is CC'ed to stable.
> >>>
> >>> Patches 2 - 5 reorganize the code and have no functional impact, and can go
> >>> in as general cleanups as well. This reorganization builds a base that the
> >>> rest of the patches will make use of.
> >>>
> >>> Patch 6 and 7 add a mechanism to perform light-weight init/tear-down of CPUs
> >>> in the cpufreq subsystem and finally patch 8 uses it to preserve sysfs files
> >>> across suspend/resume.
> >>>
> >>> All the patches apply on current mainline.
> >>>
> >>>
> >>> Robert, Durgadoss, it would be great if you could try it out and see if it works
> >>> well for your usecase. I tested it locally and cpufreq related files did retain
> >>> their permissions across suspend/resume. Let me know if it works fine in your
> >>> setup too.
> >>>
> >>> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
> >>> whether their systems work fine after:
> >>> a. applying only the first commit (this is what gets backported to stable)
> >>> b. applying all the commits
> >>>
> >>> (Note: I had to use Michael's fix[1] to avoid CPU hotplug deadlock while
> >>> testing this patchset. Though that patch also touches cpufreq subsystem, it
> >>> doesn't affect this patchset in any way and there is absolutely no dependency
> >>> between the two in terms of code. That fix just makes basic CPU hotplug work
> >>> without locking up on current mainline).
> >>>
> >>> [1]. https://lkml.org/lkml/2013/7/10/611
> >>>
> >>>
> >>> Thank you very much!
> >>
> >> Thanks Srivatsa!
> >>
> >> I'm going to take [1/8] for 3.11 and queue up the rest for 3.12 if people don't
> >> hate them.  This way we'll have some more testing coverage before they reach
> >> the mainline hopefully.
> >>
> 
> On 07/16/2013 01:25 AM, Rafael J. Wysocki wrote:> On Monday, July 15, 2013 07:38:02 PM Toralf Förster wrote:
> > Sorry, I have no idea what 1#8 means.
> 
> sry - here again with full quote of the email :
> 
> I applied patch [1/8] on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup
> cycles fine and crashed the system at the 3rd attempt / one times just at
> the 4th (blinking power led, no sysrq, ...).
> 
> Applying patch 1-8 on top of that tree differs in that way that it
> crashes now the system even at the 1st attempt or at least at the 2nd
> 
> My hardware is a ThinkPad T420 with latest BIOS and a 32 bit stable
> Gentoo Linux - FWIW .config attached.

I think you'll need the fixes first, basically [1/8] from this series and
this: https://patchwork.kernel.org/patch/2827512/ .

Please try to run with these two things applied only and see how that goes.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
