Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3C2QE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:04:57 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44985 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3C2QEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:04:53 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC 5/5] rtc-at91rm9200: add support for at91sam9x5
Date: Fri, 29 Mar 2013 17:03:49 +0100
Message-Id: <1364573029-19346-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
References: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the at91sam9x5-family which must use the shadow
interrupt mask due to a hardware issue.
---
 drivers/rtc/rtc-at91rm9200.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 2921866..f3e351f 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -318,12 +318,20 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 static const struct at91_rtc_config at91rm9200_config = {
 };
 
+static const struct at91_rtc_config at91sam9x5_config = {
+	.use_shadow_imr = true,
+};
+
 #if defined(CONFIG_OF)
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{
 		.compatible = "atmel,at91rm9200-rtc",
 		.data = &at91rm9200_config,
 	},
+	{
+		.compatible = "atmel,at91sam9x5-rtc",
+		.data = &at91sam9x5_config,
+	},
 		/* terminator */
 	}
 };
-- 
1.8.1.5

