Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3CYBPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33785 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab3CYBPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:03 -0400
Message-Id: <20130325010526.138440968@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 018/104] perf: Revert duplicated commit 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 923415295307845e614589c1cce62abedd4d1731
'perf: Fix parsing of __print_flags() in TP_printk()'.  The same
change was already included in 3.2 as commit
d06c27b22aa66e48e32f03f9387328a9af9b0625 but in 3.2.1 this change
was wrongly applied to similar code in a different function.

Thanks to Jiri for pointing this out in 3.0.y.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-parse.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1582,8 +1582,6 @@ process_symbols(struct event *event, str
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
-	while (type == EVENT_OP)
-		type = process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 


