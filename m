Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3FAJp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:45:57 -0400
Received: from www17.your-server.de ([213.133.104.17]:59384 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab3FAJpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:45:41 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2013 05:45:40 EDT
Message-ID: <1370079935.29224.18.camel@localhost.localdomain>
Subject: [PATCH] Btrfs: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:45:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3296,10 +3296,7 @@ int btrfs_resume_balance_async(struct bt
 	}
 
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
-	if (IS_ERR(tsk))
-		return PTR_ERR(tsk);
-
-	return 0;
+	return PTR_RET(tsk);
 }
 
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info)


