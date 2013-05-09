Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3EIWMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:12:00 -0400
Received: from longford.logfs.org ([213.229.74.203]:59083 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3EIWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:11:57 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 11/14] blockconsole: Rename device_lock with bc_device_lock
Date: Thu,  9 May 2013 16:43:09 -0400
Message-Id: <1368132193-25817-14-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Avoid the name conflict with device_lock() defined in linux/device.h.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index c22272f..40cc96e 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -546,17 +546,17 @@ static void bcon_create_fuzzy(const char *name)
 	}
 }
 
-static DEFINE_SPINLOCK(device_lock);
+static DEFINE_SPINLOCK(bcon_device_lock);
 static char scanned_devices[80];
 
 static void bcon_do_add(struct work_struct *work)
 {
 	char local_devices[80], *name, *remainder = local_devices;
 
-	spin_lock(&device_lock);
+	spin_lock(&bcon_device_lock);
 	memcpy(local_devices, scanned_devices, sizeof(local_devices));
 	memset(scanned_devices, 0, sizeof(scanned_devices));
-	spin_unlock(&device_lock);
+	spin_unlock(&bcon_device_lock);
 
 	while (remainder && remainder[0]) {
 		name = strsep(&remainder, ",");
@@ -573,11 +573,11 @@ void bcon_add(const char *name)
 	 * to go pick it up asap.  Once it is picked up, the buffer is empty
 	 * again, so hopefully it will suffice for all sane users.
 	 */
-	spin_lock(&device_lock);
+	spin_lock(&bcon_device_lock);
 	if (scanned_devices[0])
 		strncat(scanned_devices, ",", sizeof(scanned_devices));
 	strncat(scanned_devices, name, sizeof(scanned_devices));
-	spin_unlock(&device_lock);
+	spin_unlock(&bcon_device_lock);
 	schedule_work(&bcon_add_work);
 }
 
-- 
1.7.10.4

