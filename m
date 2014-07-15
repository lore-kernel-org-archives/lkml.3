Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbaGOSuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843AbaGOSuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:50:15 -0400
Date: Tue, 15 Jul 2014 20:48:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] tracing: kill ftrace_event_call->files
Message-ID: <20140715184827.GA20508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715184753.GA20470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ftrace_event_call->files. It has no users, and in fact even
the commit ae63b31e4d0e "tracing: Separate out trace events from
global variables" which added this member did not use it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ftrace_event.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f434d75..06c6faa 100644
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
1.5.5.1

