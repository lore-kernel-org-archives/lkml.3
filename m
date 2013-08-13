Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab3HMQdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:33:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3HMQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:50 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=KnLw3oF9kZ4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zRdBJ5ZeVJIA:10 a=pGLkceISAAAA:8 a=jAfPOIUMAAAA:8 a=7KW0tsBSAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=cOyrYcIFjrTb7Gd_gy0A:9 a=MSl-tDqOz04A:10 a=gE_ZUhsuebIA:10 a=qDg0F9w_zDsA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.985805536@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [72/88] pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0072-pcmcia-at91_cf-fix-gpio_get_value-in-at91_cf_get_sta.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Joachim Eastwood <manabian@gmail.com>

[ Upstream commit e39506b466edcda2a7e9d0174d7987ae654137b7 ]

Commit 80af9e6d (pcmcia at91_cf: fix raw gpio number usage) forgot
to change the parameter in gpio_get_value after adding gpio
validation.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable <stable@vger.kernel.org> # 3.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pcmcia/at91_cf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 9694c1e..fc50168 100644
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
1.7.10.4


