Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3LSPER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:17 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64307 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3LSPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:12 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, "David S. Miller" <davem@davemloft.net>,
        Federico Vaga <federico.vaga@gmail.com>, sparclinux@vger.kernel.org
Subject: [PATCH 05/38] sparc: kernel: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:16 +0100
Message-Id: <1387465429-3568-6-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
The kfree() has been removed because put_device will set the underlying kref's
reference count to zero and hence vio_dev_release will get called resulting in
kfreeing the structure.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/sparc/kernel/vio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 8647fcc..fb0088d 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -307,7 +307,7 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	if (err) {
 		printk(KERN_ERR "VIO: Could not register device %s, err=%d\n",
 		       dev_name(&vdev->dev), err);
-		kfree(vdev);
+		put_device(&vdev->dev);
 		return NULL;
 	}
 	if (vdev->dp)
-- 
1.8.3.1

