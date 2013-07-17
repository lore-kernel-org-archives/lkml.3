Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3GQWsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:48:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab3GQWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/145] UBIFS: correct mount message
Date: Wed, 17 Jul 2013 15:45:33 -0700
Message-Id: <1374101277-7915-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@gmail.com>

commit beadadfa5467e09e36891f39cae1f5d8d3bbf17e upstream.

When mounting an UBIFS R/W volume, we have the message:
UBIFS: mounted UBI device 0, volume 1, name "rootfs"(null)
With this patch, we'll have:
UBIFS: mounted UBI device 0, volume 1, name "rootfs"
Which is, I think, what was intended.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 97f6875..d00b7d4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1412,7 +1412,7 @@ static int mount_ubifs(struct ubifs_info *c)
 
 	ubifs_msg("mounted UBI device %d, volume %d, name \"%s\"%s",
 		  c->vi.ubi_num, c->vi.vol_id, c->vi.name,
-		  c->ro_mount ? ", R/O mode" : NULL);
+		  c->ro_mount ? ", R/O mode" : "");
 	x = (long long)c->main_lebs * c->leb_size;
 	y = (long long)c->log_lebs * c->leb_size + c->max_bud_bytes;
 	ubifs_msg("LEB size: %d bytes (%d KiB), min./max. I/O unit sizes: %d bytes/%d bytes",
-- 
1.8.1.2

