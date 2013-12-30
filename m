Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3L3CfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:35:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3L3CfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:35:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,571,1384272000"; 
   d="scan'208";a="9348175"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: mingo@kernel.org, dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/8] perf tools: free aliases[j] in pmu.c if name_only is true.
Date: Mon, 30 Dec 2013 10:26:38 -0500
Message-Id: <f4427175be649aa6cdf477980051688c525b46ab.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:58,
	Serialize complete at 2013/12/30 10:27:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

