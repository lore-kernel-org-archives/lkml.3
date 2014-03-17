Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaCQW0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:26:41 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:46419 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaCQWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:59 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] tools lib traceevent: field_is_long() includes unsigned long
Date: Mon, 17 Mar 2014 18:26:37 -0400
Message-Id: <1395095198-20034-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note in the comment that field_is_long() also checks for "unsigned
long" and "unsigned long long" in addition to "long long".

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7a8d9ae..567d9ba 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1233,7 +1233,7 @@ static int field_is_dynamic(struct format_field *field)
 
 static int field_is_long(struct format_field *field)
 {
-	/* includes long long */
+	/* includes long long, unsigned long, and unsigned long long */
 	if (strstr(field->type, "long"))
 		return 1;
 
-- 
1.9.0.431.g014438b

