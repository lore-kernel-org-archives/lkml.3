Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536Ab3FSL2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:28:06 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:46160 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934460Ab3FSL2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:28:02 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 0/8] ARM: at91: prepare the move to common clk framework
Date: Wed, 19 Jun 2013 13:11:03 +0200
Message-Id: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 10519845780332247148
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series was formerly part of the at91 common clk patch series.
It prepares the move to common clk framework by replacing all the
clk_enable and clk_disable calls by clk_prepare_unable and
clk_disable_unprepare to avoid common clock framework warnings.

This patch series was taken out of the at91 common clk patch series
beacuse it does not rely on any other patches and have a low impact
on the drivers (can be merge faster).

Please tell me if I missed drivers using at91 PMC clks.

Best Regards,
Boris

Changes since v1:
 - add clk_prepare_enable return check
 - fix a deadlock in atmel-mci (missing spin_unlock)
 - remove already applied patches (atmel-ssc and pwm-atmel-tcb)

Boris BREZILLON (8):
  ARM: at91/tc/clocksource: replace clk_enable/disable with
    clk_prepare_enable/disable_unprepare.
  at_hdmac: prepare clk before calling enable
  mmc: atmel-mci: prepare clk before calling enable
  tty: atmel_serial: prepare clk before calling enable
  usb: gadget: at91_udc: prepare clk before calling enable
  ehci-atmel.c: prepare clk before calling enable
  USB: ohci-at91: prepare clk before calling enable
  at91/avr32/atmel_lcdfb: prepare clk before calling enable

 drivers/clocksource/tcb_clksrc.c  |   10 ++++-----
 drivers/dma/at_hdmac.c            |   17 +++++++++------
 drivers/mmc/host/atmel-mci.c      |   29 ++++++++++++++++++--------
 drivers/tty/serial/atmel_serial.c |   41 ++++++++++++++++++++++++++++---------
 drivers/usb/gadget/at91_udc.c     |   14 +++++++------
 drivers/usb/host/ehci-atmel.c     |    8 ++++----
 drivers/usb/host/ohci-at91.c      |   12 +++++------
 drivers/video/atmel_lcdfb.c       |    8 ++++----
 8 files changed, 89 insertions(+), 50 deletions(-)

-- 
1.7.9.5

