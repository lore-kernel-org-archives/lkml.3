Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaLOThh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:37:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaLOTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 80/96] drivers/input/evdev.c: don't kfree() a vmalloc address
Date: Mon, 15 Dec 2014 11:26:40 -0800
Message-Id: <1418671616-25482-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 92788ac1eb06e69a822de45e2a8a63fa45eb5be2 upstream.

If kzalloc() failed and then evdev_open_device() fails, evdev_open()
will pass a vmalloc'ed pointer to kfree.

This might fix https://bugzilla.kernel.org/show_bug.cgi?id=88401, where
there was a crash in kfree().

Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Belatedly-Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/evdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a06e125..c33c8ff 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -422,7 +422,7 @@ static int evdev_open(struct inode *inode, struct file *file)
 
  err_free_client:
 	evdev_detach_client(evdev, client);
-	kfree(client);
+	kvfree(client);
 	return error;
 }
 
-- 
1.9.1

