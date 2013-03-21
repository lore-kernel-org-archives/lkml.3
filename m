Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3CULkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:40:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7718 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3CULkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:40:35 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <fabio.porcedda@gmail.com>, <laurent.navet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 1/7] pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
Date: Thu, 21 Mar 2013 12:40:11 +0100
Message-ID: <4e31a0f657ec3c0154a6a1ee75800459dde45e2d.1363865228.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363865228.git.nicolas.ferre@atmel.com>
References: <cover.1363865228.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

Commit 80af9e6d (pcmcia at91_cf: fix raw gpio number usage) forgot
to change the parameter in gpio_get_value after adding gpio
validation.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pcmcia/at91_cf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 01463c7..1b2c631 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcmcia_socket *s, u_int *sp)
 		int vcc	= gpio_is_valid(cf->board->vcc_pin);
 
 		*sp = SS_DETECT | SS_3VCARD;
-		if (!rdy || gpio_get_value(rdy))
+		if (!rdy || gpio_get_value(cf->board->irq_pin))
 			*sp |= SS_READY;
-		if (!vcc || gpio_get_value(vcc))
+		if (!vcc || gpio_get_value(cf->board->vcc_pin))
 			*sp |= SS_POWERON;
 	} else
 		*sp = 0;
-- 
1.8.0

