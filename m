Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaAHSiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:38:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60503 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbaAHSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:37:57 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 4/7] mfd: ssbi: Add regmap read/write helpers
Date: Wed,  8 Jan 2014 10:37:47 -0800
Message-Id: <1389206270-3728-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read and write helper functions that the pm8921-core driver
can use to read and write ssbi regsiters via a "no-bus" regmap.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/ssbi.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/ssbi.h b/include/linux/ssbi.h
index bcbb642a7641..3ffc02e479d2 100644
--- a/include/linux/ssbi.h
+++ b/include/linux/ssbi.h
@@ -20,4 +20,17 @@
 int ssbi_write(struct device *dev, u16 addr, const u8 *buf, int len);
 int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
 
+static inline int
+ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	*val = 0;
+	return ssbi_read(context, reg, (u8 *)val, 1);
+}
+
+static inline int
+ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	return ssbi_write(context, reg, (u8 *)&val, 1);
+}
+
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

