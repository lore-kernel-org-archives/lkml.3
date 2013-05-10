Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3EJOWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57310 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756073Ab3EJOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Namhyung Kim" <namhyung.kim@lge.com>,
        "Namhyung Kim" <namhyung@kernel.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.573901@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [024/118] tracing: Fix off-by-one on allocating stat->pages
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 39e30cd1537937d3c00ef87e865324e981434e5b upstream.

The first page was allocated separately, so no need to start from 0.

Link: http://lkml.kernel.org/r/1364820385-32027-2-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -554,7 +554,7 @@ int ftrace_profile_pages_init(struct ftr
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;

