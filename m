Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaANQoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:44:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaANQl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:57 -0500
Date: Tue, 14 Jan 2014 08:41:43 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-f77c6e9c8f9c444cd44423df0c2708e86a06a696@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1388388861-7931-2-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Generalize percent_color_snprintf()
Git-Commit-ID: f77c6e9c8f9c444cd44423df0c2708e86a06a696
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f77c6e9c8f9c444cd44423df0c2708e86a06a696
Gitweb:     http://git.kernel.org/tip/f77c6e9c8f9c444cd44423df0c2708e86a06a696
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 30 Dec 2013 13:04:18 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:46:39 -0300

perf tools: Generalize percent_color_snprintf()

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
