Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3KDR71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:59:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/29] tools lib traceevent: Check for spaces in character array
Date: Mon,  4 Nov 2013 14:59:05 -0300
Message-Id: <1383587947-17419-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently when using the raw format for fields, when looking at a
character array, to determine if it is a string or not, we make sure all
characters are "isprint()". If not, then we consider it a numeric array,
and print the hex numbers of the characters instead.

But it seems that '\n' fails the isprint() check! Add isspace() to the
check as well, such that if all characters pass isprint() or isspace()
it will assume the character array is a string.

Reported-by: Xenia Ragiadakou <burzalodowa@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>
Link: http://lkml.kernel.org/r/20131101215501.465091682@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e1c743c52834..85cbbddb6880 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3981,7 +3981,7 @@ static int is_printable_array(char *p, unsigned int len)
 	unsigned int i;
 
 	for (i = 0; i < len && p[i]; i++)
-		if (!isprint(p[i]))
+		if (!isprint(p[i]) && !isspace(p[i]))
 		    return 0;
 	return 1;
 }
-- 
1.8.1.4

