Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaKDAxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:53:05 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41506 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaKDAxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:53:02 -0500
Date: Tue, 4 Nov 2014 09:52:52 +0900
From: Simon Horman <horms@verge.net.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: non-Multiplatform APE6EVM broken in v3.18-rc1
Message-ID: <20141104005252.GJ22891@verge.net.au>
References: <20141028004131.GA8280@verge.net.au>
 <CAMuHMdXmOeJowF9FSQtoUzNK4zohvSYm+r3qp41-JigAOJ=+fg@mail.gmail.com>
 <20141028092305.GA11937@verge.net.au>
 <CAMuHMdUnwT7a1Gewz3AW-R9EaQBfYkJ2y7ZQ6uW4GaxBAHXzXg@mail.gmail.com>
 <20141029001258.GE20702@verge.net.au>
 <20141029020833.GA29787@verge.net.au>
 <CAMuHMdWkP=t2WL64X8vKdOPXW_ZpbibXQ66un8GfVTWoc-o+tw@mail.gmail.com>
 <20141029090502.GA32069@verge.net.au>
 <20141030013444.GI22052@verge.net.au>
 <545759FD.1020806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545759FD.1020806@linaro.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:33:33AM +0100, Daniel Lezcano wrote:
> On 10/30/2014 02:34 AM, Simon Horman wrote:
> >On Wed, Oct 29, 2014 at 06:05:03PM +0900, Simon Horman wrote:
> >>On Wed, Oct 29, 2014 at 09:13:11AM +0100, Geert Uytterhoeven wrote:
> >>>On Wed, Oct 29, 2014 at 3:08 AM, Simon Horman <horms@verge.net.au> wrote:
> >>>>On Wed, Oct 29, 2014 at 09:12:58AM +0900, Simon Horman wrote:
> >>>>>On Tue, Oct 28, 2014 at 10:32:32AM +0100, Geert Uytterhoeven wrote:
> >>>>>>On Tue, Oct 28, 2014 at 10:23 AM, Simon Horman <horms@verge.net.au> wrote:
> >>>>>>>On Tue, Oct 28, 2014 at 08:59:28AM +0100, Geert Uytterhoeven wrote:
> >>>>>>>>On Tue, Oct 28, 2014 at 1:41 AM, Simon Horman <horms@verge.net.au> wrote:
> >>>>>>>>>I have noticed that there appears to be a regression between v3.17 and
> >>>>>>>>>v3.18-rc1 such that non-multiplatform APE6EVM (ape6evm_defconfig) no longer
> >>>>>>>>>boots.  This appears to be the case using both reference DT (MACH_APE6EVM)
> >>>
> >>>>It seems that the boot stops here:
> >>>>
> >>>>...
> >>>>smsc911x smsc911x eth0: MAC Address: 00:08:f7:00:02:4b
> >>>>rcar_thermal rcar_thermal: Runtime PM disabled, clock forced on.
> >>>>rcar_thermal rcar_thermal: 3 sensor probed
> >>>>sh_mobile_sdhi sh_mobile_sdhi.0: Runtime PM disabled, clock forced on.
> >>>>sh_mobile_sdhi sh_mobile_sdhi.0: No vqmmc regulator found
> >>>>
> >>>>I re-ran my bisection and this time the following showed up as the culprit.
> >>>>
> >>>>I suspect that the initialisation of mmcif, which is usually the next
> >>>>device to be initialised, sleeps and never wakes up because the timer is
> >>>>disabled.
> >>>>
> >>>>commit c387f07e6205cc13f57c1def5f885bf0a20e1c2d
> >>>>Author: Sudeep Holla <sudeep.holla@arm.com>
> >>>>Date:   Mon Sep 29 01:50:05 2014 +0200
> >>>>
> >>>>     clocksource: arm_arch_timer: Discard unavailable timers correctly
> >>>
> >>>Apparently reported and fixed by Laurent and a few others, cfr.
> >>>http://www.spinics.net/lists/arm-kernel/msg371615.html
> >
> >I have temporarily cherry-picked the following, which is no present in
> >linux-next, into the devel branch of the renesas tree. It appears to
> >resolve the problem I reported.
> >
> >b0ad5917960ca80f96bae ("ARM/ARM64: arch-timer: fix arch_timer_probed logic")
> 
> Yes, that is the right one.
> 
> This patch is now upstream and will be in -rc3.

Thanks, I see it in -rc3 now.
