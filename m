Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaHMFNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:13:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHMFNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:13:06 -0400
Date: Tue, 12 Aug 2014 22:12:31 -0700
From: tip-bot for Mark Salter <tipbot@zytor.com>
Message-ID: <tip-7d885749b6de2c9a1168d566e2380207b9177108@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, msalter@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, msalter@redhat.com, tglx@linutronix.de
In-Reply-To: <1406325766-8085-1-git-send-email-msalter@redhat.com>
References: <1406325766-8085-1-git-send-email-msalter@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix arm64 build error
Git-Commit-ID: 7d885749b6de2c9a1168d566e2380207b9177108
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d885749b6de2c9a1168d566e2380207b9177108
Gitweb:     http://git.kernel.org/tip/7d885749b6de2c9a1168d566e2380207b9177108
Author:     Mark Salter <msalter@redhat.com>
AuthorDate: Fri, 25 Jul 2014 18:02:46 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jul 2014 12:37:55 -0300

perf tools: Fix arm64 build error

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
 
