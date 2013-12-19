Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3LSJ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:56:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24838 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3LSJ4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:56:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384272000"; 
   d="scan'208";a="9291077"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@ghostprotocols.net
Cc: mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().
Date: Thu, 19 Dec 2013 17:54:52 -0500
Message-Id: <b638d346eb9689a9fa5ee39a99f2c1753573284f.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:17,
	Serialize complete at 2013/12/19 17:56:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a TODO in thread__find_addr_map() and add support of PERF_RECORD_MISC_GUEST_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6e36bbb..598b73e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -679,15 +679,10 @@ void thread__find_addr_map(struct thread *thread,
 		al->level = 'g';
 		mg = &machine->kmaps;
 		load_map = true;
+	} else if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest) {
+		al->level = 'u';
 	} else {
-		/*
-		 * 'u' means guest os user space.
-		 * TODO: We don't support guest user space. Might support late.
-		 */
-		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
-			al->level = 'u';
-		else
-			al->level = 'H';
+		al->level = 'H';
 		al->map = NULL;
 
 		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
-- 
1.8.2.1

