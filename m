Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3JCQoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:44:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33920 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3JCQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:43:59 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH V5 0/6] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
References: <1368039976-29648-1-git-send-email-nm@ti.com>
Date: Thu, 03 Oct 2013 09:43:55 -0700
In-Reply-To: <1368039976-29648-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Wed, 8 May 2013 14:06:10 -0500")
Message-ID: <87pprmuwxg.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

Nishanth Menon <nm@ti.com> writes:

> The following version 5 of the series arose from trying to use
> BeagleBoard-XM (OMAP3 variant) for doing CPU DVFS using cpufreq-cpu0.
> This series enables the generic cpufreq-cpu0 driver to be used in
> device tree enabled boot while maintaining support of the legacy
> omap-cpufreq driver when used in non device tree enabled boot.

What's the status of this series?  Is it still waiting on the clock DT
changes?

Kevin

> However, in order to enable complete SoC entitlement for OMAP
> platforms, with this series, key features are still pending on device
> tree adaptation for OMAP:
> A) clock framework data transition to DT - this series provides an
> driver to allow device tree definition of clock node.
> B) On processors that use voltage controller, voltage processor
> (VC/VP hardware loop using I2C_SR path) - we have started work on
> transitioning them to regulator framework driven by DT.
> C) Adaptive Body Bias[2] and SmartReflex AVS conversion to DT.
>
> Note: Common Clock Framework(CCF) could also control regulators[3] and
> AVS to ensure proper sequencing required for full DVFS sequencing.
> Once these conversions are complete, there might be minimal cleanup
> work to switch to the new data structure changes.
>
> Key benefit of the series is to allow all relevant TI platforms now to
> use a single cpufreq driver and equivalent frameworks in addition be
> part of the transition to device tree.
>
> NOTE on this series:
> 1. omap-cpufreq will be used only in non device tree boot scenario. we
> should delete this driver once the 100% DT conversion is complete.
> 2. Generic cpufreq-cpu0 will be used only in device tree boot scenario
> boot systems
> 3. clock data movement as approached by Tero in [4] is not the
> objective of this series
> 4. meant for post 3.10-rc1 tag
>
> Key changes in version 5 since version 4:
> 	- rebase with master for 3.10-rc1 intermediate
> 	- review comments incorporated
>
> version 4 of the series:
> 	http://marc.info/?l=linux-arm-kernel&m=136580742724210&w=2
> 	available at:
> 	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v4
>
> version 3 of the series:
> 	http://marc.info/?l=linux-pm&m=136450759315742&w=2
> 	available at:
> 	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v3
>
> version 2 of the series:
> 	http://marc.info/?t=136371570200003&r=1&w=2
> 	available at:
> 	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v2
>
> version 1 of the series:
> 	http://marc.info/?t=136329485400005&r=1&w=2
> 	available at:
> 	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v1
>
> [1] Original discussion thread which triggered this series:
> 	http://marc.info/?l=linux-pm&m=136304313700602&w=2
> 	https://patchwork.kernel.org/patch/2251841/
> 	https://patchwork.kernel.org/patch/2251851/
> [2] ABB series: http://marc.info/?l=linux-omap&m=136751559523901&w=2 (ABB DTS merge pending)
> [3] CCF DVFS patches:
> https://patchwork.kernel.org/patch/2195431/
> https://patchwork.kernel.org/patch/2195421/
> https://patchwork.kernel.org/patch/2195451/
> https://patchwork.kernel.org/patch/2195441/
> https://patchwork.kernel.org/patch/2195461/
> [4] http://marc.info/?t=136388745000001&r=1&w=2
>
> Version 5 is now based on master since all requisite for-next branches have been merged.
> 	master 5af43c2 Merge branch 'akpm' (incoming from Andrew)
>
> Version 4 is also available at:
> 	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v5
> 	git link: git://github.com/nmenon/linux-2.6-playground.git
> 	branch: cpufreq-cpu0-omap-all-v5
>
> Test coverage:
> 	test script:  http://pastebin.com/GsavxiDe
> 	(note - to allow testing, I followed the suggestion in https://lkml.org/lkml/2013/5/8/19 )
>
> Platforms verified:
> 	beaglebone(rev A6a) - AM33xx compatible - http://pastebin.com/zANKsYBp
> 	beagleboard (rev C1D) - OMAP3430 compatible
> 		- DT enabled boot:  http://pastebin.com/q4qZYVaK
> 		- No DT enabled boot: http://pastebin.com/c1CbQmV5
> 	omap3-beagle-xm -OMAP3630 compatible - http://pastebin.com/ibUABcA0
> 	SDP4430 -(OMAP4430 ES2.2) - http://pastebin.com/wYwUc3fU
> 	Pandaboard-ES -(OMAP4460 ES1.1) - http://pastebin.com/FB2RiFp2
>
> Nishanth Menon (6):
>   clk: OMAP: introduce device tree binding to kernel clock data
> [Clk driver probably belongs to mike's tree?]
>   ARM: dts: OMAP3: add clock nodes for CPU
>   ARM: dts: OMAP4: add clock nodes for CPU
>   ARM: dts: AM33XX: add clock nodes for CPU
> [The above probably belong to Benoit's tree]
>   ARM: OMAP2+: AM33XX: add lateinit hook for calling pm late init
>   ARM: OMAP3+: use cpu0-cpufreq driver in device tree supported boot
> [The above probably belong to Kevin/Tony's tree]
>
>  .../devicetree/bindings/clock/omap-clock.txt       |   40 +++++++++
>  arch/arm/boot/dts/am33xx.dtsi                      |    7 ++
>  arch/arm/boot/dts/omap3.dtsi                       |    7 ++
>  arch/arm/boot/dts/omap4.dtsi                       |    7 ++
>  arch/arm/mach-omap2/board-generic.c                |    1 +
>  arch/arm/mach-omap2/cclock33xx_data.c              |    1 -
>  arch/arm/mach-omap2/common.h                       |    1 +
>  arch/arm/mach-omap2/io.c                           |    6 ++
>  arch/arm/mach-omap2/pm.c                           |   11 ++-
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/omap/Makefile                          |    1 +
>  drivers/clk/omap/clk.c                             |   91 ++++++++++++++++++++
>  12 files changed, 170 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
>  create mode 100644 drivers/clk/omap/Makefile
>  create mode 100644 drivers/clk/omap/clk.c
>
> Regards,
> Nishanth Menon
