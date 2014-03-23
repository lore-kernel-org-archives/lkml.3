Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaCWS2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:28:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54908 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaCWS2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:28:23 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/input: Use RCU_INIT_POINTER(x, NULL) in input.c
Date: Sun, 23 Mar 2014 23:57:23 +0530
Message-Id: <1395599243-6818-1-git-send-email-monamagarwal123@gmail.com>
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
 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1c4c0db..f9db5ea 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -539,7 +539,7 @@ static void __input_release_device(struct input_handle *handle)
 	grabber = rcu_dereference_protected(dev->grab,
 					    lockdep_is_held(&dev->mutex));
 	if (grabber == handle) {
-		rcu_assign_pointer(dev->grab, NULL);
+		RCU_INIT_POINTER(dev->grab, NULL);
 		/* Make sure input_pass_event() notices that grab is gone */
 		synchronize_rcu();
 
-- 
1.7.9.5

