Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaECBzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 21:55:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36837 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaECBy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 21:54:58 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-i2c@vger.kernel.org
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] i2c: qup: Fix pm_runtime_get_sync usage
Date: Fri,  2 May 2014 20:54:29 -0500
Message-Id: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the error check on the call to pm_runtime_get_sync.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/i2c/busses/i2c-qup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 1b4cf14..2a5efb5 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -479,7 +479,7 @@ static int qup_i2c_xfer(struct i2c_adapter *adap,
 	int ret, idx;
 
 	ret = pm_runtime_get_sync(qup->dev);
-	if (ret)
+	if (ret < 0)
 		goto out;
 
 	writel(1, qup->base + QUP_SW_RESET);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

