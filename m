Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbbA0NsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:48:04 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:35848 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbA0Nrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:47:31 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 3/3] usb: ohci: jz4740: prepare the clock before enabling it
Date: Tue, 27 Jan 2015 13:47:19 +0000
Message-ID: <1422366439-34641-4-git-send-email-Zubair.Kakakhel@imgtec.com>
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

The clock must have been prepared before enabling it.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 drivers/usb/host/ohci-jz4740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
index bb69733..1455a8b 100644
--- a/drivers/usb/host/ohci-jz4740.c
+++ b/drivers/usb/host/ohci-jz4740.c
@@ -189,7 +189,7 @@ static int jz4740_ohci_probe(struct platform_device *pdev)
 
 
 	clk_set_rate(jz4740_ohci->clk, 48000000);
-	clk_enable(jz4740_ohci->clk);
+	clk_prepare_enable(jz4740_ohci->clk);
 	if (jz4740_ohci->vbus)
 		ohci_jz4740_set_vbus_power(jz4740_ohci, true);
 
-- 
1.9.1

