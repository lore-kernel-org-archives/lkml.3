Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab3GPPUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:20:39 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:60035 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932907Ab3GPPUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:20:38 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v3 0/7] ARM: at91: prepare transition to common clk framework
Date: Tue, 16 Jul 2013 17:03:15 +0200
Message-Id: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 6962565025895381100
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series prepares the transition to common clk framework by
1) replacing all the clk_enable and clk_disable calls by clk_prepare_unable and
   clk_disable_unprepare to avoid common clock framework warnings.
2) adding explicit configuration of clk (set_rate) within drivers instead of
   default configuration done in arch/arm/mach-at91/clock.c (udc and ohci
   drivers)

If the second part of this patch series (the last 2 patches) does not belong
here, please tell me and I'll move it into the "move to common clk framework"
series.

Best Regards,
Boris

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


Boris BREZILLON (7):
  ARM: at91/tc/clocksource: replace clk_enable/disable with
    clk_prepare_enable/disable_unprepare.
  mmc: atmel-mci: prepare clk before calling enable
  at91/avr32/atmel_lcdfb: prepare clk before calling enable
  USB: gadget: atmel_usba: prepare clk before calling enable
  spi: atmel: prepare clk before calling enable
  USB: ohci-at91: add usb_clk for transition to common clk framework
  usb: gadget: at91_udc: add usb_clk for transition to common clk
    framework

 drivers/clocksource/tcb_clksrc.c    |   10 +++++-----
 drivers/mmc/host/atmel-mci.c        |   27 ++++++++++++++++++---------
 drivers/spi/spi-atmel.c             |   12 +++++++-----
 drivers/usb/gadget/at91_udc.c       |   12 ++++++++++++
 drivers/usb/gadget/at91_udc.h       |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c |   28 +++++++++++++++++++++-------
 drivers/usb/host/ohci-at91.c        |   18 +++++++++++++++---
 drivers/video/atmel_lcdfb.c         |    8 ++++----
 8 files changed, 83 insertions(+), 34 deletions(-)

-- 
1.7.9.5

