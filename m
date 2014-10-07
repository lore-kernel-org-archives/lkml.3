Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaJGAVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:21:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJGAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:21:49 -0400
Message-Id: <fbb4ef3c4a77221a072705415c12a99251d0c72a.1412640584.git.geoff@infradead.org>
In-Reply-To: <cover.1412640584.git.geoff@infradead.org>
References: <cover.1412640584.git.geoff@infradead.org>
From: Geoff Levand <geoff@infradead.org>
Patch-Date: Wed, 20 Aug 2014 14:44:41 -0700
Subject: [PATCH V21/5] kexec: Fix make headers_check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 00:21:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unneded declaration for a kexec_load() routine.

Fixes errors like these when running 'make headers_check':

include/uapi/linux/kexec.h: userspace cannot reference function or variable defined in the kernel

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 include/uapi/linux/kexec.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 6925f5b..99048e5 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -55,12 +55,6 @@ struct kexec_segment {
 	size_t memsz;
 };
 
-/* Load a new kernel image as described by the kexec_segment array
- * consisting of passed number of segments at the entry-point address.
- * The flags allow different useage types.
- */
-extern int kexec_load(void *, size_t, struct kexec_segment *,
-		unsigned long int);
 #endif /* __KERNEL__ */
 
 #endif /* _UAPILINUX_KEXEC_H */
-- 
1.9.1


