Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaEHH4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:56:49 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:41411 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaEHH4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:56:46 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/4] w1: mxc_w1: Perform a software reset at startup
Date: Thu,  8 May 2014 11:56:39 +0400
Message-Id: <1399535800-19335-3-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
References: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a software reset for 1-Wire module at driver startup.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 0d05abe..741d2bb4 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -32,6 +32,7 @@
 # define MXC_W1_CONTROL_RPP	BIT(7)
 #define MXC_W1_TIME_DIVIDER	0x02
 #define MXC_W1_RESET		0x04
+# define MXC_W1_RESET_RST	BIT(0)
 
 struct mxc_w1_device {
 	void __iomem *regs;
@@ -129,6 +130,10 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* Software reset 1-Wire module */
+	writeb(MXC_W1_RESET_RST, mdev->regs + MXC_W1_RESET);
+	writeb(0, mdev->regs + MXC_W1_RESET);
+
 	writeb(clkdiv - 1, mdev->regs + MXC_W1_TIME_DIVIDER);
 
 	mdev->bus_master.data = mdev;
-- 
1.8.3.2

