Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaATLkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:40:25 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:47673 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbaATLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:40:22 -0500
X-Yandex-Uniq: 5c0cc24e-205e-45a4-9f9b-c3dcfb728271
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perf util: free cpu_map in perf_session__cpu_bitmap
Date: Mon, 20 Jan 2014 15:39:39 +0400
Message-Id: <1390217980-22424-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
References: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/util/session.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7acc03e8f3b2..03815af30b16 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1600,6 +1600,7 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 		int cpu = map->map[i];
 
 		if (cpu >= MAX_NR_CPUS) {
+			cpu_map__delete(map);
 			pr_err("Requested CPU %d too large. "
 			       "Consider raising MAX_NR_CPUS\n", cpu);
 			return -1;
@@ -1607,6 +1608,7 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 
 		set_bit(cpu, cpu_bitmap);
 	}
+	cpu_map__delete(map);
 
 	return 0;
 }
-- 
1.8.3.2

