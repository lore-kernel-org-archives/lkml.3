Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaLRKNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:13:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54295 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaLRKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:13:34 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-96-5492a8cb39ae
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
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 0/9] hwmon: thermal: Odroid U3: Provide support for Odroid U3
 fan
Date: Thu, 18 Dec 2014 11:13:02 +0100
Message-id: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd0zKyaFGDQ1sFjMP3KO1WL+lWus
	FkvvfmKz+PH6AptF74KrbBZvHnFbvHm4mdHi8q45bBafe48wWsw4v4/J4snCM0wWd6btZbM4
	/Kad1YHXY+esu+weDybuZvNYN+0ts8fO7w3sHn1bVjF6bD5d7fF5k1wAexSXTUpqTmZZapG+
	XQJXxvqmLvaCZfwVv6+9YGpgfMbdxcjJISFgIrHr3RY2CFtM4sK99UA2F4eQwHRGiY5t/5lB
	EkICXUwSL/vtQGw2AT2Jz3efMoEUiQjMYJTY3/SNHcRhFvjOJNG0dSkLSJWwQLBE942/rCA2
	i4CqxJ1TO8Em8Qq4SXRfn8oOsU5RovvZBLYJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgQH3TPpHYyrGiwOMQpwMCrx8EroTQoRYk0sK67MPcQowcGsJMIbnQMU4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi4JRqYOTbwJH2/aNEuoXXF/74N0pc
	KcLHNgfwxV482bgwYM+miTsYCsz+Ny3+eHjbSp5GdeWZtYzXqopPHqlM1b22sowxuehW5ylN
	n6JZVdMOnmU9xPTzYoLsZnG2zPXCLp9W3IiO2LFvxUa9rulscUF967WCZnOnKDbvUgisORy3
	L9vgrImlh9ZqeyWW4oxEQy3mouJEACLD45E2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presented patches add support for Odroid's U3 optional CPU FAN, which uses PWM
subsystem for low level control.

After successful probe it registers itself as a cooling device for thermal
subsystem. To preserve ability to use this fan as a PWM device a stub for
thermal_of_cooling_device_register() has been added.

Moreover, some entries to device tree description for Exynos4412 and in
particular Odroid U3 have been added.

Those patches were tested on Exynos4412 - Odroid U3 board.

Patches were applied on:

linux-soc-thermal/next branch
SHA1: c42c7a44c7a543dcb388c1ee1a798e6ed76ad8cf

with following preceding patch series:
'thermal: exynos: Thermal code rework to use device tree'
http://www.spinics.net/lists/linux-samsung-soc/msg37719.html

Presented code utilize reworked Exynos thermal subsystem.


Kamil Debski (1):
  ARM: dts: Add pwm-fan node to the Odroid-U3 board

Lukasz Majewski (8):
  thermal: Provide stub for thermal_of_cooling_device_register()
    function
  hwmon: dts: Doc: Add DTS doc to explain how to use PWM FAN as a
    cooling device
  hwmon: thermal: dts: Add properties to use pwm-fan device as a cooling
    device in Odroid U3
  hwmon: thermal: Extract __set_pwm() function to only modify PWM duty
    cycle
  hwmon: thermal: Read PWM FAN configuration from device tree
  hwmon: thermal: Code for using PWM FAN as a cooling device
  hwmon: thermal: Provide 'default-pulse-width' property to setup FAN on
    boot
  hwmon: thermal: dts: Disable FAN on boot on the Odroid U3

 .../devicetree/bindings/hwmon/pwm-fan.txt          |  28 +++
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |  45 +++++
 drivers/hwmon/pwm-fan.c                            | 195 +++++++++++++++++----
 include/linux/thermal.h                            |  14 +-
 5 files changed, 249 insertions(+), 35 deletions(-)

-- 
2.0.0.rc2

