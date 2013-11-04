Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3KDUXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3KDUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:25 -0500
Date: Mon, 4 Nov 2013 12:23:10 -0800
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-5efb9fbd5f1bfe4435bd0a3ea5f0e187875509c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, burzalodowa@gmail.com, namhyung@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, burzalodowa@gmail.com, namhyung@kernel.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <20131101215501.465091682@goodmis.org>
References: <20131101215501.465091682@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Check for spaces in character array
Git-Commit-ID: 5efb9fbd5f1bfe4435bd0a3ea5f0e187875509c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:23:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5efb9fbd5f1bfe4435bd0a3ea5f0e187875509c2
Gitweb:     http://git.kernel.org/tip/5efb9fbd5f1bfe4435bd0a3ea5f0e187875509c2
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Fri, 1 Nov 2013 17:53:58 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:35:54 -0300

tools lib traceevent: Check for spaces in character array

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
index e1c743c..85cbbdd 100644
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
