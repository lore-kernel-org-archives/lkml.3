Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161899Ab3DEOtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:49:39 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52007 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161785Ab3DEOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:49:38 -0400
Date: Fri, 5 Apr 2013 16:49:41 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, jolsa@redhat.com
Subject: [PATCH] perf: fix comments in PERF_MEM_LVL bitmask
Message-ID: <20130405144941.GA30503@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This small patch fixes a mistake in the comments
for the PERF_MEM_LVL_* events. The L2, L3 bits simply
represent cache levels, not hits or misses. That is
encoded in PERF_MEM_LVL_MISS/PERF_MEM_LVL_HIT.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 964a450..fb104e5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -645,8 +645,8 @@ union perf_mem_data_src {
 #define PERF_MEM_LVL_MISS	0x04  /* miss level  */
 #define PERF_MEM_LVL_L1		0x08  /* L1 */
 #define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
-#define PERF_MEM_LVL_L2		0x20  /* L2 hit */
-#define PERF_MEM_LVL_L3		0x40  /* L3 hit */
+#define PERF_MEM_LVL_L2		0x20  /* L2 */
+#define PERF_MEM_LVL_L3		0x40  /* L3 */
 #define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
 #define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
 #define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
