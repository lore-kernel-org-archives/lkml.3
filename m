Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3FCU0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:26:54 -0400
Received: from sauhun.de ([89.238.76.85]:34598 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab3FCU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:26:51 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] pwm: devm: alloc correct pointer size
Date: Mon,  3 Jun 2013 22:27:17 +0200
Message-Id: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocated object should be the size of what the pointer is pointing
to and not the size of the pointer itself.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pwm/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 32221cb..0cf0f65 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -694,7 +694,7 @@ struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id)
 {
 	struct pwm_device **ptr, *pwm;
 
-	ptr = devres_alloc(devm_pwm_release, sizeof(**ptr), GFP_KERNEL);
+	ptr = devres_alloc(devm_pwm_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
@@ -724,7 +724,7 @@ struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
 {
 	struct pwm_device **ptr, *pwm;
 
-	ptr = devres_alloc(devm_pwm_release, sizeof(**ptr), GFP_KERNEL);
+	ptr = devres_alloc(devm_pwm_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.10.4

