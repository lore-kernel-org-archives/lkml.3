Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaJATvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:51:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:47865 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaJATvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:51:31 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/8] perf tools: Fix build breakage on arm64 targets
Date: Wed,  1 Oct 2014 16:50:42 -0300
Message-Id: <1412193043-15493-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412193043-15493-1-git-send-email-acme@kernel.org>
References: <1412193043-15493-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

Attempting to build the perf tool for an arm64 target results in the
following failure:

  arch/arm64/util/unwind-libunwind.c: In function 'libunwind__arch_reg_id':
  arch/arm64/util/unwind-libunwind.c:77:3: error: implicit declaration of function 'pr_err'
     pr_err("unwind: invalid reg id %d\n", regnum);
     ^
  arch/arm64/util/unwind-libunwind.c:77:3: error: nested extern declaration of 'pr_err'

This is due to commit 84f5d36f4866 ("perf tools: Move pr_* debug macros
into debug object") moving the pr_* macros into a new header file, but
failing to update architectures other than x86.

This patch adds the missing include, and fixes the build again.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1412076432-22045-1-git-send-email-will.deacon@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm64/util/unwind-libunwind.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
index 436ee43859dc..a87afa91a99e 100644
--- a/tools/perf/arch/arm64/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
-- 
1.9.3

