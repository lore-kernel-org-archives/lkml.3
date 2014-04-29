Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaD2OMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:12:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:65445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701AbaD2OMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,951,1389772800"; 
   d="scan'208";a="522994938"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] tools/perf: remove yet another strtoull()
Date: Tue, 29 Apr 2014 17:12:07 +0300
Message-Id: <1398780727-8776-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/util.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9f66549..77360e1 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -203,17 +203,6 @@ size_t hex_width(u64 v)
 	return n;
 }
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
 /*
  * While we find nice hex chars, build a long_val.
  * Return number of chars processed.
@@ -221,17 +210,8 @@ static int hex(char ch)
 int hex2u64(const char *ptr, u64 *long_val)
 {
 	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
 
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
+	*long_val = strtoull(ptr, &p, 16);
 
 	return p - ptr;
 }
-- 
1.9.2

