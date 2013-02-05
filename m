Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3BEMfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:35:12 -0500
Received: from mga07.intel.com ([143.182.124.22]:9855 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755210Ab3BEMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:35:07 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 1/2] export unpack_to_rootfs
Date: Tue,  5 Feb 2013 14:34:49 +0200
Message-Id: <7fe9b3a51f3b7172fcb85721cea9162f840aaaa6.1360067333.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1360067333.git.dmitry.kasatkin@intel.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1360067333.git.dmitry.kasatkin@intel.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 init/do_mounts.h |    2 ++
 init/initramfs.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/init/do_mounts.h b/init/do_mounts.h
index f5b978a..11829eb 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -74,3 +74,5 @@ void md_run_setup(void);
 static inline void md_run_setup(void) {}
 
 #endif
+
+char * __init unpack_to_rootfs(char *buf, unsigned len);
diff --git a/init/initramfs.c b/init/initramfs.c
index 84c6bf1..e32bc06 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -421,7 +421,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
 #include <linux/decompress/generic.h>
 
-static char * __init unpack_to_rootfs(char *buf, unsigned len)
+char * __init unpack_to_rootfs(char *buf, unsigned len)
 {
 	int written, res;
 	decompress_fn decompress;
-- 
1.7.10.4

