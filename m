Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaGNTGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:06:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:35379 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754964AbaGNTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:06:26 -0400
Date: Mon, 14 Jul 2014 15:06:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] tracing: kill ftrace_event_call->files
Message-ID: <20140714150624.32f49b7d@gandalf.local.home>
In-Reply-To: <20140711190653.GA19542@redhat.com>
References: <20140711190622.GA19499@redhat.com>
	<20140711190653.GA19542@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 21:06:53 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Remove ftrace_event_call->files. It has no users, and in fact even
> the commit ae63b31e4d0e "tracing: Separate out trace events from
> global variables" which added this member did not use it.
> 

Ouch!

OK, I swear I used it before I committed the change. I just stopped
using it before I committed the change as well.

-- Steve

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/ftrace_event.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index f434d75..06c6faa 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -272,7 +272,6 @@ struct ftrace_event_call {
>  	struct trace_event	event;
>  	const char		*print_fmt;
>  	struct event_filter	*filter;
> -	struct list_head	*files;
>  	void			*mod;
>  	void			*data;
>  	/*

