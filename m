Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaATLkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:40:18 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:47674 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbaATLkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:40:12 -0500
X-Yandex-Uniq: 588f20b5-21ed-4baf-bcd7-198801b1d2d1
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf timechart: fix wrong SVG height
Date: Mon, 20 Jan 2014 15:39:38 +0400
Message-Id: <1390217980-22424-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
References: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we call perf timechart with -p 0 arguments, it means we don't
want any tasks related data. It works, but space for tasks data is
reserved in the generated SVG. Remove this unused empty space via
passing 0 as count to the open_svg.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 652af0b66a62..25526d6eae59 100644
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
-- 
1.8.3.2

