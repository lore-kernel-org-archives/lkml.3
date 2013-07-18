Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3GRHt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:49:28 -0400
Received: from 15.mo5.mail-out.ovh.net ([178.33.107.29]:60417 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752094Ab3GRHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:49:27 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2013 03:49:26 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH v4 0/5] ARM: at91: prepare transition to common clk framework
Date: Thu, 18 Jul 2013 09:32:33 +0200
Message-Id: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 11097432431904127084
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series prepares the transition to common clk framework by
replacing all the clk_enable and clk_disable calls by clk_prepare_unable and
clk_disable_unprepare to avoid common clock framework warnings.

Best Regards,
Boris

Changes since v3:
 - move usb clock config patches out of this series
 - move clk_prepare/unprepare calls out of critical sections (ssc and
   mci drivers)
 - remove already applied spi clk_prepare patch 

Changes since v2:
 - add configuraton of usb clock in ohci and udc drivers
 - add clk_prepare patch for usba udc driver
 - add clk_prepare patch for spi driver
 - remove already applied udc clk_prepare patch

Changes since v1:
 - remove unneeded clk_unprepare in mci driver
 - remove already applied patches (ehci, ohci, dma and serial)

Changes since common clk patch series:
 - add clk_prepare_enable return check
 - fix a deadlock in atmel-mci (missing spin_unlock)
 - remove already applied patches (atmel-ssc and pwm-atmel-tcb)

Boris BREZILLON (5):
  ARM: at91/tc/clocksource: replace clk_enable/disable with
    clk_prepare_enable/disable_unprepare.
  mmc: atmel-mci: prepare clk before calling enable
  at91/avr32/atmel_lcdfb: prepare clk before calling enable
  USB: gadget: atmel_usba: prepare clk before calling enable
  ASoC: atmel-ssc: remove clk_disable_unprepare call from critical
    section

 drivers/clocksource/tcb_clksrc.c    |   10 +++++-----
 drivers/misc/atmel-ssc.c            |   11 ++++++++---
 drivers/mmc/host/atmel-mci.c        |   34 +++++++++++++++++++++++++++-------
 drivers/usb/gadget/atmel_usba_udc.c |   28 +++++++++++++++++++++-------
 drivers/video/atmel_lcdfb.c         |    8 ++++----
 5 files changed, 65 insertions(+), 26 deletions(-)

-- 
1.7.9.5

