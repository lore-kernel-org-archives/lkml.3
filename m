Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaAPXyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:54:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47946 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAPXyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:54:10 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/8] powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
Date: Thu, 16 Jan 2014 15:53:49 -0800
Message-Id: <1389916434-2288-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011623-5806-0000-0000-000023E391CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index d8b600b..48d6efa 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -269,11 +269,15 @@
 #define H_COP			0x304
 #define H_GET_MPP_X		0x314
 #define H_SET_MODE		0x31C
-#define MAX_HCALL_OPCODE	H_SET_MODE
+#define H_GET_24X7_CATALOG_PAGE 0xF078
+#define H_GET_24X7_DATA		0xF07C
+#define H_GET_PERF_COUNTER_INFO 0xF080
+#define MAX_HCALL_OPCODE	H_GET_PERF_COUNTER_INFO
 
 /* Platform specific hcalls, used by KVM */
 #define H_RTAS			0xf000
 
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
1.8.5.2

