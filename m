Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaJKH3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 03:29:45 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:37251 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaJKH3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 03:29:41 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <cdf7a7877f294e6c7e0cd53ee6f89b42>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v9 0/5] Rockchip soc thermal driver
Date: Sat, 11 Oct 2014 15:29:18 +0800
Message-Id: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patchs tested on rk3288 SDK board and pinky-v1,v2 board.
I believe the driver can be used on the rk3288-evb board.

Add this driver, The system can reset the entire chip when
the thermal temperture over 120C, In case of rising over 125C
when tha hardware shorting,The sodftware will shutdown via "critical".

Changes in v9:
	* address comments from Dmitry Torokhov.
	- fix some style be defined
	- remove some unused code.
	- clk_disable_unprepare->clk_disable in suspend()

Changes in v8:
	* address comments from Dmitry Torokhov and Doug Anderson.
	- add three Teperture Sensors.
	- support CRU and GPIO reset chip.
	- rename rk3xxx-cpu-thermal.dtsi as rk3288-thermal.dtsi
	- alarm-temp via set_trips() callback
	- remove "reset-gpios"

Changes in v7:
	- fix get data->clk=0 when in probe() function.
	- fix some style code.
	- modify dts,main add rk3xxx-cpu-thermal.dtsi

Changes in v6:
	* address comments from Tomeu Vizoso.
	- use thermal's generic framework.

Changes in v5:
	* address comments from Eduardo Valentin,rui.zhang and Heiko Stubner:
	- with BIT() macro
	- manage clocks in suspend/resume.
	- license is fixed as GPLv2.
	- #include "thermal_core.h"->#include <linux/thermal.h>
	- use the generic trip-points.the hw-shut-temp isn't generic trip-points.
	- The method of binding and unbinding be fixed.
	- The pin-name tsadc->otp_out

Changes in v4:
	* address comments from Jonathan Cameron,huangtao and zhaoyifeng:
	- this series thermal driver still be put in driver/thermal/
	- modify the thermal driver description.

Changes in v3:(add dts configure)
	* address comments from Dmitry Torokhov and Arnd Bergmann:
	- fix clock-names in rockchip-thermal.txt
	- remove rockchip_thermal_control() in rockchip_set_mode()
	- fix some code style.
	- add dts configure.

Changes in v2:
	* address comments from Heiko Stubner:
	- fix dt-bindings in rockchip-thermal.txt
	- remove Author mark
	- rename TSADC_XXX->TSADCV2_XXX,it eill ready to merge compatible other SoCs.
	- fix a identation
	- remove clk_set_rate(),it's no necessary.
	- fix the SIMPLE_DEV_PM_OPS() function  style.

Caesar Wang (5):
  thermal: rockchip: add driver for thermal
  dt-bindings: document Rockchip thermal
  ARM: dts: add RK3288 Thermal data
  ARM: dts: add main Thermal info to rk3288
  ARM: dts: enable Thermal on rk3288-evb board

 .../bindings/thermal/rockchip-thermal.txt          |  45 ++
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   5 +
 arch/arm/boot/dts/rk3288-thermal.dtsi              |  58 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  23 +
 drivers/thermal/Kconfig                            |   9 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/rockchip_thermal.c                 | 628 +++++++++++++++++++++
 7 files changed, 769 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
 create mode 100644 drivers/thermal/rockchip_thermal.c

-- 
1.9.1


