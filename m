Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab3FMUaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:30:11 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47704 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757728Ab3FMUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:30:09 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: move the pm state stubs
Date: Thu, 13 Jun 2013 22:29:23 +0200
Message-ID: <1371155363-28223-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The stubs for the !PINCTRL case were placed in the wrong
part of the file, causing breakage in linux-next when compiling
SH without pinctrl. Fix it up by moving the stubs to the right
place.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/consumer.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 18cdbb1..7f18e4d 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -116,6 +116,26 @@ static inline void devm_pinctrl_put(struct pinctrl *p)
 {
 }
 
+static inline int pinctrl_pm_select_default_state(struct device *dev)
+{
+	return 0;
+}
+
+static inline int pinctrl_pm_select_active_state(struct device *dev)
+{
+	return 0;
+}
+
+static inline int pinctrl_pm_select_sleep_state(struct device *dev)
+{
+	return 0;
+}
+
+static inline int pinctrl_pm_select_idle_state(struct device *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_PINCTRL */
 
 static inline struct pinctrl * __must_check pinctrl_get_select(
@@ -223,26 +243,6 @@ static inline int pin_config_group_set(const char *dev_name,
 	return 0;
 }
 
-static inline int pinctrl_pm_select_default_state(struct device *dev)
-{
-	return 0;
-}
-
-static inline int pinctrl_pm_select_active_state(struct device *dev)
-{
-	return 0;
-}
-
-static inline int pinctrl_pm_select_sleep_state(struct device *dev)
-{
-	return 0;
-}
-
-static inline int pinctrl_pm_select_idle_state(struct device *dev)
-{
-	return 0;
-}
-
 #endif
 
 #endif /* __LINUX_PINCTRL_CONSUMER_H */
-- 
1.7.11.3

