Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbaDHVp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:45:58 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36333 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbaDHVnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:43:13 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] clk: bcm281xx: warn if ccu_wait_bit() fails
Date: Tue,  8 Apr 2014 16:43:39 -0500
Message-Id: <1396993425-30683-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396993425-30683-1-git-send-email-elder@linaro.org>
References: <1396993425-30683-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't let a failure of ccu_wait_bit() go unnoticed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c |    3 +++
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
1.7.9.5

