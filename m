Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbbA0Ns1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:48:27 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:44918 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbA0Nra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:47:30 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 2/3] usb: ohci: jz4740: add DT support
Date: Tue, 27 Jan 2015 13:47:18 +0000
Message-ID: <1422366439-34641-3-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422366439-34641-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422366439-34641-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

This is a simple matter of providing a match table, the probe code needs
no modification.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 drivers/usb/host/ohci-jz4740.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
index 8ddd8f5..bb69733 100644
--- a/drivers/usb/host/ohci-jz4740.c
+++ b/drivers/usb/host/ohci-jz4740.c
@@ -234,11 +234,20 @@ static int jz4740_ohci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id jz4740_ohci_of_match[] = {
+	{ .compatible = "ingenic,jz4740-ohci", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, jz4740_ohci_of_match);
+#endif
+
 static struct platform_driver ohci_hcd_jz4740_driver = {
 	.probe = jz4740_ohci_probe,
 	.remove = jz4740_ohci_remove,
 	.driver = {
 		.name = "jz4740-ohci",
+		.of_match_table = of_match_ptr(jz4740_ohci_of_match),
 		.owner = THIS_MODULE,
 	},
 };
-- 
1.9.1

