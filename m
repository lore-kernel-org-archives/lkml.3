Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbbAIDrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:47:33 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:65158 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbAIDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:47:31 -0500
From: Gigi Joseph <gigi.joseph@gmail.com>
X-Google-Original-From: Gigi Joseph <gigi.joseph@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Gigi Joseph <gigi.joseph@ti.com>, Eyal Reizer <eyalr@ti.com>,
        bvijay <bvijay@ti.com>
Subject: [PATCH 3/6] btwilink: add minimal device tree support
Date: Fri,  9 Jan 2015 03:47:19 +0000
Message-Id: <1420775239-24745-1-git-send-email-gigi.joseph@ti.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add minimal device tree support to the btwilink driver that is used
for binding bluetooth with the ti-st shared transport driver.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
Signed-off-by: bvijay <bvijay@ti.com>
Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
---
 drivers/bluetooth/btwilink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
index 55c135b..95adec3 100644
--- a/drivers/bluetooth/btwilink.c
+++ b/drivers/bluetooth/btwilink.c
@@ -30,6 +30,7 @@
 
 #include <linux/ti_wilink_st.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 /* Bluetooth Driver Version */
 #define VERSION               "1.0"
@@ -286,6 +287,14 @@ static int ti_st_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	return 0;
 }
 
+static const struct of_device_id btwilink_of_match[] = {
+{
+	.compatible = "btwilink",
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(of, btwilink_of_match);
+
 static int bt_ti_probe(struct platform_device *pdev)
 {
 	static struct ti_st *hst;
@@ -349,6 +358,8 @@ static struct platform_driver btwilink_driver = {
 	.remove = bt_ti_remove,
 	.driver = {
 		.name = "btwilink",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(btwilink_of_match),
 	},
 };
 
-- 
1.9.1

