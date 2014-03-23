Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaCWS1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:27:18 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47515 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaCWS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:27:16 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/input: Use RCU_INIT_POINTER(x, NULL) in evdev.c
Date: Sun, 23 Mar 2014 23:56:17 +0530
Message-Id: <1395599177-6776-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/input/evdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a06e125..fffa107 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -291,7 +291,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
 	if (grab != client)
 		return  -EINVAL;
 
-	rcu_assign_pointer(evdev->grab, NULL);
+	RCU_INIT_POINTER(evdev->grab, NULL);
 	synchronize_rcu();
 	input_release_device(&evdev->handle);
 
-- 
1.7.9.5

