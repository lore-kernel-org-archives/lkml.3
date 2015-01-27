Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbbA0Me2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:34:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35241 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbbA0MS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 076/126] usb: gadget: gadgetfs: Free memory allocated by memdup_user()
Date: Tue, 27 Jan 2015 12:16:21 +0000
Message-Id: <1422361031-19364-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>

commit b44be2462dbe3e23f0aedff64de52a1e8e47a1cd upstream.

Commit 3b74c73f8d6f053f422e85fce955b61fb181cfe7 switched over to memdup_user()
in ep_write() function and removed kfree (kbuf).
memdup_user() function allocates memory which is never freed.

Fixes: 3b74c73 (usb: gadget: inode: switch over to memdup_user())
Signed-off-by: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.16:
  - file rename: drivers/usb/gadget/legacy/inode.c ->
    drivers/usb/gadget/inode.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 2e4ce7704908..c44dc6ef2500 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -450,6 +450,7 @@ ep_write (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		data->name, len, (int) value);
 free1:
 	mutex_unlock(&data->lock);
+	kfree (kbuf);
 	return value;
 }
 
-- 
2.1.4

