Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaCCKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:09:56 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:41474 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCKJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:09:53 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com
Cc: plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v5 1/9] at91: dt: Adds support for the bus matrix declaration in the DT
Date: Mon,  3 Mar 2014 11:05:54 +0100
Message-Id: <1393841162-25339-2-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/setup.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f7ca97b..6a4e07e 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -487,6 +487,26 @@ end:
 	of_node_put(np);
 }
 
+static struct of_device_id matrix_ids[] = {
+	{ .compatible = "atmel,at91sam9260-bus-matrix", },
+	{ /*sentinel*/ }
+};
+
+static void at91_dt_matrix(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, matrix_ids);
+	if (!np)
+		panic("AT91: unable to find compatible bus matrix controller node in dtb\n");
+
+	at91_matrix_base = of_iomap(np, 0);
+	if (!at91_matrix_base)
+		panic("Impossible to ioremap at91_matrix_base\n");
+
+	of_node_put(np);
+}
+
 void __init at91rm9200_dt_initialize(void)
 {
 	at91_dt_ramc();
@@ -506,6 +526,7 @@ void __init at91_dt_initialize(void)
 	at91_dt_rstc();
 	at91_dt_ramc();
 	at91_dt_shdwc();
+	at91_dt_matrix();
 
 	/* Init clock subsystem */
 	at91_dt_clock_init();
-- 
1.9.0

