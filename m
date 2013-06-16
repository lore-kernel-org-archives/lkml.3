Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3FPErA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:47:00 -0400
Received: from ozlabs.org ([203.10.76.45]:33373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab3FPEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ohad Ben-Cohen <ohad@wizery.com>,
        Robert Tivy <rtivy@ti.com>
Subject: [PATCH 6/9] remoteproc: don't use PTR_RET().
Date: Sun, 16 Jun 2013 14:12:45 +0930
Message-Id: <1371357768-4968-6-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've already tested that it's an error.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Robert Tivy <rtivy@ti.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/remoteproc/da8xx_remoteproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/da8xx_remoteproc.c b/drivers/remoteproc/da8xx_remoteproc.c
index 9b2e60a..129f7b9 100644
--- a/drivers/remoteproc/da8xx_remoteproc.c
+++ b/drivers/remoteproc/da8xx_remoteproc.c
@@ -165,7 +165,7 @@ static int reset_assert(struct device *dev)
 	dsp_clk = clk_get(dev, NULL);
 	if (IS_ERR(dsp_clk)) {
 		dev_err(dev, "clk_get error: %ld\n", PTR_ERR(dsp_clk));
-		return PTR_RET(dsp_clk);
+		return PTR_ERR(dsp_clk);
 	}
 
 	davinci_clk_reset_assert(dsp_clk);
-- 
1.8.1.2

