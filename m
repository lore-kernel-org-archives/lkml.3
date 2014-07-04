Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbaGDLn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:43:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:3520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbaGDLnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:43:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,600,1400050800"; 
   d="scan'208";a="568383993"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] perf tools: substitute yet another strtoull()
Date: Fri,  4 Jul 2014 14:43:49 +0300
Message-Id: <1404474229-15272-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of home grown function let's use what library provides us.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 tools/perf/util/util.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index e4132ae..861e16e 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -206,35 +206,15 @@ size_t hex_width(u64 v)
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
  */
 int hex2u64(const char *ptr, u64 *long_val)
 {
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
+	char *p;
 
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
2.0.1

