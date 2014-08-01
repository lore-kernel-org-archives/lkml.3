Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaHARW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:22:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39917 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbaHARWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:22:19 -0400
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri,  1 Aug 2014 18:11:39 +0100
Message-Id: <1406913099-13688-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 94.197.121.167
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] reset: Provide !RESET_CONTROLLER stub for devm_reset_control_get()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

At least the sun6i DMA controller driver makes use of the reset controller
API stubs when being built for coverage and otherwise fails to build.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/reset.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 349f150..28f119f 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -67,6 +67,13 @@ static inline int device_reset_optional(struct device *dev)
 	return -ENOSYS;
 }
 
+static inline struct reset_control *devm_reset_control_get(struct device *dev,
+							   const char *id)
+{
+	WARN_ON(1);
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct reset_control *reset_control_get_optional(
 					struct device *dev, const char *id)
 {
-- 
2.0.0

