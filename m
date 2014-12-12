Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbaLLISN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:18:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325AbaLLISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:18:10 -0500
Date: Fri, 12 Dec 2014 00:17:50 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-f70b4e39de4ef25aade966c0dfc69cfb97091be9@git.kernel.org>
Cc: acme@redhat.com, jolsa@redhat.com, mingo@redhat.com, mingo@kernel.org,
        hpa@zytor.com, namhyung@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, paulus@samba.org, kan.liang@intel.com,
        eranian@google.com
Reply-To: namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, kan.liang@intel.com,
        paulus@samba.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, jolsa@redhat.com, mingo@redhat.com, mingo@kernel.org,
        hpa@zytor.com
In-Reply-To: <1417532814-26208-2-git-send-email-kan.liang@intel.com>
References: <1417532814-26208-2-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Fixup parameter handling error message
Git-Commit-ID: f70b4e39de4ef25aade966c0dfc69cfb97091be9
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

Commit-ID:  f70b4e39de4ef25aade966c0dfc69cfb97091be9
Gitweb:     http://git.kernel.org/tip/f70b4e39de4ef25aade966c0dfc69cfb97091be9
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 2 Dec 2014 10:06:52 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 10:06:11 -0300

perf callchain: Fixup parameter handling error message

Fix up parse_callchain_record_opt error message for 'fp', in the past using '-g
fp' was a valid alternative to '--call-graph fp', which is not the case since:

  commit 09b0fd45ff63413df94cbd832a765076b201edbb
  Author: Jiri Olsa <jolsa@redhat.com>
  Date:   Sat Oct 26 16:25:33 2013 +0200

  perf record: Split -g and --call-graph

I.e. -g means "use the configured unwind data collection method" which has as
default 'fp', while --call-graph requires passing the method to use.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1417532814-26208-2-git-send-email-kan.liang@intel.com
[ split this from a larger patch related to LBR based unwinding ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index cf524a3..64b377e 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -77,7 +77,7 @@ int parse_callchain_record_opt(const char *arg)
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
-				       "needed for -g fp\n");
+				       "needed for --call-graph fp\n");
 			break;
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
