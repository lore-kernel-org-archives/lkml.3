Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaKMATw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:19:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaKMATu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:19:50 -0500
Message-Id: <100b0720dcbf9746070e1f9a9ec2a95b6f8694a8.1415837218.git.geoff@infradead.org>
In-Reply-To: <cover.1415837218.git.geoff@infradead.org>
References: <cover.1415837218.git.geoff@infradead.org>
From: Geoff Levand <geoff@infradead.org>
Patch-Date: Wed, 20 Aug 2014 14:44:41 -0700
Subject: [PATCH V3 3/4] kexec: Add bit definitions for kimage entry flags
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 00:19:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define new kexec preprocessor macros IND_*_BIT that define the bit position of
the kimage entry flags.  Change the existing IND_* flag macros to be defined as
bit shifts of the corresponding IND_*_BIT macros.  Also wrap all C language code
in kexec.h with #if !defined(__ASSEMBLY__) so assembly files can include kexec.h
to get the IND_* and IND_*_BIT macros.

Some CPU instruction sets have tests for bit position which are convenient in
implementing routines that operate on the kimage entry list.  The addition of
these bit position macros in a common location will avoid duplicate definitions
and the chance that changes to the IND_* flags will not be propagated to
assembly files.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/kexec.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 9d957b7..25e039c 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -1,6 +1,18 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
+#define IND_DESTINATION_BIT 0
+#define IND_INDIRECTION_BIT 1
+#define IND_DONE_BIT        2
+#define IND_SOURCE_BIT      3
+
+#define IND_DESTINATION  (1 << IND_DESTINATION_BIT)
+#define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
+#define IND_DONE         (1 << IND_DONE_BIT)
+#define IND_SOURCE       (1 << IND_SOURCE_BIT)
+
+#if !defined(__ASSEMBLY__)
+
 #include <uapi/linux/kexec.h>
 
 #ifdef CONFIG_KEXEC
@@ -64,10 +76,6 @@
  */
 
 typedef unsigned long kimage_entry_t;
-#define IND_DESTINATION  0x1
-#define IND_INDIRECTION  0x2
-#define IND_DONE         0x4
-#define IND_SOURCE       0x8
 
 struct kexec_segment {
 	/*
@@ -313,4 +321,7 @@ struct task_struct;
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
+
+#endif /* !defined(__ASSEBMLY__) */
+
 #endif /* LINUX_KEXEC_H */
-- 
1.9.1


