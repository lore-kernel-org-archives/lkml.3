Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3KAV4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:56:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754711Ab3KAVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:04 -0400
Message-Id: <20131101215501.465091682@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>
Subject: [PATCH 6/8] tools lib traceevent: Check for spaces in character array
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0006-tools-lib-traceevent-Check-for-spaces-in-character-a.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently when using the raw format for fields, when looking at
a character array, to determine if it is a string or not, we make sure
all characters are "isprint()". If not, then we consider it a numeric
array, and print the hex numbers of the characters instead.

But it seems that '\n' fails the isprint() check! Add isspace() to
the check as well, such that if all characters pass isprint() or
isspace() it will assume the character array is a string.

Reported-by: Xenia Ragiadakou <burzalodowa@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.8.4.rc3


