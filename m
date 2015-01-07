Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbbAGUxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:53:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48135 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbbAGUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:53:21 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 9/9] init: remove "root=" command line option test for tmpfs decision
Date: Wed,  7 Jan 2015 15:53:00 -0500
Message-Id: <1420663980-20842-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010720-0029-0000-0000-0000019C4C36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "root=" option is interpreted by the kernel sometimes and passed
on to userspace other times.  Based on whether the "root=" boot
command line option is specified, the initramfs uses tmpfs or ramfs
as the rootfs.

This is a temporary patch that removes the "root=" test in the
decision to use tmpfs or ramfs as the rootfs.  Modify userspace
applications (eg. dracut, systemd) to support "ROOT=" in addition
to "root=".

(Not to be upstreamed.)

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 init/do_mounts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f2288..b2f5e7d 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -622,7 +622,7 @@ int __init init_rootfs(void)
 	if (err)
 		return err;
 
-	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+	if (IS_ENABLED(CONFIG_TMPFS) &&
 		(!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
 		err = shmem_init();
 		is_tmpfs = true;
-- 
1.8.1.4

