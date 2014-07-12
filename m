Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaGLN3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 09:29:48 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49486 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGLN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 09:29:45 -0400
From: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
To: linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
Subject: [PATCH] cpuidle: fix permission for driver name sysfs node
Date: Sat, 12 Jul 2014 19:29:22 +0600
Message-Id: <1405171762-31119-1-git-send-email-meraj.enigma@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle driver name sysfs node is read-only. So permission should be 0444.

Signed-off-by: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
---
 drivers/cpuidle/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index efe2f17..97c5903 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -445,7 +445,7 @@ static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 
 #define define_one_driver_ro(_name, show)                       \
 	static struct cpuidle_driver_attr attr_driver_##_name = \
-		__ATTR(_name, 0644, show, NULL)
+		__ATTR(_name, 0444, show, NULL)
 
 struct cpuidle_driver_kobj {
 	struct cpuidle_driver *drv;
-- 
1.9.1

