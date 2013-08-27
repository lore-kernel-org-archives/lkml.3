Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3H0BZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:25:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3H0BHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 17/74] tracing: Do not call kmem_cache_free() on allocation failure
Date: Mon, 26 Aug 2013 18:08:15 -0700
Message-Id: <20130827010428.073350135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit aaf6ac0f0871cb7fc0f28f3a00edf329bc7adc29 upstream.

There's no point calling it when _alloc() failed.

Link: http://lkml.kernel.org/r/1370585268-29169-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -114,7 +114,7 @@ static int __trace_define_field(struct l
 
 	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
 	if (!field)
-		goto err;
+		return -ENOMEM;
 
 	field->name = name;
 	field->type = type;
@@ -131,11 +131,6 @@ static int __trace_define_field(struct l
 	list_add(&field->link, head);
 
 	return 0;
-
-err:
-	kmem_cache_free(field_cachep, field);
-
-	return -ENOMEM;
 }
 
 int trace_define_field(struct ftrace_event_call *call, const char *type,


