Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaANQli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaANQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:32 -0500
Date: Tue, 14 Jan 2014 08:41:15 -0800
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-d11416e76b3e2f60ed6cfa7c532d3b6777f66527@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, will.deacon@arm.com, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1387212194-8028-1-git-send-email-jean.pihet@linaro.org>
References: <1387212194-8028-1-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use the DWARF unwind info only if loaded
Git-Commit-ID: d11416e76b3e2f60ed6cfa7c532d3b6777f66527
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11416e76b3e2f60ed6cfa7c532d3b6777f66527
Gitweb:     http://git.kernel.org/tip/d11416e76b3e2f60ed6cfa7c532d3b6777f66527
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Mon, 16 Dec 2013 17:43:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:26 -0300

perf tools: Use the DWARF unwind info only if loaded

Use the info only if it has been found in the .debug_frame section of
the ELF binary.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/1387212194-8028-1-git-send-email-jean.pihet@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/unwind.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 0efd539..416f22b 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -340,10 +340,10 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
 		memset(&di, 0, sizeof(di));
-		dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
-				       map->start, map->end);
-		return dwarf_search_unwind_table(as, ip, &di, pi,
-						 need_unwind_info, arg);
+		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
+					   map->start, map->end))
+			return dwarf_search_unwind_table(as, ip, &di, pi,
+							 need_unwind_info, arg);
 	}
 #endif
 
