Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3KUSPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:15:49 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39948 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:15:46 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement
Date: Thu, 21 Nov 2013 23:45:25 +0530
Message-Id: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series does the following
1> Ports the driver to use irqdomain.
2> Adds dt binding support for gpio-davinci.
3> Adds DA850 dt support goio.

Changes for v6:
1: GPIO driver now migrated to irq domain legacy.
2: Fixed review comments pointed by Grygorii.
3: Included Ack's.

This patch series is based on following fixup series
http://us.generation-nt.com/answer/patch-0-2-davinci-gpio-fixes-help-212978272.html

This patch series has been tested for both banked and Un-banked GPIO.

KV Sujith (3):
  gpio: davinci: add OF support
  ARM: davinci: da850: add GPIO DT node
  ARM: davinci: da850 evm: add GPIO pinumux entries DT node

Lad, Prabhakar (3):
  gpio: davinci: use readl/writel instead of __raw_*
  This patch converts the davinci gpio driver to use irqdomain    
    support.
  gpio: davinci: remove unused variable intc_irq_num

 .../devicetree/bindings/gpio/gpio-davinci.txt      |   41 +++++
 arch/arm/boot/dts/da850-evm.dts                    |   20 +++
 arch/arm/boot/dts/da850.dtsi                       |   14 ++
 arch/arm/mach-davinci/da830.c                      |    1 -
 arch/arm/mach-davinci/da850.c                      |    1 -
 arch/arm/mach-davinci/dm355.c                      |    1 -
 arch/arm/mach-davinci/dm365.c                      |    1 -
 arch/arm/mach-davinci/dm644x.c                     |    1 -
 arch/arm/mach-davinci/dm646x.c                     |    1 -
 drivers/gpio/gpio-davinci.c                        |  173 ++++++++++++++------
 include/linux/platform_data/gpio-davinci.h         |    3 +-
 11 files changed, 195 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

-- 
1.7.9.5

