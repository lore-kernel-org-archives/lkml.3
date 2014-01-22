Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaAVNth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:49:37 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39325 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaAVNtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:49:36 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 5/6] staging/lustre/libcfs: remove CAPABILITY_VERSION tests
Date: Wed, 22 Jan 2014 21:47:36 +0800
Message-Id: <1390398457-31140-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
References: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_LINUX_CAPABILITY_VERSION is only for backward compatibility in
user space. Kernel code doesn't care about it.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 81a1d0d..8b3af7f 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -80,29 +80,13 @@ int cfs_cap_raised(cfs_cap_t cap)
 
 void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 {
-#if defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x19980330
-	*cap = kcap;
-#elif defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x20071026
-	*cap = kcap[0];
-#elif defined(_KERNEL_CAPABILITY_VERSION) && _KERNEL_CAPABILITY_VERSION == 0x20080522
 	/* XXX lost high byte */
 	*cap = kcap.cap[0];
-#else
-	#error "need correct _KERNEL_CAPABILITY_VERSION "
-#endif
 }
 
 void cfs_kernel_cap_unpack(kernel_cap_t *kcap, cfs_cap_t cap)
 {
-#if defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x19980330
-	*kcap = cap;
-#elif defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x20071026
-	(*kcap)[0] = cap;
-#elif defined(_KERNEL_CAPABILITY_VERSION) && _KERNEL_CAPABILITY_VERSION == 0x20080522
 	kcap->cap[0] = cap;
-#else
-	#error "need correct _KERNEL_CAPABILITY_VERSION "
-#endif
 }
 
 cfs_cap_t cfs_curproc_cap_pack(void)
-- 
1.7.9.5

