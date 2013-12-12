Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3LLPqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:46:13 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55384 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3LLPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:46:07 -0500
Message-ID: <52A9DA34.40905@linux.vnet.ibm.com>
Date: Thu, 12 Dec 2013 21:15:56 +0530
From: Rajesh B Prathipati <rprathip@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@au1.ibm.com
Subject: [PATCH] powerpc: Make unaligned accesses endian-safe for powerpc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121215-8256-0000-0000-00000A89E493
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajesh B Prathipati <rprathip@linux.vnet.ibm.com>

The generic put_unaligned/get_unaligned macros were made endian-safe by 
calling the appropriate endian dependent macros based on the endian type 
of the powerpc processor.

Signed-off-by: Rajesh B Prathipati <rprathip@linux.vnet.ibm.com>
---
This patch applies to linux kernel version 3.12. This patch has been 
tested and it fixes the problem with linux 3.12 USB stack.

--- linux/arch/powerpc/include/asm/unaligned.h.orig     2013-12-12 
00:07:05.329073544 -0200
+++ linux/arch/powerpc/include/asm/unaligned.h  2013-12-11 
23:56:52.918630238 -0200
@@ -4,13 +4,18 @@
  #ifdef __KERNEL__

  /*
- * The PowerPC can do unaligned accesses itself in big endian mode.
+ * The PowerPC can do unaligned accesses itself based on its endian mode.
   */
  #include <linux/unaligned/access_ok.h>
  #include <linux/unaligned/generic.h>

+#ifdef __LITTLE_ENDIAN__
+#define get_unaligned  __get_unaligned_le
+#define put_unaligned  __put_unaligned_le
+#else
  #define get_unaligned  __get_unaligned_be
  #define put_unaligned  __put_unaligned_be
+#endif

  #endif /* __KERNEL__ */
  #endif /* _ASM_POWERPC_UNALIGNED_H */

