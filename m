Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaI0MRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 08:17:36 -0400
Received: from venev.name ([95.111.59.253]:57169 "EHLO venev.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaI0MRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 08:17:35 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 08:17:35 EDT
From: hristo@hristo.venev.name
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hristo Venev <hristo@venev.name>
Subject: [PATCH] init: Mount devtmpfs before mounting root.
Date: Sat, 27 Sep 2014 15:08:42 +0300
Message-Id: <1411819722-10684-1-git-send-email-hristo@venev.name>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs may require /dev in case there are multiple devices

Example:
root=/dev/sda1 rootfstype=btrfs rootflags=device=/dev/sdb1
---
 init/do_mounts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f2288..9612958 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -527,8 +527,10 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
+	sys_mount(NULL, "/dev", "devtmpfs", 0, NULL);
 	create_dev("/dev/root", ROOT_DEV);
 	mount_block_root("/dev/root", root_mountflags);
+	sys_umount("/dev", 0);
 #endif
 }
 
-- 
2.1.1

