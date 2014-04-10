Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948AbaDJJDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:03:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:63368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934748AbaDJJDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:03:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,833,1389772800"; 
   d="scan'208";a="510781578"
Message-ID: <53465E3E.8070201@intel.com>
Date: Thu, 10 Apr 2014 12:02:54 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Fix double free in perf test 21 (code-reading.c)
References: <20140410082648.GB1141@krava.brq.redhat.com>
In-Reply-To: <20140410082648.GB1141@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_evlist__delete() deletes attached cpu and thread maps
but the test is still using them, so remove them from the
evlist before deleting it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
1.8.3.2


