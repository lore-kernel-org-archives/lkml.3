Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaFEOkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:40:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaFEOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:40:18 -0400
Date: Thu, 5 Jun 2014 07:39:25 -0700
From: tip-bot for Anshuman Khandual <tipbot@zytor.com>
Message-ID: <tip-bac52139f0b7ab31330e98fd87fc5a2664951050@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, acme@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, acme@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1400743210-32289-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400743210-32289-1-git-send-email-khandual@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add new conditional branch filter '
 PERF_SAMPLE_BRANCH_COND'
Git-Commit-ID: bac52139f0b7ab31330e98fd87fc5a2664951050
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

Commit-ID:  bac52139f0b7ab31330e98fd87fc5a2664951050
Gitweb:     http://git.kernel.org/tip/bac52139f0b7ab31330e98fd87fc5a2664951050
Author:     Anshuman Khandual <khandual@linux.vnet.ibm.com>
AuthorDate: Thu, 22 May 2014 12:50:07 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:15 +0200

perf: Add new conditional branch filter 'PERF_SAMPLE_BRANCH_COND'

This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
will extend the existing perf ABI. This will filter branches which are
conditional. Various architectures can provide this functionality either
with HW filtering support (if present) or with SW filtering of captured
branch instructions.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mpe@ellerman.id.au
Cc: benh@kernel.crashing.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1400743210-32289-1-git-send-email-khandual@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e3fc8f0..d9cd853 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -163,8 +163,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
