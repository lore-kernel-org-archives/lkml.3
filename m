Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaF0O6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:58:10 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39882 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaF0O6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:58:07 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, Sneha Priya <sneha.cse@hotmail.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/3] ARM: perf: Check that current->mm is alive before getting user callchain
Date: Fri, 27 Jun 2014 16:57:45 +0200
Message-Id: <1403881067-22690-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
References: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An event may occur when an mm is already released.

As per commit 20afc60f892d285fde179ead4b24e6a7938c2f1b
 'x86, perf: Check that current->mm is alive before getting user callchain'

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/perf_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 4238bcb..6493c4c 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -590,6 +590,10 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	}
 
 	perf_callchain_store(entry, regs->ARM_pc);
+
+	if (!current->mm)
+		return;
+
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
-- 
1.8.1.2

