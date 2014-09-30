Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaI3QTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:19:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56764 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbaI3QTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:19:51 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/6] ARM: at91: remove at91sam9g45/9m10 legacy board support
Date: Tue, 30 Sep 2014 18:19:41 +0200
Message-Id: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch removes legacy board support for at91sam9g45/9m10 SoCs whose
boards have already migrated to DT.
Along with this removal this series adds DT support for the TRNG (True
Random Generator Block) and adds missing trng and isi nodes to the dtsi.

There's still one missing piece to provide the exact same set of
functionalities: AC97 controller support which has not been moved to DT yet.

Best Regards,

Boris

Boris Brezillon (6):
  ARM: at91: remove at91sam9g45/9m10 legacy board support
  hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
  hwrng: atmel: add DT support
  hwrng: atmel: Add TRNG DT binding doc
  ARM: at91/dt: add trng node
  ARM: at91/dt: add ISI node

 .../devicetree/bindings/hwrng/atmel-trng.txt       |   16 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   39 +
 arch/arm/mach-at91/Kconfig.non_dt                  |   21 -
 arch/arm/mach-at91/Makefile                        |    4 -
 arch/arm/mach-at91/at91sam9g45.c                   |  403 ----
 arch/arm/mach-at91/at91sam9g45_devices.c           | 1915 --------------------
 arch/arm/mach-at91/board-sam9m10g45ek.c            |  526 ------
 drivers/char/hw_random/Kconfig                     |    2 +-
 drivers/char/hw_random/atmel-rng.c                 |   15 +-
 9 files changed, 67 insertions(+), 2874 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt
 delete mode 100644 arch/arm/mach-at91/at91sam9g45_devices.c
 delete mode 100644 arch/arm/mach-at91/board-sam9m10g45ek.c

-- 
1.9.1

