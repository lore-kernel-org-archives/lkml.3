Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaFPSHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:07:35 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:10908 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433AbaFPSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:07:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYRgI4EaN4hGAc8qF4VjiRMdhC0EmkOTWINCOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Tyler Hicks <tyhicks@canonical.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH 1/1] fs/ecryptfs/messaging.c: remove null test before kfree
Date: Mon, 16 Jun 2014 20:06:12 +0200
Message-Id: <1402941972-5166-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ecryptfs/messaging.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index e57380e..286f10b 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -434,8 +434,7 @@ void ecryptfs_release_messaging(void)
 		mutex_lock(&ecryptfs_msg_ctx_lists_mux);
 		for (i = 0; i < ecryptfs_message_buf_len; i++) {
 			mutex_lock(&ecryptfs_msg_ctx_arr[i].mux);
-			if (ecryptfs_msg_ctx_arr[i].msg)
-				kfree(ecryptfs_msg_ctx_arr[i].msg);
+			kfree(ecryptfs_msg_ctx_arr[i].msg);
 			mutex_unlock(&ecryptfs_msg_ctx_arr[i].mux);
 		}
 		kfree(ecryptfs_msg_ctx_arr);
-- 
1.8.4.5

