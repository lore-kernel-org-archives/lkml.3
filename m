Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab3LKEtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:49:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3LKEtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 23:49:35 -0500
X-IronPort-AV: E=Sophos;i="4.93,869,1378828800"; 
   d="scan'208";a="9234829"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] perf tools: Drop strdup in get_filename_for_perf_kvm().
Date: Wed, 11 Dec 2013 12:47:37 -0500
Message-Id: <1122029b8eed159852fe6669827b6dff12f81698.1386783950.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 12:49:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 12:49:12,
	Serialize complete at 2013/12/11 12:49:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we need a const char * as a result of get_filename_for_perf_kvm(),
There is no need to use strdup() for the return value.

This patch drop the strdup() to save memory in get_filename_for_perf_kvm().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-kvm.c | 8 +-------
 tools/perf/util/util.c   | 6 +++---
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index c6fa3cb..03bd946 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1712,15 +1712,9 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;
 
-	if (!file_name) {
+	if (!file_name)
 		file_name = get_filename_for_perf_kvm();
 
-		if (!file_name) {
-			pr_err("Failed to allocate memory for filename\n");
-			return -ENOMEM;
-		}
-	}
-
 	if (!strncmp(argv[0], "rec", 3))
 		return __cmd_record(file_name, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 4a57609..e9cb136 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -488,11 +488,11 @@ const char *get_filename_for_perf_kvm(void)
 	const char *filename;
 
 	if (perf_host && !perf_guest)
-		filename = strdup("perf.data.host");
+		filename = "perf.data.host";
 	else if (!perf_host && perf_guest)
-		filename = strdup("perf.data.guest");
+		filename = "perf.data.guest";
 	else
-		filename = strdup("perf.data.kvm");
+		filename = "perf.data.kvm";
 
 	return filename;
 }
-- 
1.8.2.1

