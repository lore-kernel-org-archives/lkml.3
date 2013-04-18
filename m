Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967147Ab3DRJ2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:28:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab3DRJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 39/72] tracing: Fix double free when function profile init failed
Date: Thu, 18 Apr 2013 10:16:24 +0100
Message-Id: <1366276617-3553-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 83e03b3fe4daffdebbb42151d5410d730ae50bd1 upstream.

On the failure path, stat->start and stat->pages will refer same page.
So it'll attempt to free the same page again and get kernel panic.

Link: http://lkml.kernel.org/r/1364820385-32027-1-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 00ea125..7da46c7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -642,7 +642,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 
-- 
1.8.1.2

