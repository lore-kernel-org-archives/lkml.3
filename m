Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaF3Msz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:48:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbaF3Mah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 171/181] fs: btrfs: volumes.c: Fix for possible null pointer dereference
Date: Mon, 30 Jun 2014 13:53:12 +0200
Message-Id: <4042995ebfd51c4251cf2717e808df6c8860b04b.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8321cf2596d283821acc466377c2b85bcd3422b7 upstream.

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c06616106fa9..7fae00b72283 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1676,11 +1676,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		struct btrfs_fs_devices *fs_devices;
 		fs_devices = root->fs_info->fs_devices;
 		while (fs_devices) {
-			if (fs_devices->seed == cur_devices)
+			if (fs_devices->seed == cur_devices) {
+				fs_devices->seed = cur_devices->seed;
 				break;
+			}
 			fs_devices = fs_devices->seed;
 		}
-		fs_devices->seed = cur_devices->seed;
 		cur_devices->seed = NULL;
 		lock_chunks(root);
 		__btrfs_close_devices(cur_devices);
-- 
2.0.0

