Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaAXBwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 20:52:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaAXBwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 20:52:53 -0500
Date: Thu, 23 Jan 2014 20:52:51 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ia64: limit stack size for the ski emulator
In-Reply-To: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401232043320.16873@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ski emulator can't spawn any process with larger stack than
0x7ffff00000000.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/ia64/include/asm/resource.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-ia64/arch/ia64/include/asm/resource.h
===================================================================
--- linux-2.6-ia64.orig/arch/ia64/include/uapi/asm/resource.h	2013-04-20 19:14:30.000000000 +0200
+++ linux-2.6-ia64/arch/ia64/include/uapi/asm/resource.h	2013-04-20 20:59:00.000000000 +0200
@@ -2,6 +2,12 @@
 #define _ASM_IA64_RESOURCE_H
 
 #include <asm/ustack.h>
+
+#if defined(__KERNEL__) && defined(CONFIG_IA64_HP_SIM)
+/* The ski simulator can't spawn any process with larger stack size */
+#define _STK_LIM_MAX	0x7ffff00000000UL
+#endif
+
 #include <asm-generic/resource.h>
 
 #endif /* _ASM_IA64_RESOURCE_H */

