Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaI3L1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:27:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63705 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbaI3L1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:27:45 -0400
From: Will Deacon <will.deacon@arm.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v2] perf tools: fix build breakage on arm64 targets
Date: Tue, 30 Sep 2014 12:27:12 +0100
Message-Id: <1412076432-22045-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

v1->v2: Rebased onto tip tree, which removed the need for the arch/arm/ hunks.

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
2.1.0

