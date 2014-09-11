Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaIKNUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:20:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751720AbaIKNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:20:27 -0400
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
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 0/9] rtc: at91sam9: add DT support
Date: Thu, 11 Sep 2014 15:18:02 +0200
Message-Id: <1410441491-25207-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds DT support to the atmel at91sam9 RTC driver.

It also removes any machine specific inclusions to prepare the migration
to multi platform kernel support, and retain the slow clock to prevent
the CCF from disabling it at the end of boot.
  
Best Regards,

Boris

Changes since v3:
 - add GPBR DT bindings doc
 - fix a coding style issues
 - add Alexandre's Acked-by
 - change RTT DT bindings

Changes since v2:
 - make use of syscon/regmap to avoid directly requesting/mapping a GPBR
   memory region in the RTT driver

Changes since v1:
 - remove non CCF specific case by adding the appropriate clk_lookup
   entries in arch/arm/mach-at91/<soc-name>.c files


Boris BREZILLON (9):
  rtc: at91sam9: remove references to mach specific headers
  rtc: at91sam9: use standard readl/writel functions instead of raw
    versions
  rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
  rtc: at91sam9: add DT support
  rtc: at91sam9: make use of syscon/regmap to access GPBR registers
  ARM: at91: add clk_lookup entry for RTT devices
  rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
  rtc: at91sam9: add DT bindings documentation
  mfd: syscon: add Atmel GPBR DT bindings documention

 .../devicetree/bindings/mfd/atmel,gpbr.txt         |  15 +++
 .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt |  23 ++++
 arch/arm/mach-at91/at91sam9260.c                   |   2 +
 arch/arm/mach-at91/at91sam9261.c                   |   2 +
 arch/arm/mach-at91/at91sam9263.c                   |   4 +
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9rl.c                    |   2 +
 arch/arm/mach-at91/clock.c                         |   2 +-
 arch/arm/mach-at91/clock.h                         |   1 +
 drivers/rtc/Kconfig                                |   1 +
 drivers/rtc/rtc-at91sam9.c                         | 133 ++++++++++++++++-----
 11 files changed, 157 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt

-- 
1.9.1

