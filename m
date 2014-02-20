Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaBTANH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:13:07 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45023 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaBTANE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:13:04 -0500
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] clk: bcm281xx: warn if ccu_wait_bit() fails
Date: Wed, 19 Feb 2014 18:12:51 -0600
Message-Id: <1392855182-21155-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392855182-21155-1-git-send-email-elder@linaro.org>
References: <1392855182-21155-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't let a failure of ccu_wait_bit() go unnoticed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index e3d339e..c01d810 100644
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

