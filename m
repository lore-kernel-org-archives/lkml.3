Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaCCU7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:59:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50496 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754119AbaCCU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:59:45 -0500
Date: Mon, 3 Mar 2014 15:59:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing: introduce a trace_data_offset struct to
 store array size
Message-ID: <20140303155942.404778ea@gandalf.local.home>
In-Reply-To: <20140303154826.570c658f@gandalf.local.home>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
	<1393651938-16418-4-git-send-email-filbranden@google.com>
	<20140303154826.570c658f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 15:48:26 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> without patch:
> 
>          pst2pdf-3506  [000]   120.700910: sched_process_exec: filename=/usr/bin/pst2pdf pid=3506 old_pid=3506
> 
> 
> With patch:
> 
>          pstopnm-4432  [001]  1490.246765: sched_process_exec: filename= pid=4432 old_pid=4432

Now, after applying the following patch to your patch, I was able to
get this again:

         pst2pdf-3512  [000]    99.693582: sched_process_exec: filename=/usr/bin/pst2pdf pid=3512 old_pid=3512


-- Steve

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 67e4122..2c6d1b0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -124,8 +124,13 @@ struct trace_event {
 };
 
 struct trace_array_offset {
+#ifdef __BIG_ENDIAN
+	u16			length;
+	u16			offset;
+#else
 	u16			offset;
 	u16			length;
+#endif
 };
 
 extern int register_ftrace_event(struct trace_event *event);
