Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaHDQSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:38677 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHDQSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:06 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/33] perf tools: Fix arm64 build error
Date: Mon,  4 Aug 2014 13:17:12 -0300
Message-Id: <1407169064-25625-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

I'm seeing the following build error on arm64:

  In file included from util/event.c:3:0:
  util/event.h:95:17: error: 'PERF_REGS_MAX' undeclared here (not in a function)
    u64 cache_regs[PERF_REGS_MAX];
                 ^

This patch adds a PERF_REGS_MAX definition for arm64.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406325766-8085-1-git-send-email-msalter@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm64/include/perf_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
index e9441b9e2a30..1d3f39c3aa56 100644
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
1.9.3

