Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBWXug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:50:36 -0500
Received: from ring0.de ([5.45.105.125]:59924 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbaBWXud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:50:33 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 2/6] HSI: method to unregister clients from an hsi port
Date: Mon, 24 Feb 2014 00:49:57 +0100
Message-Id: <1393199401-27197-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393199401-27197-1-git-send-email-sre@debian.org>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exports a method to unregister all clients from
an hsi port.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/hsi/hsi.c       | 10 ++++++++++
 include/linux/hsi/hsi.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 8bbc0f1..c7b842b 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -198,6 +198,16 @@ static void hsi_port_release(struct device *dev)
 }
 
 /**
+ * hsi_unregister_port - Unregister an HSI port
+ * @port: The HSI port to unregister
+ */
+void hsi_port_unregister_clients(struct hsi_port *port)
+{
+	device_for_each_child(&port->device, NULL, hsi_remove_client);
+}
+EXPORT_SYMBOL_GPL(hsi_port_unregister_clients);
+
+/**
  * hsi_unregister_controller - Unregister an HSI controller
  * @hsi: The HSI controller to register
  */
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index fb07339..89cc6f2 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -284,6 +284,7 @@ int hsi_register_controller(struct hsi_controller *hsi);
 void hsi_unregister_controller(struct hsi_controller *hsi);
 void hsi_add_clients_from_dt(struct hsi_port *port,
 						struct device_node *clients);
+void hsi_port_unregister_clients(struct hsi_port *port);
 
 static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
 								void *data)
-- 
1.8.5.3

