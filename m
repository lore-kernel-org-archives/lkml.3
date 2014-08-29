Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaH2LWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:22:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbaH2LWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:22:52 -0400
Date: Fri, 29 Aug 2014 12:22:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Huang Tao <huangtao@rock-chips.com>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [RESEND PATCH] ARM: dts: make arch-timer always on in rk3288 soc
Message-ID: <20140829112242.GC21473@leverpostej>
References: <1409190017-12656-1-git-send-email-kever.yang@rock-chips.com>
 <20140828091758.GB14650@leverpostej>
 <20140828151121.GM14650@leverpostej>
 <53FFEE40.3010001@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FFEE40.3010001@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 04:06:40AM +0100, Huang Tao wrote:
> Hi, Mark:

Hi,

> 在 2014年08月28日 23:11, Mark Rutland 写道:
> > To clarify: if there are low power states that the CPU can enter where
> > we lose state, then this patch isn't correct.
> Right now, the software of RK3288 SoC only support CPU hotplug
> (cpu_on/off) and power off all CPUs on suspend.

Sure, but that's a Linux implementation detail rather than a fixed
property of the hardware. Given those states exist, the "always-on"
property is not appropriate.

> We do not implement cpuidle to power off CPU. Do you think we should
> introduce a broadcast timer?

If one is present, yes. 

> On our early kernel, I never see any interrupt on a broadcast timer
> (yes, we implement it with a external timer).

That's fine; Linux doesn't need to use it just yet. However, when we
want to use low power states later, it will be necessary to enable
placing all CPUS into a low power state.

If your external timer is already supported by an existing driver, there
is no reason not to add it now.

> > A more general approach would be to enable the broadcast hrtimer for
> > arm, as has been done for arm64.
> Yes. I think it should be done by arm framework.

Patches welcome.

I also think it would make sense to enable this for arm.

Thanks,
Mark.
