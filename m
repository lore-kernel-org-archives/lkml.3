Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaJITMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:12:55 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60725 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaJITM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:29 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        AnilKumar Ch <anilkumar@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 00/12] rtc: omap: fixes and power-off feature
Date: Thu,  9 Oct 2014 21:06:22 +0200
Message-Id: <1412881594-25678-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a few issues with the omap rtc-driver, cleans up a bit
and finally adds support for the PMIC control feature found in some
revisions of this RTC IP block.

Ultimately, this allows for powering off the Beaglebone and waking it up
again on RTC alarms.

I noticed yesterday that Lokesh Vutla recently posted some patches to
add regulator support to this driver. [1] While that series has some
issues that needs to be addressed, I still think it could be a good idea
to rebase my pmic_power_en patch on top of it as it adds some long
overdue device abstraction. That would be needed anyway in order to
support the new power-off infrastructure that's in the pipe in a clean
way. [2]

So my suggestion is to merge the first seven patches, rebase Lokesh
series on top of that, and then I rebase my final five patches on top
of that in turn. Hopefully, the new power-off handler call chain will
have stabilised by then.

Johan

[1] http://www.spinics.net/lists/devicetree/msg50869.html
[2] https://lkml.org/lkml/2014/10/7/30


Johan Hovold (12):
  rtc: omap: fix clock-source configuration
  rtc: omap: fix missing wakealarm attribute
  rtc: omap: fix class-device registration
  rtc: omap: remove unused register-base define
  rtc: omap: remove redundant debug message
  rtc: omap: use dev_info and dev_dbg
  rtc: omap: silence bogus power-up reset message at probe
  rtc: omap: restore irq state after reading TC registers
  rtc: omap: add support for pmic_power_en
  rtc: omap: enable wake-up from power off
  ARM: dts: am33xx: update rtc node compatible property
  ARM: dts: am335x-bone-common: enable power off and rtc wake up

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |   9 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |   4 +
 arch/arm/boot/dts/am33xx.dtsi                      |   2 +-
 drivers/rtc/rtc-omap.c                             | 202 ++++++++++++++++-----
 4 files changed, 173 insertions(+), 44 deletions(-)

-- 
2.0.4

