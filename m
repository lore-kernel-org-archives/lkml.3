Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaEMWQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:16:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55527 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaEMWPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:15:49 -0400
Message-ID: <5372998F.6020502@wwwdotorg.org>
Date: Tue, 13 May 2014 16:15:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems#
References: <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>	<CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>	<alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>	<20140508192209.GH3693@n2100.arm.linux.org.uk>	<alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>	<20140508205223.GI3693@n2100.arm.linux.org.uk>	<alpine.LFD.2.11.1405082058130.980@knanqh.ubzr>	<20140509091824.GL3693@n2100.arm.linux.org.uk>	<alpine.LFD.2.11.1405091245070.980@knanqh.ubzr>	<20140509182245.GM3693@n2100.arm.linux.org.uk>	<alpine.LFD.2.11.1405091640090.980@knanqh.ubzr>	<CAD=FV=UJK1nSPjH-au-KtbnOZk2nC7usLD8L9neMedj6WHUp8g@mail.gmail.com> <CAD=FV=XM2URyJjV9gaE=mrp7LAEGtvi9wQGhGJi3_HYp_XzYWg@mail.gmail.com>
In-Reply-To: <CAD=FV=XM2URyJjV9gaE=mrp7LAEGtvi9wQGhGJi3_HYp_XzYWg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 03:50 PM, Doug Anderson wrote:
...
> ...but then I found the true problem shows up when we transition
> between very low frequencies on exynos, like between 200MHz and
> 300MHz.  While transitioning between frequencies the system
> temporarily bumps over to the "switcher" PLL running at 800MHz while
> waiting for the main PLL to stabilize.  No CPUFREQ notification is
> sent for that.  That means there's a period of time when we're running
> at 800MHz but loops_per_jiffy is calibrated at between 200MHz and
> 300MHz.
> 
> 
> I'm welcome to any suggestions for how to address this.  It sorta
> feels like it would be a common thing to have a temporary PLL during
> the transition, ...

We definitely do that on Tegra for some cpufreq transitions.
