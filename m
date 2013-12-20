Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3LTRCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:02:24 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:52648 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3LTRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:02:23 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>, P J P <ppandit@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Makefile: fix order of INITRD_COMPRESS-y assignments
Date: Fri, 20 Dec 2013 12:02:07 -0500
Message-Id: <1387558927-17674-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7ac181568342ec (fix build with make 3.80) changed how the
Makefile handles the INITRD_COMPRESS-y assignment in order to make it
work properly with older versions of make. Unfortunately, it also
changes the behavior of how that assignment works when multiple
CONFIG_RD_* options are set, such that they are now preferred in the
reverse order of the way they were before.

Reverse the order of assignments to try and preserve the earlier
precedence in this situation.

Cc: Jan Beulich <jbeulich@suse.com>
Cc: P J P <ppandit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 89cee86..fb76899 100644
--- a/Makefile
+++ b/Makefile
@@ -733,11 +733,11 @@ export mod_strip_cmd
 # This shall be used by the dracut(8) tool while creating an initramfs image.
 #
 INITRD_COMPRESS-y                  := gzip
-INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
-INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
-INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
-INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
 INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
+INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
+INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
+INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
+INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
 export INITRD_COMPRESS := $(INITRD_COMPRESS-y)
 
 ifdef CONFIG_MODULE_SIG_ALL
-- 
1.8.4.2

