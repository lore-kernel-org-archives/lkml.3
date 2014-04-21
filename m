Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDUVMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:12:01 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:51827 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaDUVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:11:58 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 RESEND 1/7] clk: bcm281xx: warn if ccu_wait_bit() fails
Date: Mon, 21 Apr 2014 16:11:37 -0500
Message-Id: <1398114703-32410-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398114703-32410-1-git-send-email-elder@linaro.org>
References: <1398114703-32410-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't let a failure of ccu_wait_bit() go unnoticed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index db11a87..4b4e35a 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -207,6 +207,9 @@ __ccu_wait_bit(struct ccu_data *ccu, u32 reg_offset, u32 bit, bool want)
 			return true;
 		udelay(1);
 	}
+	pr_warn("%s: %s/0x%04x bit %u was never %s\n", __func__,
+		ccu->name, reg_offset, bit, want ? "set" : "clear");
+
 	return false;
 }
 
-- 
1.9.1

