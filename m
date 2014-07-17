Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaGQOr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:47:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:59210 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933100AbaGQOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:53 -0400
Message-Id: <20140717144752.839656210@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 5/7] tracing: Kill ftrace_event_call->files
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Kill-ftrace_event_call-files.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Remove ftrace_event_call->files. It has no users, and in fact even
the commit ae63b31e4d0e "tracing: Separate out trace events from
global variables" which added this member did not use it.

Link: http://lkml.kernel.org/p/20140715184827.GA20508@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f434d75e083b..06c6faa9e5cc 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -272,7 +272,6 @@ struct ftrace_event_call {
 	struct trace_event	event;
 	const char		*print_fmt;
 	struct event_filter	*filter;
-	struct list_head	*files;
 	void			*mod;
 	void			*data;
 	/*
-- 
2.0.1


