Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693Ab3DCKEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:04:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55935 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724Ab3DCKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:04:43 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC v2 4/4] rtc-at91rm9200: add support for at91sam9x5
Date: Wed,  3 Apr 2013 12:03:35 +0200
Message-Id: <1364983415-20298-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
References: <1364982862-19759-1-git-send-email-jhovold@gmail.com>
 <1364983415-20298-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the at91sam9x5-family which must use the shadow
interrupt mask due to a hardware issue.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt | 2 +-
 drivers/rtc/rtc-at91rm9200.c                                   | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
index 2a3feab..34c1505 100644
--- a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
@@ -1,7 +1,7 @@
 Atmel AT91RM9200 Real Time Clock
 
 Required properties:
-- compatible: should be: "atmel,at91rm9200-rtc"
+- compatible: should be: "atmel,at91rm9200-rtc" or "atmel,at91sam9x5-rtc"
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: rtc alarm/event interrupt
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index ac5f8ed..7c19390 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -320,11 +320,18 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 static const struct at91_rtc_config at91rm9200_config = {
 };
 
+static const struct at91_rtc_config at91sam9x5_config = {
+	.use_shadow_imr	= true,
+};
+
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{
 		.compatible = "atmel,at91rm9200-rtc",
 		.data = &at91rm9200_config,
 	}, {
+		.compatible = "atmel,at91sam9x5-rtc",
+		.data = &at91sam9x5_config,
+	}, {
 		/* sentinel */
 	}
 };
-- 
1.8.1.5

