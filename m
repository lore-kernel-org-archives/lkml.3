Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbaGYWDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:03:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaGYWDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:03:04 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Mark Salter <msalter@redhat.com>
Subject: [PATCH v2] perf: fix arm64 build error
Date: Fri, 25 Jul 2014 18:02:46 -0400
Message-Id: <1406325766-8085-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following build error on arm64:

  In file included from util/event.c:3:0:
  util/event.h:95:17: error: 'PERF_REGS_MAX' undeclared here (not in a function)
    u64 cache_regs[PERF_REGS_MAX];
                 ^

This patch adds a PERF_REGS_MAX definition for arm64.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/arch/arm64/include/perf_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
index e9441b9..1d3f39c 100644
--- a/tools/perf/arch/arm64/include/perf_regs.h
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -6,6 +6,8 @@
 #include <asm/perf_regs.h>
 
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM64_MAX) - 1)
+#define PERF_REGS_MAX	PERF_REG_ARM64_MAX
+
 #define PERF_REG_IP	PERF_REG_ARM64_PC
 #define PERF_REG_SP	PERF_REG_ARM64_SP
 
-- 
1.9.0

