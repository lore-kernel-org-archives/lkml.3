Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbaEMPfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:35:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41408 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaEMPec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:34:32 -0400
From: Felipe Balbi <balbi@ti.com>
To: <p.zabel@pengutronix.de>, <maxime.ripard@free-electrons.com>,
        <marex@denx.de>, <wsa@the-dreams.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] reset: stub out devm_reset_control_get()
Date: Tue, 13 May 2014 10:34:05 -0500
Message-ID: <1399995245-15095-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.rc1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

without that stub, drivers will fail to build
when CONFIG_RESET_CONTROLLER=n.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/reset.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index c0eda50..aa94420 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -75,6 +75,12 @@ static inline struct reset_control *devm_reset_control_get_optional(
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct reset_control *devm_reset_control_get(
+					struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 #endif /* CONFIG_RESET_CONTROLLER */
 
 #endif
-- 
2.0.0.rc1

