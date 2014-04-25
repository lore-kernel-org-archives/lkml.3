Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaDYJMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:12:35 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34827 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaDYJMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 02/11] KVM: s390: Use trace tables from sie.h.
Date: Fri, 25 Apr 2014 11:12:24 +0200
Message-Id: <1398417153-57347-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-2966-0000-0000-00000B0C5C53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Use the symbolic translation tables from sie.h for decoding diag, sigp
and sie exit codes.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/trace.h | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/arch/s390/kvm/trace.h b/arch/s390/kvm/trace.h
index abf6ba5..00f57a5 100644
--- a/arch/s390/kvm/trace.h
+++ b/arch/s390/kvm/trace.h
@@ -2,7 +2,7 @@
 #define _TRACE_KVM_H
 
 #include <linux/tracepoint.h>
-#include <asm/sigp.h>
+#include <asm/sie.h>
 #include <asm/debug.h>
 #include <asm/dis.h>
 
@@ -125,17 +125,6 @@ TRACE_EVENT(kvm_s390_sie_fault,
 	    VCPU_TP_PRINTK("%s", "fault in sie instruction")
 	);
 
-#define sie_intercept_code				\
-	{0x04, "Instruction"},				\
-	{0x08, "Program interruption"},			\
-	{0x0C, "Instruction and program interruption"},	\
-	{0x10, "External request"},			\
-	{0x14, "External interruption"},		\
-	{0x18, "I/O request"},				\
-	{0x1C, "Wait state"},				\
-	{0x20, "Validity"},				\
-	{0x28, "Stop request"}
-
 TRACE_EVENT(kvm_s390_sie_exit,
 	    TP_PROTO(VCPU_PROTO_COMMON, u8 icptcode),
 	    TP_ARGS(VCPU_ARGS_COMMON, icptcode),
@@ -227,18 +216,6 @@ TRACE_EVENT(kvm_s390_intercept_validity,
  * Trace points for instructions that are of special interest.
  */
 
-#define sigp_order_codes					\
-	{SIGP_SENSE, "sense"},					\
-	{SIGP_EXTERNAL_CALL, "external call"},			\
-	{SIGP_EMERGENCY_SIGNAL, "emergency signal"},		\
-	{SIGP_STOP, "stop"},					\
-	{SIGP_STOP_AND_STORE_STATUS, "stop and store status"},	\
-	{SIGP_SET_ARCHITECTURE, "set architecture"},		\
-	{SIGP_SET_PREFIX, "set prefix"},			\
-	{SIGP_STORE_STATUS_AT_ADDRESS, "store status at addr"},	\
-	{SIGP_SENSE_RUNNING, "sense running"},			\
-	{SIGP_RESTART, "restart"}
-
 TRACE_EVENT(kvm_s390_handle_sigp,
 	    TP_PROTO(VCPU_PROTO_COMMON, __u8 order_code, __u16 cpu_addr, \
 		     __u32 parameter),
@@ -265,13 +242,6 @@ TRACE_EVENT(kvm_s390_handle_sigp,
 			   __entry->cpu_addr, __entry->parameter)
 	);
 
-#define diagnose_codes				\
-	{0x10, "release pages"},		\
-	{0x44, "time slice end"},		\
-	{0x308, "ipl functions"},		\
-	{0x500, "kvm hypercall"},		\
-	{0x501, "kvm breakpoint"}
-
 TRACE_EVENT(kvm_s390_handle_diag,
 	    TP_PROTO(VCPU_PROTO_COMMON, __u16 code),
 	    TP_ARGS(VCPU_ARGS_COMMON, code),
-- 
1.8.4.2

