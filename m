Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3J2QgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:36:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3J2QgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:36:19 -0400
Message-ID: <526FE401.8000102@redhat.com>
Date: Tue, 29 Oct 2013 11:36:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] errno.h: remove "NFS" from descriptions in comments
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc recently changed the error string for ESTALE to remove "NFS" -

https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=96945714ec61951cc748da2b4b8a80cf02127ee9

from: [ERR_REMAP (ESTALE)] = N_("Stale NFS file handle"),
to:   [ERR_REMAP (ESTALE)] = N_("Stale file handle"),

And some have expressed concern that the kernel's errno.h
comments still refer to NFS.

So make that change... note that this is a comment-only change,
and has no functional difference.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. although this hits multiple arches, it's so inconsequential I sent
one patch covering it all, I hope that's ok.

diff --git a/arch/alpha/include/uapi/asm/errno.h b/arch/alpha/include/uapi/asm/errno.h
index e5f29ca..17f92aa 100644
--- a/arch/alpha/include/uapi/asm/errno.h
+++ b/arch/alpha/include/uapi/asm/errno.h
@@ -43,7 +43,7 @@
 
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 
 #define	ENOLCK		77	/* No record locks available */
diff --git a/arch/mips/include/uapi/asm/errno.h b/arch/mips/include/uapi/asm/errno.h
index 31575e2..02d645d 100644
--- a/arch/mips/include/uapi/asm/errno.h
+++ b/arch/mips/include/uapi/asm/errno.h
@@ -102,7 +102,7 @@
 #define EWOULDBLOCK	EAGAIN	/* Operation would block */
 #define EALREADY	149	/* Operation already in progress */
 #define EINPROGRESS	150	/* Operation now in progress */
-#define ESTALE		151	/* Stale NFS file handle */
+#define ESTALE		151	/* Stale file handle */
 #define ECANCELED	158	/* AIO operation canceled */
 
 /*
diff --git a/arch/parisc/include/uapi/asm/errno.h b/arch/parisc/include/uapi/asm/errno.h
index 135ad60..f3a8aa5 100644
--- a/arch/parisc/include/uapi/asm/errno.h
+++ b/arch/parisc/include/uapi/asm/errno.h
@@ -37,7 +37,7 @@
 #define	EBADMSG		67	/* Not a data message */
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 #define	EOVERFLOW	72	/* Value too large for defined data type */
 
diff --git a/arch/sparc/include/uapi/asm/errno.h b/arch/sparc/include/uapi/asm/errno.h
index c351aba..20423e1 100644
--- a/arch/sparc/include/uapi/asm/errno.h
+++ b/arch/sparc/include/uapi/asm/errno.h
@@ -40,7 +40,7 @@
 #define EPROCLIM        67      /* SUNOS: Too many processes */
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 #define	ENOSTR		72	/* Device not a stream */
 #define	ETIME		73	/* Timer expired */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h b/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
index 2870487..35aefa2 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
@@ -165,7 +165,7 @@
 #define LUSTRE_EHOSTUNREACH	113	/* No route to host */
 #define LUSTRE_EALREADY		114	/* Operation already in progress */
 #define LUSTRE_EINPROGRESS	115	/* Operation now in progress */
-#define LUSTRE_ESTALE		116	/* Stale NFS file handle */
+#define LUSTRE_ESTALE		116	/* Stale file handle */
 #define LUSTRE_EUCLEAN		117	/* Structure needs cleaning */
 #define LUSTRE_ENOTNAM		118	/* Not a XENIX named type file */
 #define LUSTRE_ENAVAIL		119	/* No XENIX semaphores available */
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index a1331ce..1e1ea6e 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -86,7 +86,7 @@
 #define	EHOSTUNREACH	113	/* No route to host */
 #define	EALREADY	114	/* Operation already in progress */
 #define	EINPROGRESS	115	/* Operation now in progress */
-#define	ESTALE		116	/* Stale NFS file handle */
+#define	ESTALE		116	/* Stale file handle */
 #define	EUCLEAN		117	/* Structure needs cleaning */
 #define	ENOTNAM		118	/* Not a XENIX named type file */
 #define	ENAVAIL		119	/* No XENIX semaphores available */

