Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaAWRDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:03:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaAWRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:03:51 -0500
Date: Thu, 23 Jan 2014 09:03:26 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-3415d8b851307c75a1e8aa16030db9172306df78@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1390217980-22424-2-git-send-email-stfomichev@yandex-team.ru>
References: <1390217980-22424-2-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Fix wrong SVG height
Git-Commit-ID: 3415d8b851307c75a1e8aa16030db9172306df78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:03:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3415d8b851307c75a1e8aa16030db9172306df78
Gitweb:     http://git.kernel.org/tip/3415d8b851307c75a1e8aa16030db9172306df78
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Mon, 20 Jan 2014 15:39:38 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:08 -0300

perf timechart: Fix wrong SVG height

If we call perf timechart with -p 0 arguments, it means we don't want
any tasks related data. It works, but space for tasks data is reserved
in the generated SVG. Remove this unused empty space via passing 0 as
count to the open_svg.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1390217980-22424-2-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 652af0b..25526d6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1045,6 +1045,9 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 		thresh /= 10;
 	} while (!process_filter && thresh && count < tchart->proc_num);
 
+	if (!tchart->proc_num)
+		count = 0;
+
 	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
 
 	svg_time_grid();
