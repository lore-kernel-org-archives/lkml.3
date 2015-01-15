Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbbAOLa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:30:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34576 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:30:06 -0500
Date: Thu, 15 Jan 2015 11:29:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
Message-ID: <20150115112938.GB16217@leverpostej>
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
 <54B69072.4080607@kernel.org>
 <54B692FB.7030703@linaro.org>
 <54B7024C.4020407@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7024C.4020407@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:57:00PM +0000, Chanwoo Choi wrote:
> Hi Kukjin,
> 
> On 01/15/2015 01:02 AM, Daniel Lezcano wrote:
> > On 01/14/2015 04:51 PM, Kukjin Kim wrote:
> >> On 01/14/15 14:33, Chanwoo Choi wrote:
> >>
> >> Hi,
> >>
> >> + Doug, Olof
> >>
> >>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
> >>> for Exynos 32bit SoC.
> >>>
> >> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
> >> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
> >> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
> >> implemented it and additionally its access is faster than using memory
> >> mapped register called SFR for MCT...so Doug submitted patch to use MCT
> >> on 32bit exynos SoCs before.
> 
> I know arch_timer. As you comment, ARCH timer would be used for system timer for ARMv8.
> But, Exynos5433/Exynos7 (ARMv8) include MCT (Multi-Core Timer) IP. I checked it on
> Exynos5433/EXynos7 User-manaual and tested it.
> 
> I think that exynos_mct.c should support the Exynos 64-bit SoC
> because Exynos5433/Exynos7 include already MCT (Multi-Core Timer) IP.
> 
> Also, I have a problem to verify ARCH timer on Exynos SoC. Exynos User-manual never includes
> the detailed information about for ARCH timer(e.g, clock for ARCH timer). I knew that
> I can get the document of ARCH timer for ARM official site but I think it is insufficient
> to implement ARCH timer on Exynos SoC. 

What do you mean by "insufficient to implement ARCH timer"?

The architected timer is mandatory in ARMv8, and required by the arm64
kernel.

Additional timers may be requried if you want to put all CPUs into low
power states where the timer logic may be disabled and/or lose state,
but regardless the architected timers are necessary.

Thanks,
Mark.
