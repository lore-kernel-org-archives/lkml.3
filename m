Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaGKPdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:33:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57068 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaGKPc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:32:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
Cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>, devicetree@vger.kernel.org,
        "Tuomas Tynkkynen" <ttynkkynen@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
Message-ID: <20140711153250.9850.23148@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 00/13] Tegra124 CL-DVFS / DFLL clocksource, plus cpufreq
Date: Fri, 11 Jul 2014 08:32:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tuomas Tynkkynen (2014-07-10 14:42:36)
> This series implements the DFLL/CL-DVFS clock source for the fast CPU
> cluster on Tegra124, and a cpufreq driver that uses the DFLL for
> clocking the CPU. Most of this is based on Paul Walmsley's public patch
> set from December 2013, which is available at
> http://comments.gmane.org/gmane.linux.ports.tegra/15273
> 
> The DFLL clock hardware is a voltage-controlled oscillator plus
> control logic that compares the generated output clock with a
> 51 MHz reference clock, and can make decisions to either lower
> or raise the DFLL voltage to keep the output rate close to the
> software-requested rate. The voltage changes are done by
> communicating with an off-chip PMIC via either I2C or PWM.
> As the DFLL oscillator is powered via the CPU rail, using
> the DFLL as the CPU clocksource also gives us dynamic CPU
> voltage scaling.

Clock driver bits look good to me. CVB table stuff is pretty neat.

Regards,
Mike

> 
> This series has been tested on the Jetson TK1 (Rev C). Before attempting
> to port this to the Venice2, do note that there are two versions of the
> AS3722 with different voltage tables for the CPU rail (and that Venice2
> does not have active cooling).
> 
> Thanks,
> Tuomas
> 
> Paul Walmsley (1):
>   clk: tegra: Add DFLL DVCO reset control for Tegra124
> 
> Tuomas Tynkkynen (12):
>   clk: tegra: Add binding for the Tegra124 DFLL clocksource
>   clk: tegra: Add library for the DFLL clock source (open-loop mode)
>   clk: tegra: Add closed loop support for the DFLL
>   clk: tegra: Add functions for parsing CVB tables
>   clk: tegra: Add Tegra124 DFLL clocksource platform driver
>   clk: tegra: Save/restore CCLKG_BURST_POLICY on suspend
>   clk: tegra: Add the DFLL as a possible parent of the cclk_g clock
>   ARM: tegra: Add the DFLL to Tegra124 device tree
>   ARM: tegra: Enable the DFLL on the Jetson-TK1
>   cpufreq: tegra124: Add device tree bindings
>   cpufreq: Add cpufreq driver for Tegra124
>   ARM: tegra: Add entries for cpufreq on Tegra124
> 
>  .../bindings/clock/nvidia,tegra124-dfll.txt        |   86 +
>  .../bindings/cpufreq/tegra124-cpufreq.txt          |   37 +
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   83 +-
>  arch/arm/boot/dts/tegra124.dtsi                    |   29 +
>  arch/arm/mach-tegra/Kconfig                        |    1 +
>  drivers/clk/tegra/Makefile                         |    3 +
>  drivers/clk/tegra/clk-dfll.c                       | 1759 ++++++++++++++++++++
>  drivers/clk/tegra/clk-dfll.h                       |   55 +
>  drivers/clk/tegra/clk-tegra-super-gen4.c           |    4 +-
>  drivers/clk/tegra/clk-tegra124-dfll-fcpu.c         |  156 ++
>  drivers/clk/tegra/clk-tegra124.c                   |   61 +
>  drivers/clk/tegra/clk.h                            |    3 +
>  drivers/clk/tegra/cvb.c                            |  133 ++
>  drivers/clk/tegra/cvb.h                            |   67 +
>  drivers/cpufreq/Makefile                           |    1 +
>  drivers/cpufreq/tegra124-cpufreq.c                 |  221 +++
>  16 files changed, 2697 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
>  create mode 100644 drivers/clk/tegra/clk-dfll.c
>  create mode 100644 drivers/clk/tegra/clk-dfll.h
>  create mode 100644 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
>  create mode 100644 drivers/clk/tegra/cvb.c
>  create mode 100644 drivers/clk/tegra/cvb.h
>  create mode 100644 drivers/cpufreq/tegra124-cpufreq.c
> 
> -- 
> 1.8.1.5
> 
