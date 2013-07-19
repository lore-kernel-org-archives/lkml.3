Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab3GSFob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:44:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab3GSF03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 18/72] pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
Date: Thu, 18 Jul 2013 22:25:35 -0700
Message-Id: <20130719052601.108624097@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Eastwood <manabian@gmail.com>

commit e39506b466edcda2a7e9d0174d7987ae654137b7 upstream.

Commit 80af9e6d (pcmcia at91_cf: fix raw gpio number usage) forgot
to change the parameter in gpio_get_value after adding gpio
validation.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pcmcia/at91_cf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcm
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


