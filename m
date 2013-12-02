Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3LBOgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:36:43 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:46607 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab3LBOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:36:41 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, adrian.hunter@intel.com
Subject: [PATCH] perf util: free cpu_map in perf_session__cpu_bitmap
Date: Mon,  2 Dec 2013 18:36:20 +0400
Message-Id: <1385994980-19821-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free previously allocated map.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/util/session.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4ce146bae552..ee717ee9ca3a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1606,6 +1606,7 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 		int cpu = map->map[i];
 
 		if (cpu >= MAX_NR_CPUS) {
+			cpu_map__delete(map);
 			pr_err("Requested CPU %d too large. "
 			       "Consider raising MAX_NR_CPUS\n", cpu);
 			return -1;
@@ -1613,6 +1614,7 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 
 		set_bit(cpu, cpu_bitmap);
 	}
+	cpu_map__delete(map);
 
 	return 0;
 }
-- 
1.8.3.2

