Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaAIJXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:23:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbaAIJWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:22:12 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384272000"; 
   d="scan'208";a="9395605"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/7] perf tools: free aliases[j] in pmu.c if name_only is true.
Date: Thu, 9 Jan 2014 17:19:52 -0500
Message-Id: <73307f566b55e402a7e955d43c4cf80a42fb3014.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:04,
	Serialize complete at 2014/01/09 17:21:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As aliases is a 2-D array malloced in function print_pmu_events(),
we should free it after printf. But we just did it when (!name_only).

This patch fix the leak error in print_pmu_events() when name_only
is true.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 331dc2c..169c480 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -752,6 +752,7 @@ unsigned int print_pmu_events(const char *event_glob, bool name_only)
 	for (j = 0; j < len; j++) {
 		if (name_only) {
 			printf("%s ", aliases[j]);
+			zfree(&aliases[j]);
 			count++;
 			continue;
 		}
-- 
1.8.2.1

