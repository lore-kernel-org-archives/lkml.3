Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaIKI4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:56:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43411 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753888AbaIKI4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:56:14 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/8] rtc: at91sam9: add DT support
Date: Thu, 11 Sep 2014 10:55:59 +0200
Message-Id: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds DT support to the atmel at91sam9 RTC driver.

It also removes any machine specific inclusions to prepare the migration
to multi platform kernel support, and retain the slow clock to prevent
the CCF from disabling it at the end of boot.

Johan, let me know if this version addresses part of your concerns.
I'm open to any suggestion/rework to address other previously discussed
issues, as long as it does not end up in a dead-end (like the discussion
you had last year):
 - the fact that the RTT block could be used for something that is not
   an RTC
 - the fact that referencing the GPBR node and defining a GPBR register
   number to store RTC time info could be considered as an HW config and
   not an HW description and thus should not be described in the DT
 - other things I don't remember :-)
  

Best Regards,

Boris

Changes since v2:
 - make use of syscon/regmap to avoid directly requesting/mapping a GPBR
   memory region in the RTT driver

Changes since v1:
 - remove non CCF specific case by adding the appropriate clk_lookup
   entries in arch/arm/mach-at91/<soc-name>.c files

Boris BREZILLON (8):
  rtc: at91sam9: remove references to mach specific headers
  rtc: at91sam9: use standard readl/writel functions instead of raw
    versions
  rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
  rtc: at91sam9: add DT support
  rtc: at91sam9: make use of syscon/regmap to access GPBR registers
  ARM: at91: add clk_lookup entry for RTT devices
  rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
  rtc: at91sam9: add DT bindings documentation

 .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt |  24 ++++
 arch/arm/mach-at91/at91sam9260.c                   |   2 +
 arch/arm/mach-at91/at91sam9261.c                   |   2 +
 arch/arm/mach-at91/at91sam9263.c                   |   4 +
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9rl.c                    |   2 +
 arch/arm/mach-at91/clock.c                         |   2 +-
 arch/arm/mach-at91/clock.h                         |   1 +
 drivers/rtc/Kconfig                                |   1 +
 drivers/rtc/rtc-at91sam9.c                         | 132 ++++++++++++++++-----
 10 files changed, 142 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt

-- 
1.9.1

