Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3LSHB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:01:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47179 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3LSHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:00:16 -0500
X-AuditID: 9c930179-b7bedae000000f15-77-52b2997d8d1e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/6] perf tools: Get rid of a duplicate va_end()
Date: Thu, 19 Dec 2013 16:00:08 +0900
Message-Id: <1387436411-20160-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The va_end() in _eprintf() should be removed since the caller also
invokes va_end().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/debug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 8640a9121e72..299b55586502 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -25,7 +25,6 @@ static int _eprintf(int level, const char *fmt, va_list args)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
-		va_end(args);
 	}
 
 	return ret;
-- 
1.7.11.7

