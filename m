Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaAVNtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:49:00 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61482 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaAVNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:48:59 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 4/6] staging/lustre/libcfs: remove cfs_cap_{un}pack
Date: Wed, 22 Jan 2014 21:47:35 +0800
Message-Id: <1390398457-31140-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
References: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   24 ++++++++------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 65cb2fa..81a1d0d 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -55,15 +55,11 @@
  * for Linux kernel.
  */
 
-/* Currently all the CFS_CAP_* defines match CAP_* ones. */
-#define cfs_cap_pack(cap) (cap)
-#define cfs_cap_unpack(cap) (cap)
-
 void cfs_cap_raise(cfs_cap_t cap)
 {
 	struct cred *cred;
 	if ((cred = prepare_creds())) {
-		cap_raise(cred->cap_effective, cfs_cap_unpack(cap));
+		cap_raise(cred->cap_effective, cap);
 		commit_creds(cred);
 	}
 }
@@ -72,25 +68,25 @@ void cfs_cap_lower(cfs_cap_t cap)
 {
 	struct cred *cred;
 	if ((cred = prepare_creds())) {
-		cap_lower(cred->cap_effective, cfs_cap_unpack(cap));
+		cap_lower(cred->cap_effective, cap);
 		commit_creds(cred);
 	}
 }
 
 int cfs_cap_raised(cfs_cap_t cap)
 {
-	return cap_raised(current_cap(), cfs_cap_unpack(cap));
+	return cap_raised(current_cap(), cap);
 }
 
 void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 {
 #if defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x19980330
-	*cap = cfs_cap_pack(kcap);
+	*cap = kcap;
 #elif defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x20071026
-	*cap = cfs_cap_pack(kcap[0]);
+	*cap = kcap[0];
 #elif defined(_KERNEL_CAPABILITY_VERSION) && _KERNEL_CAPABILITY_VERSION == 0x20080522
 	/* XXX lost high byte */
-	*cap = cfs_cap_pack(kcap.cap[0]);
+	*cap = kcap.cap[0];
 #else
 	#error "need correct _KERNEL_CAPABILITY_VERSION "
 #endif
@@ -99,11 +95,11 @@ void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 void cfs_kernel_cap_unpack(kernel_cap_t *kcap, cfs_cap_t cap)
 {
 #if defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x19980330
-	*kcap = cfs_cap_unpack(cap);
+	*kcap = cap;
 #elif defined (_LINUX_CAPABILITY_VERSION) && _LINUX_CAPABILITY_VERSION == 0x20071026
-	(*kcap)[0] = cfs_cap_unpack(cap);
+	(*kcap)[0] = cap;
 #elif defined(_KERNEL_CAPABILITY_VERSION) && _KERNEL_CAPABILITY_VERSION == 0x20080522
-	kcap->cap[0] = cfs_cap_unpack(cap);
+	kcap->cap[0] = cap;
 #else
 	#error "need correct _KERNEL_CAPABILITY_VERSION "
 #endif
@@ -118,7 +114,7 @@ cfs_cap_t cfs_curproc_cap_pack(void)
 
 int cfs_capable(cfs_cap_t cap)
 {
-	return capable(cfs_cap_unpack(cap));
+	return capable(cap);
 }
 
 static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
-- 
1.7.9.5

