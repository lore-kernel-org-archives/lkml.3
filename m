Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3EWQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:14:47 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:58633 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759243Ab3EWQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:14:45 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v2 0/3] ARM: at91: move aic driver to drivers/irqchip
Date: Thu, 23 May 2013 17:48:52 +0200
Message-Id: <1369324135-31211-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 4256183123667039308
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series :
 - register the arch specific irq handler inside the the init functions
   using set_handle_irq. This way we can remove all the machine specific
   "handle_irq"
 - move the at91 AIC (Advance Interrupt Controller) driver to the 
   irqchip subsystem directory (drivers/irqchip)
 - make use of IRQCHIP_DECLARE to register irqchip for dt boards
   instead of using the machine specific "init_irq" function

This patch series was tested on kizbox board (sam9g20 SoC) using
device tree. Could someone test it on other boards (both dt and non dt)?

Changes since v1:
 - reorder patch (3rd patch is now applied first).
 - remove references to machine specific header (<mach/at91_aic.h>).

Maybe we should cleanup include/linux/irqchip/at91.h
(as suggested by Russel).
Currently, the only MACROs needed outside of irq-at91.c are:
 - pm.c : at91_aic_read, AT91_AIC_IMR and AT91_AIC_IPR
 - at91xxx.c : NR_AICX_IRQS

Please let me know what you think is best.

Best Regards,
Boris

Boris BREZILLON (3):
  ARM: at91: use set_handle_irq instead of machine specific handle_irq
  ARM: at91: move at91 aic driver to drivers/irqchip
  ARM: at91: use IRQCHIP_DECLARE instead of machine specific init_irq

 arch/arm/mach-at91/Makefile                        |    2 +-
 arch/arm/mach-at91/at91rm9200.c                    |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |    2 +-
 arch/arm/mach-at91/at91sam9261.c                   |    2 +-
 arch/arm/mach-at91/at91sam9263.c                   |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/board-1arm.c                    |    3 +--
 arch/arm/mach-at91/board-afeb-9260v1.c             |    3 +--
 arch/arm/mach-at91/board-cam60.c                   |    3 +--
 arch/arm/mach-at91/board-carmeva.c                 |    3 +--
 arch/arm/mach-at91/board-cpu9krea.c                |    3 +--
 arch/arm/mach-at91/board-cpuat91.c                 |    3 +--
 arch/arm/mach-at91/board-csb337.c                  |    3 +--
 arch/arm/mach-at91/board-csb637.c                  |    3 +--
 arch/arm/mach-at91/board-dt-rm9200.c               |   14 +-------------
 arch/arm/mach-at91/board-dt-sam9.c                 |   15 +--------------
 arch/arm/mach-at91/board-dt-sama5.c                |   15 +--------------
 arch/arm/mach-at91/board-eb01.c                    |    3 +--
 arch/arm/mach-at91/board-eb9200.c                  |    3 +--
 arch/arm/mach-at91/board-ecbat91.c                 |    3 +--
 arch/arm/mach-at91/board-eco920.c                  |    3 +--
 arch/arm/mach-at91/board-flexibity.c               |    3 +--
 arch/arm/mach-at91/board-foxg20.c                  |    3 +--
 arch/arm/mach-at91/board-gsia18s.c                 |    3 +--
 arch/arm/mach-at91/board-kafa.c                    |    3 +--
 arch/arm/mach-at91/board-kb9202.c                  |    3 +--
 arch/arm/mach-at91/board-pcontrol-g20.c            |    3 +--
 arch/arm/mach-at91/board-picotux200.c              |    3 +--
 arch/arm/mach-at91/board-qil-a9260.c               |    3 +--
 arch/arm/mach-at91/board-rm9200dk.c                |    3 +--
 arch/arm/mach-at91/board-rm9200ek.c                |    3 +--
 arch/arm/mach-at91/board-rsi-ews.c                 |    3 +--
 arch/arm/mach-at91/board-sam9-l9260.c              |    3 +--
 arch/arm/mach-at91/board-sam9260ek.c               |    3 +--
 arch/arm/mach-at91/board-sam9261ek.c               |    3 +--
 arch/arm/mach-at91/board-sam9263ek.c               |    3 +--
 arch/arm/mach-at91/board-sam9g20ek.c               |    4 +---
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    3 +--
 arch/arm/mach-at91/board-sam9rlek.c                |    3 +--
 arch/arm/mach-at91/board-snapper9260.c             |    3 +--
 arch/arm/mach-at91/board-stamp9g20.c               |    4 +---
 arch/arm/mach-at91/board-usb-a926x.c               |    5 +----
 arch/arm/mach-at91/board-yl-9200.c                 |    3 +--
 arch/arm/mach-at91/generic.h                       |    5 -----
 arch/arm/mach-at91/pm.c                            |    2 +-
 drivers/irqchip/Makefile                           |    1 +
 .../mach-at91/irq.c => drivers/irqchip/irq-at91.c  |   14 ++++++++++++--
 .../at91_aic.h => include/linux/irqchip/at91.h     |    9 +--------
 50 files changed, 60 insertions(+), 137 deletions(-)
 rename arch/arm/mach-at91/irq.c => drivers/irqchip/irq-at91.c (97%)
 rename arch/arm/mach-at91/at91_aic.h => include/linux/irqchip/at91.h (95%)

-- 
1.7.9.5

