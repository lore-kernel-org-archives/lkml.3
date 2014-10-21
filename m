Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaJURrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:47:20 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59788 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413AbaJURo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:58 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Date: Tue, 21 Oct 2014 19:37:46 +0200
Message-Id: <1413913086-12730-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a few issues with the omap rtc-driver, cleans up a
bit, adds device abstraction, and finally adds support for the PMIC
control feature found in some revisions of this RTC IP block.

Ultimately, this allows for powering off the Beaglebone and waking it up
again on RTC alarms.

Changes since v1 include:

 - add device abstraction
 - add structured device-type info
 - fix interrupt disable at probe separately
 - register interrupts after class device as before
 - add helper to read raw bcd time
 - more clean ups
 - add copyright entry
 - enable pmic control only for Beaglebone Black

I realised that it was better to keep this patch series self-contained
and include the device abstraction in it, rather than rely on some
patches yet to be posted (contrary to what I proposed in v1). It should
now be straight forward to add deferred-probing and regulator support on
top of this series instead. [1]

I've kept Felipe's Reviewed-by tags only on the first and last couple of
patches which have not changed (in any significant way).

For the record, the new functionality is easily tested on BBB with:

	echo +30 >/sys/class/rtc/rtc0/wakealarm; poweroff

There are some patches floating around to add power-off handler
call chains [2] as well as an RFC for a generic "poweroff-source"
property [3]. Since it is unclear if, when (and through which tree) this
will eventually go in, I suggest merging this series as-is now and do
the trivial updates to use these new interfaces once the infrastructure
is in place.

Johan

[1] https://lkml.org/lkml/2014/10/9/427
[2] https://lkml.org/lkml/2014/10/7/30
[3] https://lkml.org/lkml/2014/10/7/654


Johan Hovold (20):
  rtc: omap: fix clock-source configuration
  rtc: omap: fix missing wakealarm attribute
  rtc: omap: fix interrupt disable at probe
  rtc: omap: clean up probe error handling
  rtc: omap: fix class-device registration
  rtc: omap: remove unused register-base define
  rtc: omap: use dev_info
  rtc: omap: make platform-device id table const
  rtc: omap: add device abstraction
  rtc: omap: remove DRIVER_NAME macro
  rtc: omap: add structured device-type info
  rtc: omap: silence bogus power-up reset message at probe
  rtc: omap: add helper to read raw bcd time
  rtc: omap: add helper to read 32-bit registers
  rtc: omap: add support for pmic_power_en
  rtc: omap: enable wake-up from power off
  rtc: omap: fix minor coding style issues
  rtc: omap: add copyright entry
  ARM: dts: am33xx: update rtc-node compatible property
  ARM: dts: am335x-boneblack: enable power off and rtc wake up

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |   9 +-
 arch/arm/boot/dts/am335x-boneblack.dts             |   4 +
 arch/arm/boot/dts/am33xx.dtsi                      |   2 +-
 drivers/rtc/rtc-omap.c                             | 540 +++++++++++++--------
 4 files changed, 355 insertions(+), 200 deletions(-)

-- 
2.0.4

