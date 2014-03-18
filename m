Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaCRJR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:17:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65156 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaCRJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:17:54 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-9e-53280f372a06
Date: Tue, 18 Mar 2014 10:17:36 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC v3 0/5] cpufreq:LAB: Support for LAB governor.
Message-id: <20140318101736.501844d1@amdc2363>
In-reply-to: <CAKohpokz9SknhPH_sgGE6Q8DB+QtaJKSwMG4WgfmWet9skMKUA@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
 <20140317163824.3c5480b3@amdc2363>
 <CAKohpokz9SknhPH_sgGE6Q8DB+QtaJKSwMG4WgfmWet9skMKUA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jAV0Lfo1gg/d3WSw2zljPavG06Qe7
	RefZJ8wWbx5xW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFrcbV7BZnDl9idVi/YzXLBab
	J2xks+hYxmix8auHA7/Hzll32T3uXNvD5rF5Sb3H7X+PmT3WTXvL7LHlajuLR9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGXs73vBVHBesWLWxq3MDYwPpboYOTkkBEwkDp47xQRhi0lcuLee
	rYuRi0NIYBGjxIx1xxghnF+MEo2tpxhBqlgEVCWmTp8F1sEmoCfx+e5TMFtEIFTi6NSv7CAN
	zAJ/WSSOPdgO1iAs4CBxYlcTM4jNC9TQ3XieDcTmFAiW2N10jQViw0dGiQXPp7GCJPgFJCXa
	//1ghrjJTuLcpw3sEM2CEj8m32MBsZkFtCQ2b2tihbDlJTavecs8gVFwFpKyWUjKZiEpW8DI
	vIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjONKeSe1gXNlgcYhRgINRiYf3BZt6sBBrYllx
	Ze4hRgkOZiUR3qWTgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFk
	mTg4pRoYjx0WdpqQvcl0mnP8hv3PP7PPSPd7LmT0L9Q47Cr/EmYfw8+bHCVamj99mfzoCf+f
	TMXER8nq79IPOHWc5LkVOzn7xs8Lq1fkT2Fa3LuyQKWjab8U283+S6ubQqs8Hmcks3vVaMWb
	5Ot6LDqi6ZkfGc2W78z93t1bcVL542PumpETMi7XTGpTYinOSDTUYi4qTgQADOUBhrACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 17 March 2014 21:08, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> >> Despite this patch set is working and applicable on top of
> >> 3.14-rc5, please regard it solely as a pure RFC.
> >>
> >> This patch provides support for LAB governor build on top of
> >> ondemand. Previous version of LAB can be found here:
> >> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >>
> >> LAB short reminder:
> >>
> >> LAB uses information about how many cores are in "idle" state (the
> >> core idleness is represented as the value between 0 and 100) and
> >> the overall load of the system (from 0 to 100) to decide about
> >> frequency to be set. It is extremely useful with SoCs like
> >> Exynos4412, which can set only one frequency for all cores.
> >>
> >> Important design decisions:
> >>
> >> - Reuse well established ondemand governor's internal code. To do
> >> this I had to expose some previously static internal ondemand code.
> >>   This allowed smaller LAB code when compared to previous version.
> >>
> >> - LAB works on top of ondemand, which means that one via device
> >> tree attributes can specify if and when e.g. BOOST shall be
> >> enabled or if any particular frequency shall be imposed. For
> >> situation NOT important from the power consumption reduction
> >> viewpoint the ondemand is used to set proper frequency.
> >>
> >> - It is only possible to either compile in or not the LAB into the
> >> kernel. There is no "M" option for Kconfig. It is done on purpose,
> >> since ondemand itself can be also compiled as a module and then it
> >> would be possible to remove ondemand when LAB is working on top of
> >> it.
> >>
> >> - The LAB operation is specified (and thereof extendable) via
> >> device tree lab-ctrl-freq attribute defined at /cpus/cpu0.
> >>
> >>
> >> Problems:
> >> - How the governor will work for big.LITTLE systems (especially
> >> Global Task Scheduling).
> >> - Will there be agreement to expose internal ondemand code to be
> >> reused for more specialized governors.
> >>
> >> Test HW:
> >>       Exynos4412 - Trats2 board.
> >> Above patches were posted on top of Linux 3.14-rc5
> >> (SHA1: 3f9590c281c66162bf8ae9b7b2d987f0a89043c6)
> >>
> >
> > Any comments about those patches?
> 
> Sorry for being late on reviewing these..
> 
> I tried to go through the patches but didn't looked at the minutest
> of the details. Its been a long time when you first sent this
> patchset. And the memories have corrupted by now :) ..

Unfortunately memory is volatile ... since LAB governor is a follow up
of BOOST, which review and inclusion took considerable time, some
details could be forgotten. 

> 
> To get context back, can we discuss again the fundamentals behind
> this new governor you are proposing. And then we can discuss about
> it again, its pros/cons, etc..

Please consider following links:

The original implementation - threads:
http://thread.gmane.org/gmane.linux.power-management.general/32523/match=lab
http://thread.gmane.org/gmane.linux.kernel/1484746/match=lab


LAB justification data:
http://article.gmane.org/gmane.linux.kernel/1472381


> People are reluctant in getting another governor in and want to give
> existing governors a try if possible.

As I've stated in the covering letter, this code is an extension of
Ondemand.

This is totally different from what have been posted previously (v1,
v2).
The first LAB proposal was written with some parts copied from Ondemand.
It was a separate, standalone governor.


The approach proposed in those patches is very different. It simply
reuses Ondemand code as much as possible (timers, default attributes
exported to sysfs, etc.).

On top of the Ondemand we have the LAB, which thereof is its optional
extension. The existing code is reused and can be easily extracted as a
common code.

> 
> So, please explain the basics behind your governor again and then
> we can put our arguments again..
> 

I hope that provided overview is sufficient. More in depth
information can be found in posted patches or provided LKML archives.

> --
> viresh

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
