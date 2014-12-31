Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLaDTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:19:19 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55673 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaLaDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:19:17 -0500
MIME-Version: 1.0
In-Reply-To: <54A34538.2020802@gmx.de>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
 <1412773376-25212-3-git-send-email-wens@csie.org> <54A34538.2020802@gmx.de>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 31 Dec 2014 11:18:56 +0800
X-Google-Sender-Auth: GgRlkfQA6f8NcRbmtzEpDybgI7I
Message-ID: <CAGb2v65TOm6WGNB0yVF4Ujnc7RDime7jVenWSTXtysXNuT0-=g@mail.gmail.com>
Subject: Re: ARM: dts: sun9i: Allwinner A80 dtsi - missing clock-frequency property
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 8:37 AM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> When booting Linux 3.19-rc2 on a Merrii Optimusboard using
> arch/arm/boot/dts/sun9i-a80-optimus.dts adn arch/arm/boot/dts/sun9i-a80.dtsi
> I get errors
> [    0.061192] /cpus/cpu@0 missing clock-frequency property
> [    0.061209] /cpus/cpu@1 missing clock-frequency property
> [    0.061223] /cpus/cpu@2 missing clock-frequency property
> [    0.061237] /cpus/cpu@3 missing clock-frequency property
> [    0.061251] /cpus/cpu@100 missing clock-frequency property
> [    0.061266] /cpus/cpu@101 missing clock-frequency property
> [    0.061283] /cpus/cpu@102 missing clock-frequency property
> [    0.061300] /cpus/cpu@103 missing clock-frequency property

The clock-frequency property is in no way connected to clocks
or cpufreq on Linux. It is solely used to generate a topology
map for multi-cluster systems. Personally I prefer the
cpu-topology bindings on arm64, but this is what we have.

> The dtsi was provided by patch
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4ab328f06e305bf3ea254f4e3c94bb4d820998c1
>
> According to file pack/chips/sun9iw1p1/optimus/sys_config.fex supplied in
> the OptimusBoard SDK the big cluster can run at up to 1800 MHz, and
> the LITTLE cluster can run at up to 1200 MHz,depending on the CPU voltage:
>
> big
> 1.08V (1608Mhz, 1800Mhz]
> 1.00V (1536Mhz, 1608Mhz]
> 0.96V (1440Mhz, 1536Mhz]
> 0.90V (1296Mhz, 1440Mhz]
> 0.84V (   0Mhz, 1296Mhz]
>
> LITTLE
> 1.02V (1128Mhz, 1200Mhz]
> 0.96V (1008Mhz, 1128Mhz]
> 0.90V ( 864Mhz, 1008Mhz]
> 0.84V (   0Mhz,  864Mhz]
>
> I guess the proper way to specify the data is the one described in
> Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt

cpufreq requires a bit more than just specifying the operating
points. Moreover, SMP is not supported on sun9i yet. For DVFS
we also need support for the PMICs.

> Other boards might run at other frequencies. Hence we might want to put this
> information into the board file
> arch/arm/boot/dts/sun9i-a80-optimus.dts.

We can also give a default set of OPP in the dtsi, and any boards
having special voltage requirements can override them or use the
voltage-derivation property (not sure that's the name).

> Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt,
> arch/arm/boot/dts/exynos5260.dtsi, and
> arch/arm/boot/dts/exynos5420.dtsi, all assume that
> cpu@0-cpu@3 are A15 (big) and cpu@101-cpu@103 are A7 (LITTLE).
>
> Shouldn't arch/arm/boot/dts/sun9i-a80.dtsi stick to this convention?

This is not some convention. The values match what the hardware
says in the MPIDR.


ChenYu

> The scripts to create the uImage and to reproduce the problem are in
> https://github.com/xypron/kernel-optimusboard/tree/35d06c020f6584b5023e0e4bef67cc5a625f65bb
>
> Best regards
>
> Heinrich Schuchardt
>
>
