Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaLVQ2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29816 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:20 -0500
X-AuditID: cbfee61a-f79c06d000004e71-71-549846a18974
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 0/8] hwmon: thermal: Odroid U3: Provide support for Odroid
 U3 fan
Date: Mon, 22 Dec 2014 17:27:40 +0100
Message-id: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jAd2FbjNCDO7MNrN4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAlTFr4kHGgnP8FV/eHWRtYJzO08XIySEhYCKxcFUHI4QtJnHh3nq2LkYu
	DiGBRYwSHw/9Z4VwupgkHjYcBqtiE9CT+Hz3KRNIQkRgBqPE/qZv7CAOs8AVZolvpxpZQKqE
	BcIknr/rYAKxWQRUJV6/72cGsXkF3CT+777LArFPUaL72QQ2EJtTwF1iznMIWwiopunvJeYJ
	jLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH7jOpHYwrGywOMQpwMCrx8HKkTQ8R
	Yk0sK67MPcQowcGsJMJ71XJGiBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB9MSS1OzU
	1ILUIpgsEwenVAOjeLvGy4VXbbJTp8rNP2RpX9/53KfphkJ/1a2lzZPmZy1PVD70M1MlvNKv
	dr2adbTjAV33q8ubQvdsWJ8yO8HmKfORF/uSdleq/vhxoHmlz2whtzcHq9WMpkbzSm9bc6zr
	S/2yVx++Vs2JT82PcIh/NydG5V6boLWC3Zfjbsu/vHgt7Rn8gT1PiaU4I9FQi7moOBEAAgtg
	/lgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presented patches add support for Odroid's U3 optional CPU FAN, which uses PWM
subsystem for low level control.

After successful probe it registers itself as a cooling device for thermal
subsystem. To preserve the ability to use this fan as a PWM device stubs for
thermal_of_cooling_device_register() and thermal_cdev_update() have been added.

Additionally, devices without support for DTS are still supported.

To provide correct functionality, new properties to device tree description for 
Exynos4412 and in particular Odroid U3 have been added.

Those patches were tested on Exynos4412 - Odroid U3 board.

Patches were applied on:
linux-soc-thermal/next branch
SHA1: d8c3cd75e77d8033b29470525781befc11b6bf7d

with following preceding patch series:
'thermal: exynos: Thermal code rework to use device tree'
http://www.spinics.net/lists/linux-samsung-soc/msg37719.html

Presented code utilize reworked Exynos thermal subsystem.

Kamil Debski (1):
  ARM: dts: Add pwm-fan node to the Odroid-U3 board

Lukasz Majewski (7):
  thermal: Provide stub for thermal_of_cooling_device_register()
    function
  thermal: Provide stub for thermal_cdev_update() function
  hwmon: dts: Doc: Add DTS doc to explain how to use PWM FAN as a
    cooling device
  hwmon: thermal: dts: Add properties to use pwm-fan device as a cooling
    device in Odroid U3
  hwmon: thermal: Extract __set_pwm() function to only modify PWM duty
    cycle
  hwmon: thermal: Read PWM FAN configuration from device tree
  hwmon: thermal: Code for using PWM FAN as a cooling device

 .../devicetree/bindings/hwmon/pwm-fan.txt          |  23 +++
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |  44 ++++++
 drivers/hwmon/pwm-fan.c                            | 166 +++++++++++++++++++--
 include/linux/thermal.h                            |  20 ++-
 5 files changed, 235 insertions(+), 20 deletions(-)

-- 
2.0.0.rc2

