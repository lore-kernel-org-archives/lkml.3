Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3LTHz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3LTHy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:54:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296742"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/7] perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().
Date: Fri, 20 Dec 2013 15:52:56 -0500
Message-Id: <3dd652201171a19c910b500984c7c3590e77603b.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:23,
	Serialize complete at 2013/12/20 15:54:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a TODO in thread__find_addr_map() and add support of PERF_RECORD_MISC_GUEST_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6948768..44992ed 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -658,15 +658,10 @@ void thread__find_addr_map(struct thread *thread,
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

