Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaEHH4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:56:47 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:41381 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaEHH4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:56:46 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/4] w1: mxc_w1: Fix incorrect "presence" status
Date: Thu,  8 May 2014 11:56:37 +0400
Message-Id: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W1 reset_bus() should return zero if slave device is present.
This patch fix this issue.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
Please apply this patch to current -rc if it possible.
---
 drivers/w1/masters/mxc_w1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 67b067a..a5df5e8 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -66,7 +66,7 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 
 		udelay(100);
 	}
-	return !!(reg_val & MXC_W1_CONTROL_PST);
+	return !(reg_val & MXC_W1_CONTROL_PST);
 }
 
 /*
-- 
1.8.3.2

