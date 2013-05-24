Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3EXOEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab3EXOEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:04:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: fix DLM depends to fix build errors
Date: Fri, 24 May 2013 14:37:34 +0100
Message-Id: <1369402655-26600-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
References: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors by correcting DLM dependencies in GFS2.
Build errors happen when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:

fs/built-in.o: In function `gfs2_lock':
file.c:(.text+0xc7abd): undefined reference to `dlm_posix_get'
file.c:(.text+0xc7ad0): undefined reference to `dlm_posix_unlock'
file.c:(.text+0xc7ad9): undefined reference to `dlm_posix_lock'
fs/built-in.o: In function `gdlm_unmount':
lock_dlm.c:(.text+0xd6e5b): undefined reference to `dlm_release_lockspace'
fs/built-in.o: In function `sync_unlock':
lock_dlm.c:(.text+0xd6e9e): undefined reference to `dlm_unlock'
fs/built-in.o: In function `sync_lock':
lock_dlm.c:(.text+0xd6fb6): undefined reference to `dlm_lock'
fs/built-in.o: In function `gdlm_put_lock':
lock_dlm.c:(.text+0xd7238): undefined reference to `dlm_unlock'
fs/built-in.o: In function `gdlm_mount':
lock_dlm.c:(.text+0xd753e): undefined reference to `dlm_new_lockspace'
lock_dlm.c:(.text+0xd79d3): undefined reference to `dlm_release_lockspace'
fs/built-in.o: In function `gdlm_lock':
lock_dlm.c:(.text+0xd8179): undefined reference to `dlm_lock'
fs/built-in.o: In function `gdlm_cancel':
lock_dlm.c:(.text+0xd6b22): undefined reference to `dlm_unlock'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index eb08c9e..5a376ab 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -26,7 +26,7 @@ config GFS2_FS
 config GFS2_FS_LOCKING_DLM
 	bool "GFS2 DLM locking"
 	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
-		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
+		HOTPLUG && CONFIGFS_FS && SYSFS && (DLM=y || DLM=GFS2_FS)
 	help
 	  Multiple node locking module for GFS2
 
-- 
1.7.4

