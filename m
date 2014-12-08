Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaLHGxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:53:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHGxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:53:53 -0500
Date: Sun, 7 Dec 2014 22:53:42 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-09a6a1b07e5a579ef770d9728f5b158408c73c23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, ak@linux.intel.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, acme@redhat.com, ak@linux.intel.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1416275935-20971-1-git-send-email-andi@firstfloor.org>
References: <1416275935-20971-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  In branch stack mode use address history sorting
Git-Commit-ID: 09a6a1b07e5a579ef770d9728f5b158408c73c23
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

Commit-ID:  09a6a1b07e5a579ef770d9728f5b158408c73c23
Gitweb:     http://git.kernel.org/tip/09a6a1b07e5a579ef770d9728f5b158408c73c23
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 17 Nov 2014 17:58:54 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:31 -0300

perf report: In branch stack mode use address history sorting

Enable CCKEY_ADDRESS address history sorting with --branch-history.
This makes get_srcline display the source lines correctly, otherwise all
history entries for a function a hunked into one.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1416275935-20971-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fb272ff..3936760 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -761,6 +761,7 @@ repeat:
 		symbol_conf.cumulate_callchain = false;
 	}
 	if (branch_call_mode) {
+		callchain_param.key = CCKEY_ADDRESS;
 		callchain_param.branch_callstack = 1;
 		symbol_conf.use_callchain = true;
 		callchain_register_param(&callchain_param);
