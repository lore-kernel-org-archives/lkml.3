Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaAONRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:17:09 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52341 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbaAONRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:17:07 -0500
Message-ID: <1389791824.17407.9.camel@x220>
Subject: [PATCH] kexec.h: stop exporting kexec_load() to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Biederman <ebiederm@xmission.com>
Cc: Maximilian Attems <max@stro.at>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Jan 2014 14:17:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2014 13:17:05.0231 (UTC) FILETIME=[15CA5DF0:01CF11F4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.5 kexec.h is exported to userspace. That includes its
declaration of kexec_load():
    extern int kexec_load(void *, size_t, struct kexec_segment *,
                   unsigned long int);

This declaration isn't very useful to userspace programs on itself. They
still have to define a matching function (which basically wraps the
kexec_load syscall). I'm not aware of programs or libraries that actually
do that.

It can be removed. The programs that actually use it, if there
are any, should then provide their own declaration to keep compiling.
Already compiled binaries will not be affected.

This gets rid of the headers_check warning that can be seen ever since
this header was exported:
    [...]/usr/include/linux/kexec.h:49: userspace cannot reference function or variable defined in the kernel

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This declaration of kexec_load() was added to kexec.h in commit
29a5c67e7a ("kexec: export kexec.h to user space").

 include/uapi/linux/kexec.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 104838f..c7897b6 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -42,13 +42,6 @@ struct kexec_segment {
 	const void *mem;
 	size_t memsz;
 };
-
-/* Load a new kernel image as described by the kexec_segment array
- * consisting of passed number of segments at the entry-point address.
- * The flags allow different useage types.
- */
-extern int kexec_load(void *, size_t, struct kexec_segment *,
-		unsigned long int);
 #endif /* __KERNEL__ */
 
 #endif /* _UAPILINUX_KEXEC_H */
-- 
1.8.4.2

