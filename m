Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaANODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:03:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33331 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaANODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:03:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/38] perf tools: Generalize percent_color_snprintf()
Date: Mon, 13 Jan 2014 17:47:34 -0300
Message-Id: <1389646059-24881-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Make percent_color_snprintf() handle negative values correctly.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388388861-7931-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/color.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 66e44a5019d5..8cda46c43e74 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include "cache.h"
 #include "color.h"
+#include <math.h>
 
 int perf_use_color_default = -1;
 
@@ -298,10 +299,10 @@ const char *get_percent_color(double percent)
 	 * entries in green - and keep the low overhead places
 	 * normal:
 	 */
-	if (percent >= MIN_RED)
+	if (fabs(percent) >= MIN_RED)
 		color = PERF_COLOR_RED;
 	else {
-		if (percent > MIN_GREEN)
+		if (fabs(percent) > MIN_GREEN)
 			color = PERF_COLOR_GREEN;
 	}
 	return color;
-- 
1.8.1.4

