Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaHVVFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:05:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9599 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477AbaHVVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:05:45 -0400
Date: Fri, 22 Aug 2014 17:05:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Javi Merino" <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: link trace-record in ctracecmd.so
Message-ID: <20140822170535.52f12438@gandalf.local.home>
In-Reply-To: <1408116698-23033-1-git-send-email-javi.merino@arm.com>
References: <1408116698-23033-1-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 16:31:38 +0100
"Javi Merino" <javi.merino@arm.com> wrote:

> Commit b1e9220819eb (trace-cmd: Report stats for all instances) moved
> tracecmd_stat_cpu() from trace-recorder.c to trace-record.c.  This
> makes import ctracecmd fail in tracecmd.py:
> 
> $ python tracecmd.py
> Traceback (most recent call last):
>   File "tracecmd.py", line 22, in <module>
>     from ctracecmd import *
> ImportError: ctracecmd.so: undefined symbol: tracecmd_stat_cpu
> 
> Link trace-record in ctracecmd.so to add back the required symbol.
> 

I just applied this. May push this out next week. I have other changes
I'm adding and need to get them finished before I push it out. It may
not go out until September though.

-- Steve

> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index cbe0eb9..308d7f8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -317,8 +317,9 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
>  
>  PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
>  TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
> -			trace-output.o trace-recorder.o trace-restore.o trace-usage.o \
> -			trace-blk-hack.o kbuffer-parse.o event-plugin.o
> +			trace-output.o trace-record.o trace-recorder.o \
> +			trace-restore.o trace-usage.o trace-blk-hack.o \
> +			kbuffer-parse.o event-plugin.o
>  
>  PLUGIN_OBJS =
>  PLUGIN_OBJS += plugin_jbd2.o

