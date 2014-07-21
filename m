Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaGUVCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:02:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53858 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751336AbaGUVCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:02:02 -0400
Date: Mon, 21 Jul 2014 17:01:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>, Darren Hart <darren@dvhart.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] trace-cmd: add trace-record.o to the python shared lib
Message-ID: <20140721170153.42a0d5d2@gandalf.local.home>
In-Reply-To: <1405975844-2361-1-git-send-email-jbacik@fb.com>
References: <1405975844-2361-1-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'd my python gurus.

Acks?

-- Steve


On Mon, 21 Jul 2014 16:50:44 -0400
Josef Bacik <jbacik@fb.com> wrote:

> When trying to use the python library it was giving me an error about not being
> able to resolve tracecmd_stat_cpu.  This is because we weren't linking
> trace-record.o to ctracecmd.so.  Fix this in the makefile and now I can import
> trace-cmd in python properly.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index df5ec72..f6c2875 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -321,7 +321,7 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
>  PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
>  TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
>  			trace-output.o trace-recorder.o trace-restore.o trace-usage.o \
> -			trace-blk-hack.o kbuffer-parse.o event-plugin.o
> +			trace-blk-hack.o kbuffer-parse.o event-plugin.o trace-record.o
>  
>  PLUGIN_OBJS =
>  PLUGIN_OBJS += plugin_jbd2.o

