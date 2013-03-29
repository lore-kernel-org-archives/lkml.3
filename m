Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3C2Tae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:30:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47991 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab3C2Taa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:30:30 -0400
Date: Fri, 29 Mar 2013 12:29:50 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: fix bug in isupper() and islower()
Message-ID: <20130329192950.GA9312@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032919-2398-0000-0000-000012CCD111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd349681226bf7b27c9d0f72b0f3941b5aa94f78 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 29 Mar 2013 12:14:43 -0700
Subject: [PATCH] perf: fix bug in isupper() and islower()

One of the reasons 'perf test' is failing on Power appears to be due to
a bug in isupper().

isupper(c) and islower(c) should be checking 'c' against the mask 0x20.
Instead they are checking sane_ctype[c] which causes isupper() to be true
for lower case letters.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/util.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 09b4c26..2795ef6 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -219,8 +219,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
-#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
+#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
-- 
1.7.1

