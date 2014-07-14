Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaGNSf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:35:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:35338 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752442AbaGNSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:35:51 -0400
Date: Mon, 14 Jul 2014 14:35:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] tracing: instance_rmdir() leaks
 ftrace_event_file->filter
Message-ID: <20140714143543.0dc505ea@gandalf.local.home>
In-Reply-To: <20140711190638.GA19517@redhat.com>
References: <20140711190622.GA19499@redhat.com>
	<20140711190638.GA19517@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 21:06:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> instance_rmdir() path destroys the event files but forgets to free
> file->filter. Change remove_event_file_dir() to free_event_filter().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index fdb2271..735608e 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -470,6 +470,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
>  
>  	list_del(&file->list);
>  	remove_subsystem(file->system);
> +	free_event_filter(file->filter);
>  	kmem_cache_free(file_cachep, file);
>  }
>  

Thanks, looks like this goes back to 3.11. I'll start testing this and
get it out for stable as well.

-- Steve
