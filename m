Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3F1JdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:33:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41719 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab3F1JdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:33:14 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: [PATCH 0/4] rtc: omap: handle rtc wakeup support in driver
Date: Fri, 28 Jun 2013 15:05:05 +0530
Message-ID: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-omap driver modules is used both by OMAP1/2, Davinci SoC platforms.

However, rtc wake support on OMAP1 is broken. Hence the
device_init_wakeup() was removed from rtc-omap driver and moved to
platform board files that supported it (DA850/OMAP-L138). [1]

However, recently [2] it was suggested that driver should always do a
device_init_wakeup(dev, true). Platforms that don't want/need
wakeup support can disable it from userspace via:

    echo disabled > /sys/devices/.../power/wakeup

Also, with the new DT boot-up, board file doesn't exist and hence there
is no way to have device wakeup support rtc.

The fix for above issues, is to hard code device_init_wakeup() inside
driver and let platforms that don't need this, handle it through the
sysfs power entry.


Also, update Davinci & AM335x files to above changes.

[1]
https://patchwork.kernel.org/patch/136731/

[2]
http://www.mail-archive.com/davinci-linux-open-source@linux.
davincidsp.com/msg26077.html

Hebbar Gururaja (4):
  rtc: omap: restore back (hard-code) wakeup support
  davinci: da8xx/omap-l1: Remove hard coding of rtc device wakeup
  rtc: omap: add rtc wakeup support to alarm events
  ARM: dts: AM33XX: update rtc node compatibility

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    6 +-
 arch/arm/boot/dts/am33xx.dtsi                      |    2 +-
 arch/arm/mach-davinci/devices-da8xx.c              |    9 +--
 drivers/rtc/rtc-omap.c                             |   58 +++++++++++++++++---
 4 files changed, 58 insertions(+), 17 deletions(-)

-- 
1.7.9.5

