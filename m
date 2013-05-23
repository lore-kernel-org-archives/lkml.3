Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3EWIvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:51:48 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:42962 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757520Ab3EWIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:51:43 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH 0/3] ARM: at91: move aic driver to drivers/irqchip
Date: Thu, 23 May 2013 10:49:47 +0200
Message-Id: <1369298990-9826-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 15577388163004609612
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series move the at91 AIC (Advance Interrupt Controller)
driver to the irqchip subsystem directory (drivers/irqchip).

It also make use of IRQCHIP_DECLARE to register irqchip for dt boards
instead of using the machine specific "init_irq" function.

Finally it register the arch specific irq handler inside the the init
functions using set_handle_irq. This way we can remove all the machine
specific "handle_irq".

This patch series was tested on kizbox board (sam9g20 SoC) using
device tree. Could someone test it on other boards (both dt and non dt)?

Best Regards,
Boris


Boris BREZILLON (3):
  ARM: at91: move at91 aic driver to drivers/irqchip
  ARM: at91: use IRQCHIP_DECLARE instead of machine specific init_irq
  ARM: at91: use set_handle_irq instead of machine specific handle_irq

 arch/arm/mach-at91/Makefile                |    2 +-
 arch/arm/mach-at91/at91_aic.h              |   99 -----
 arch/arm/mach-at91/at91rm9200.c            |    2 +-
 arch/arm/mach-at91/at91sam9260.c           |    2 +-
 arch/arm/mach-at91/at91sam9261.c           |    2 +-
 arch/arm/mach-at91/at91sam9263.c           |    2 +-
 arch/arm/mach-at91/at91sam9g45.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl.c            |    2 +-
 arch/arm/mach-at91/at91x40.c               |    2 +-
 arch/arm/mach-at91/board-1arm.c            |    3 +-
 arch/arm/mach-at91/board-afeb-9260v1.c     |    3 +-
 arch/arm/mach-at91/board-cam60.c           |    3 +-
 arch/arm/mach-at91/board-carmeva.c         |    3 +-
 arch/arm/mach-at91/board-cpu9krea.c        |    3 +-
 arch/arm/mach-at91/board-cpuat91.c         |    3 +-
 arch/arm/mach-at91/board-csb337.c          |    3 +-
 arch/arm/mach-at91/board-csb637.c          |    3 +-
 arch/arm/mach-at91/board-dt-rm9200.c       |   15 +-
 arch/arm/mach-at91/board-dt-sam9.c         |   16 +-
 arch/arm/mach-at91/board-dt-sama5.c        |   16 +-
 arch/arm/mach-at91/board-eb01.c            |    4 +-
 arch/arm/mach-at91/board-eb9200.c          |    4 +-
 arch/arm/mach-at91/board-ecbat91.c         |    3 +-
 arch/arm/mach-at91/board-eco920.c          |    3 +-
 arch/arm/mach-at91/board-flexibity.c       |    3 +-
 arch/arm/mach-at91/board-foxg20.c          |    3 +-
 arch/arm/mach-at91/board-gsia18s.c         |    3 +-
 arch/arm/mach-at91/board-kafa.c            |    3 +-
 arch/arm/mach-at91/board-kb9202.c          |    3 +-
 arch/arm/mach-at91/board-pcontrol-g20.c    |    3 +-
 arch/arm/mach-at91/board-picotux200.c      |    3 +-
 arch/arm/mach-at91/board-qil-a9260.c       |    3 +-
 arch/arm/mach-at91/board-rm9200dk.c        |    3 +-
 arch/arm/mach-at91/board-rm9200ek.c        |    3 +-
 arch/arm/mach-at91/board-rsi-ews.c         |    4 +-
 arch/arm/mach-at91/board-sam9-l9260.c      |    3 +-
 arch/arm/mach-at91/board-sam9260ek.c       |    3 +-
 arch/arm/mach-at91/board-sam9261ek.c       |    3 +-
 arch/arm/mach-at91/board-sam9263ek.c       |    3 +-
 arch/arm/mach-at91/board-sam9g20ek.c       |    4 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c    |    3 +-
 arch/arm/mach-at91/board-sam9rlek.c        |    3 +-
 arch/arm/mach-at91/board-snapper9260.c     |    3 +-
 arch/arm/mach-at91/board-stamp9g20.c       |    4 +-
 arch/arm/mach-at91/board-usb-a926x.c       |    5 +-
 arch/arm/mach-at91/board-yl-9200.c         |    3 +-
 arch/arm/mach-at91/generic.h               |    5 -
 arch/arm/mach-at91/include/mach/at91_aic.h |   96 +++++
 arch/arm/mach-at91/irq.c                   |  547 ---------------------------
 arch/arm/mach-at91/pm.c                    |    2 +-
 drivers/irqchip/Makefile                   |    1 +
 drivers/irqchip/irq-at91.c                 |  557 ++++++++++++++++++++++++++++
 52 files changed, 706 insertions(+), 773 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91_aic.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91_aic.h
 delete mode 100644 arch/arm/mach-at91/irq.c
 create mode 100644 drivers/irqchip/irq-at91.c

-- 
1.7.9.5

