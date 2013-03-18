Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3CRVUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:20:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab3CRVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Andrew Vagin <avagin@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [ 16/40] Revert duplicated perf commit.
Date: Mon, 18 Mar 2013 14:10:54 -0700
Message-Id: <20130318211017.418070837@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 2431496fbdd142ccc83138d94f3f510a36ce9270 as it was
applied incorrectly twice.

Thanks to Jiri for pointing this out.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
 


