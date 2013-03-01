Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3CARRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:17:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab3CARRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:17:49 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/3] blockconsole: Rename device_lock with bc_device_lock
Date: Fri,  1 Mar 2013 18:17:47 +0100
Message-Id: <1362158268-21122-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362158268-21122-1-git-send-email-tiwai@suse.de>
References: <s5htxovxcrl.wl%tiwai@suse.de>
 <1362158268-21122-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the name conflict with device_lock() defined in linux/device.h.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/block/blockconsole.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index c22272f..147b8af 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -546,17 +546,17 @@ static void bcon_create_fuzzy(const char *name)
 	}
 }
 
-static DEFINE_SPINLOCK(device_lock);
+static DEFINE_SPINLOCK(bc_device_lock);
 static char scanned_devices[80];
 
 static void bcon_do_add(struct work_struct *work)
 {
 	char local_devices[80], *name, *remainder = local_devices;
 
-	spin_lock(&device_lock);
+	spin_lock(&bc_device_lock);
 	memcpy(local_devices, scanned_devices, sizeof(local_devices));
 	memset(scanned_devices, 0, sizeof(scanned_devices));
-	spin_unlock(&device_lock);
+	spin_unlock(&bc_device_lock);
 
 	while (remainder && remainder[0]) {
 		name = strsep(&remainder, ",");
@@ -573,11 +573,11 @@ void bcon_add(const char *name)
 	 * to go pick it up asap.  Once it is picked up, the buffer is empty
 	 * again, so hopefully it will suffice for all sane users.
 	 */
-	spin_lock(&device_lock);
+	spin_lock(&bc_device_lock);
 	if (scanned_devices[0])
 		strncat(scanned_devices, ",", sizeof(scanned_devices));
 	strncat(scanned_devices, name, sizeof(scanned_devices));
-	spin_unlock(&device_lock);
+	spin_unlock(&bc_device_lock);
 	schedule_work(&bcon_add_work);
 }
 
-- 
1.8.1.4

