Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab3ICRxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:53:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760009Ab3ICRxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:53:06 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/2] omap hwspinlock dt support
Date: Tue, 3 Sep 2013 12:52:42 -0500
Message-ID: <1378230762-54895-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds the device tree support to the OMAP hwspinlock
driver. The series is based on 3.11 kernel, and currently adds
the DT node for OMAP4. Since all the OMAP SoCs on which hwspinlock
is supported are currently DT-boot only, I have combined the dt
parsing support and removing the mach-omap2/hwspinlock.c cleanup
into the first patch. This mandates that a DT node be defined
to use a hwspinlock on an OMAP SoC, even though the 3.11 kernel
could instantiate the devices normally even in a DT-boot mode.

The DT binding documentation is added using the folder name 
hwlock (same name from the MSM HW Mutex driver support series
in [1]).

[1] https://lkml.org/lkml/2013/8/14/528

Suman Anna (2):
  hwspinlock/omap: add support for dt nodes
  ARM: dts: OMAP4: Add hwspinlock node

 .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
 arch/arm/boot/dts/omap4.dtsi                       |  6 +++
 arch/arm/mach-omap2/Makefile                       |  3 --
 arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
 drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
 5 files changed, 51 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
1.8.3.3

