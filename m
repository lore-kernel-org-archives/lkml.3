Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaGZTlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:41:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaGZTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.15 015/109] tracing: instance_rmdir() leaks ftrace_event_file->filter
Date: Sat, 26 Jul 2014 12:01:37 -0700
Message-Id: <20140726190224.288507143@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 2448e3493cb3874baa90725c87869455ebf11cd2 upstream.

instance_rmdir() path destroys the event files but forgets to free
file->filter. Change remove_event_file_dir() to free_event_filter().

Link: http://lkml.kernel.org/p/20140711190638.GA19517@redhat.com

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Fixes: f6a84bdc75b5 "tracing: Introduce remove_event_file_dir()"
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -470,6 +470,7 @@ static void remove_event_file_dir(struct
 
 	list_del(&file->list);
 	remove_subsystem(file->system);
+	free_event_filter(file->filter);
 	kmem_cache_free(file_cachep, file);
 }
 


