Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3FZHmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:42:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34023 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FZHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:42:07 -0400
Date: Wed, 26 Jun 2013 00:41:06 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: eranian@google.com, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>, ellerman@au1.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 1/3][v2] perf: Move PERF_MEM*SHIFT macros up the block
Message-ID: <20130626074106.GA3741@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062607-3620-0000-0000-0000034A48E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 14:03:01 -0700
Subject: [RFC][PATCH 1/3][v2] perf: Move PERF_MEM*SHIFT macros up the block

Values for the PERF_MEM_*SHIFT macros depend on the block before
them, so it would be more readable if they are in the beginning
of the block.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 include/uapi/linux/perf_event.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..52697a3 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -632,14 +632,15 @@ union perf_mem_data_src {
 };
 
 /* type of opcode (load/store/prefetch,code) */
+#define PERF_MEM_OP_SHIFT	0
 #define PERF_MEM_OP_NA		0x01 /* not available */
 #define PERF_MEM_OP_LOAD	0x02 /* load instruction */
 #define PERF_MEM_OP_STORE	0x04 /* store instruction */
 #define PERF_MEM_OP_PFETCH	0x08 /* prefetch */
 #define PERF_MEM_OP_EXEC	0x10 /* code (execution) */
-#define PERF_MEM_OP_SHIFT	0
 
 /* memory hierarchy (memory level, hit or miss) */
+#define PERF_MEM_LVL_SHIFT	5
 #define PERF_MEM_LVL_NA		0x01  /* not available */
 #define PERF_MEM_LVL_HIT	0x02  /* hit level */
 #define PERF_MEM_LVL_MISS	0x04  /* miss level  */
@@ -654,22 +655,22 @@ union perf_mem_data_src {
 #define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
 #define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
 #define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
-#define PERF_MEM_LVL_SHIFT	5
 
 /* snoop mode */
+#define PERF_MEM_SNOOP_SHIFT	19
 #define PERF_MEM_SNOOP_NA	0x01 /* not available */
 #define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
 #define PERF_MEM_SNOOP_HIT	0x04 /* snoop hit */
 #define PERF_MEM_SNOOP_MISS	0x08 /* snoop miss */
 #define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
-#define PERF_MEM_SNOOP_SHIFT	19
 
 /* locked instruction */
+#define PERF_MEM_LOCK_SHIFT	24
 #define PERF_MEM_LOCK_NA	0x01 /* not available */
 #define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
-#define PERF_MEM_LOCK_SHIFT	24
 
 /* TLB access */
+#define PERF_MEM_TLB_SHIFT	26
 #define PERF_MEM_TLB_NA		0x01 /* not available */
 #define PERF_MEM_TLB_HIT	0x02 /* hit level */
 #define PERF_MEM_TLB_MISS	0x04 /* miss level */
@@ -677,7 +678,6 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_L2		0x10 /* L2 */
 #define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
 #define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
-#define PERF_MEM_TLB_SHIFT	26
 
 #define PERF_MEM_S(a, s) \
 	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
-- 
1.7.1

