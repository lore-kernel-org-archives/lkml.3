Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaJCF0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:26:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaJCF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:26:50 -0400
Date: Thu, 2 Oct 2014 22:26:33 -0700
From: tip-bot for Will Deacon <tipbot@zytor.com>
Message-ID: <tip-660d13296bbbe79635d1d9d700080b88061faffb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, will.deacon@arm.com,
        jean.pihet@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, will.deacon@arm.com,
        jean.pihet@linaro.org, tglx@linutronix.de
In-Reply-To: <1412076432-22045-1-git-send-email-will.deacon@arm.com>
References: <1412076432-22045-1-git-send-email-will.deacon@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build breakage on arm64 targets
Git-Commit-ID: 660d13296bbbe79635d1d9d700080b88061faffb
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

Commit-ID:  660d13296bbbe79635d1d9d700080b88061faffb
Gitweb:     http://git.kernel.org/tip/660d13296bbbe79635d1d9d700080b88061faffb
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Tue, 30 Sep 2014 12:27:12 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Oct 2014 14:44:17 -0300

perf tools: Fix build breakage on arm64 targets

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
index 436ee43..a87afa9 100644
--- a/tools/perf/arch/arm64/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
