Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaEFNAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:00:30 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:35227 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEFNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:00:29 -0400
From: Aaro Koskinen <aaro.koskinen@nsn.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>
Subject: [PATCH RESEND] MIPS: Add __SANE_USERSPACE_TYPES__ to asm/types.h for LL64
Date: Tue,  6 May 2014 15:55:43 +0300
Message-Id: <1399380943-22082-1-git-send-email-aaro.koskinen@nsn.com>
X-Mailer: git-send-email 1.9.1
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1272
X-purgate-ID: 151667::1399381222-00001564-B1558E5E/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow 64-bit userspace programs to use ll64 types. The define name
comes from commit 2c9c6ce0199a4d252e20c531cfdc9d24e39235c0 (powerpc:
Add __SANE_USERSPACE_TYPES__ to asm/types.h for LL64).

The patch allows to compile perf on MIPS64 and eliminates the following
warnings:

tests/attr.c:74:4: error: format '%llu' expects argument of type 'long
long unsigned int', but argument 6 has type '__u64' [-Werror=format=]

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
---
 arch/mips/include/uapi/asm/types.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/types.h b/arch/mips/include/uapi/asm/types.h
index 7ac9d0b..f3dd9ff 100644
--- a/arch/mips/include/uapi/asm/types.h
+++ b/arch/mips/include/uapi/asm/types.h
@@ -14,9 +14,12 @@
 /*
  * We don't use int-l64.h for the kernel anymore but still use it for
  * userspace to avoid code changes.
+ *
+ * However, some user programs (e.g. perf) may not want this. They can
+ * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
  */
 #ifndef __KERNEL__
-# if _MIPS_SZLONG == 64
+# if _MIPS_SZLONG == 64 && !defined(__SANE_USERSPACE_TYPES__)
 #  include <asm-generic/int-l64.h>
 # else
 #  include <asm-generic/int-ll64.h>
-- 
1.9.1

