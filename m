Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaIBUAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:00:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54556 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbaIBUAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:00:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v7 0/5] Add rockchip RK808 pmic driver
Date: Tue, 02 Sep 2014 21:40:24 +0200
Message-ID: <5901915.IMKhU0yJur@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. September 2014, 17:07:43 schrieb Chris Zhong:
> This is the initial version of the RK808 PMIC. This is a power management IC
> for multimedia products.
> 
> It provides regulators that are able to supply power to processor cores
> and other components. The chip provides other modules including RTC,
> Clockout

The whole series on a 3-17-rc1 with the already applied regulator commits 
pulled in and used by my pending cpufreq patches to set the core voltage

Tested-by: Heiko Stuebner <heiko@sntech.de>



> 
> Changes in v7:
> Advices by Mark Rutland
> - modify description about clock-cells
> - update the example
> Adviced by Lee Jones
> - coding style
> - remove rk808_pre_init function
> Adviced by Doug
> - add "&& OF" to the dependencies
> - add .init_ack_masked = true in rk808_irq_chip
> Adviced by doug
> - read rtc time from shadowed registers
> Adviced by Dmitry
> - use CONFIG_PM_SLEEP replace CONFIG_PM
> - use SIMPLE_DEV_PM_OPS replace dev_pm_ops
> - fix dev_warn
> - coding style
> Adviced by Heiko
> - remove rtc_ctl
> Adviced by doug
> -fix coding style problems
> - remove pdata struct from header file, add rk808_regulator struct
> 
> Changes in v6:
> Advices by Mark Rutland
> - add description about clock-cells
> Advices by Doug
> - modify description about regulator
> - remove pinctrl description
> Adviced by Lee Jones in v2
> - rk808_i2c_client instead of g_rk808
> - remove pdata form struct rk808
> Adviced by doug
> - move RTC_READSEL setting into probe
> Adviced by doug
> - use correct argument call of_clk_add_provider in probe
> - remove the redundant code
> 
> Changes in v5:
> Advices by Mark Brown
> - add description about regulator valid name.
> - add a header file "rockchip,rk808".
> - fixed a bug about set_time failed
> Adviced by doug
> - add some error checking in probe
> - move "rockchip,rk808.h" into the patch about dt-bindings
> - re-edit base on Mark's branch
> 
> Changes in v4:
> Advices by Doug
> - add a "#clock-cells" propertiy
> - update the example
> Adviced by Lee Jones in v2
> - modify the description in Kconfig
> - remove some unnecessary header files
> - remove dev from struct rk808
> - use enum for define RK808_ID...
> - use &client->dev replace rk808->dev
> Adviced by doug
> - add "clock-output-names" propertiey
> - add a header file "rockchip,rk808.h"
> - use &client->dev replace rk808->dev
> 
> Changes in v3:
> - fix compile err
> - fix compile err
> 
> Changes in v2:
> Adviced by Mark Browm:
> - use defines for register setting value
> - remove rtc alarm disable in shutdown
> - remove while(1) in shutdown
> - remove read 0x2f in probe
> Adviced by javier.martinez
> - Add a separate clock driver, rather than in RTC driver
> Adviced by javier.martinez
> - separated from rtc-rk808.c
> Adviced by Mark Browm:
> - change of_find_node_by_name to find_child_by_name
> - use RK808_NUM_REGULATORS as the name of the constant
> - create a pdata when missing platform data
> - use the rk808_reg name to supply_regulator name
> - replace regulator_register with devm_regulator_register
> - some other problem with coding style
> 
> Chris Zhong (5):
>   dt-bindings: Add RK808 device tree bindings document
>   MFD: RK808: Add new mfd driver for RK808
>   RTC: RK808: add RTC driver for RK808
>   clk: RK808: Add clkout driver for RK808
>   regulator: RK808: Remove pdata from the regulator
> 
>  Documentation/devicetree/bindings/mfd/rk808.txt |  166 +++++++++
>  drivers/clk/Kconfig                             |    9 +
>  drivers/clk/Makefile                            |    1 +
>  drivers/clk/clk-rk808.c                         |  160 +++++++++
>  drivers/mfd/Kconfig                             |   13 +
>  drivers/mfd/Makefile                            |    1 +
>  drivers/mfd/rk808.c                             |  243 +++++++++++++
>  drivers/regulator/rk808-regulator.c             |   52 ++-
>  drivers/rtc/Kconfig                             |   10 +
>  drivers/rtc/Makefile                            |    1 +
>  drivers/rtc/rtc-rk808.c                         |  419
> +++++++++++++++++++++++ include/dt-bindings/clock/rockchip,rk808.h      |  
> 11 +
>  include/linux/mfd/rk808.h                       |  196 +++++++++++
>  13 files changed, 1250 insertions(+), 32 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>  create mode 100644 drivers/clk/clk-rk808.c
>  create mode 100644 drivers/mfd/rk808.c
>  create mode 100644 drivers/rtc/rtc-rk808.c
>  create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
>  create mode 100644 include/linux/mfd/rk808.h

