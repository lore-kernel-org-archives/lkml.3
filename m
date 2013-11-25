Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3KYI5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:35 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39876 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 22/24] s390: Separate kernel/userspace inclusion of <asm-generic/int-ll64.h>
Date: Mon, 25 Nov 2013 09:55:32 +0100
Message-Id: <1385369734-24893-23-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to rename the kernelspace version later.

Now arch/s390/include/asm/types.h includes the kernelspace version,
while arch/s390/include/uapi/asm/types.h includes the userspace version.
As arch/s390/include/uapi/asm/types.h is also included for kernelspace,
its inclusion of <asm-generic/int-ll64.h> needs to be protected by #ifndef
__KERNEL__.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/types.h      |    1 +
 arch/s390/include/uapi/asm/types.h |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/s390/include/asm/types.h b/arch/s390/include/asm/types.h
index dccef3ca91fa..a5c7e829dbc3 100644
--- a/arch/s390/include/asm/types.h
+++ b/arch/s390/include/asm/types.h
@@ -6,6 +6,7 @@
 #ifndef _S390_TYPES_H
 #define _S390_TYPES_H
 
+#include <asm-generic/int-ll64.h>
 #include <uapi/asm/types.h>
 
 /*
diff --git a/arch/s390/include/uapi/asm/types.h b/arch/s390/include/uapi/asm/types.h
index 038f2b9178a4..13b5ad14380d 100644
--- a/arch/s390/include/uapi/asm/types.h
+++ b/arch/s390/include/uapi/asm/types.h
@@ -7,7 +7,9 @@
 #ifndef _UAPI_S390_TYPES_H
 #define _UAPI_S390_TYPES_H
 
+#ifndef __KERNEL__
 #include <asm-generic/int-ll64.h>
+#endif
 
 #ifndef __ASSEMBLY__
 
-- 
1.7.9.5

