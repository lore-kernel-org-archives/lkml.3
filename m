Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3LDJUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:20:32 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38470 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3LDJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:20:28 -0500
From: dt.tangr@gmail.com
To: linux-usb@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
Date: Wed,  4 Dec 2013 20:20:07 +1100
Message-Id: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

The SoC name was mistakenly used instead of the vendor name in the
device tree binding for nspire-usb.

This patch fixes this before the driver becomes widely adopted.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt |    4 ++--
 drivers/usb/chipidea/ci_hdrc_nspire.c                    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
index 5ba8e90..ef1fcbf 100644
--- a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
@@ -1,7 +1,7 @@
 * TI-Nspire USB OTG Controller
 
 Required properties:
-- compatible: Should be "zevio,nspire-usb"
+- compatible: Should be "lsi,nspire-usb"
 - reg: Should contain registers location and length
 - interrupts: Should contain controller interrupt
 
@@ -11,7 +11,7 @@ Recommended properies:
 Examples:
 		usb0: usb@B0000000 {
 			reg = <0xB0000000 0x1000>;
-			compatible = "zevio,nspire-usb";
+			compatible = "lsi,nspire-usb";
 			interrupts = <8>;
 			vbus-supply = <&vbus_reg>;
 		};
diff --git a/drivers/usb/chipidea/ci_hdrc_nspire.c b/drivers/usb/chipidea/ci_hdrc_nspire.c
index 517ce41..c5c2dde 100644
--- a/drivers/usb/chipidea/ci_hdrc_nspire.c
+++ b/drivers/usb/chipidea/ci_hdrc_nspire.c
@@ -52,7 +52,7 @@ static int ci_hdrc_nspire_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id ci_hdrc_nspire_dt_ids[] = {
-	{ .compatible = "zevio,nspire-usb", },
+	{ .compatible = "lsi,nspire-usb", },
 	{ /* sentinel */ }
 };
 
-- 
1.7.10.4

