Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3L3HeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:34:03 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33876 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3L3Hd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:33:58 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v6 1/4] perf tools: generalize percent_color_snprintf()
Date: Mon, 30 Dec 2013 13:04:18 +0530
Message-Id: <1388388861-7931-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make percent_color_snprintf() handle negative values correctly.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/util/color.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 66e44a5..8cda46c 100644
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
1.8.5.2.227.g53f3478

