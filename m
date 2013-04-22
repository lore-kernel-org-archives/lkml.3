Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3DVOhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:37:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab3DVOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Namhyung Kim" <namhyung.kim@lge.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.669509943@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [33/75] tracing: Fix double free when function profile init failed
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -572,7 +572,6 @@ int ftrace_profile_pages_init(struct ftr
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 

