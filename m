Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaDONHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaDONHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:07:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] perf tools: Fix double free in perf test 21 (code-reading.c)
Date: Tue, 15 Apr 2014 15:07:05 +0200
Message-Id: <1397567226-27516-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
References: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

perf_evlist__delete() deletes attached cpu and thread maps
but the test is still using them, so remove them from the
evlist before deleting it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/53465E3E.8070201@intel.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/tests/code-reading.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 653a8fe..bfb1869 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -504,6 +504,7 @@ static int do_test_code_reading(bool try_kcore)
 		if (ret < 0) {
 			if (!excl_kernel) {
 				excl_kernel = true;
+				perf_evlist__set_maps(evlist, NULL, NULL);
 				perf_evlist__delete(evlist);
 				evlist = NULL;
 				continue;
-- 
1.8.3.1

