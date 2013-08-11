Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3HKQkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:40:41 -0400
Received: from ring0.de ([91.143.88.219]:44612 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3HKQkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:40:39 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Aug 2013 12:40:39 EDT
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
From: Sebastian Reichel <sre@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Reichel <sre@debian.org>, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Subject: [RFC PATCH 0/3] OMAP SSI driver
Date: Sun, 11 Aug 2013 18:13:45 +0200
Message-Id: <1376237628-1077-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

This patchset adds an OMAP SSI driver to the HSI framework.

After leaving Nokia Carlos Chinea had no more time to work on this patchset;
Thus I tried updating the driver to fix the mentioned issues.

I applied the following changes to the last patch from Carlos:

 * convert driver to use hwmod and add SSI information to hwmod database
 * convert driver to use runtime_pm
 * change platform data, so that it forwards the wake_gpio to avoid irq_to_gpio
 * move the ssi.h and rename to hsi-omap-ssi.h (multiplatform support)

The code compiles and is initialized on the RX51. I also verified, that it
does not break the boot on my Pandaboard.

The driver has been written by Carlos Chinea and has already been sent for
public review as part of the HSI framework RFC before:

 https://lkml.org/lkml/2011/6/10/280

-- Sebastian

Sebastian Reichel (3):
  ARM: OMAP2+: hwmod-data: Add SSI information
  ARM: OMAP2+: HSI: Introduce OMAP SSI driver
  ARM: OMAP2+: Add SSI driver configuration

 arch/arm/mach-omap2/Makefile                 |    4 +
 arch/arm/mach-omap2/board-rx51-peripherals.c |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |  104 ++
 arch/arm/mach-omap2/ssi.c                    |   82 ++
 drivers/hsi/Kconfig                          |    1 +
 drivers/hsi/Makefile                         |    1 +
 drivers/hsi/controllers/Kconfig              |   23 +
 drivers/hsi/controllers/Makefile             |    5 +
 drivers/hsi/controllers/omap_ssi.c           | 1879 ++++++++++++++++++++++++++
 include/linux/platform_data/hsi-omap-ssi.h   |  202 +++
 10 files changed, 2310 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-omap2/ssi.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 include/linux/platform_data/hsi-omap-ssi.h

-- 
1.7.10.4

