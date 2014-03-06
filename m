Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaCFReL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:34:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:3998 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbaCFReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:34:09 -0500
Date: Thu, 6 Mar 2014 12:34:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: module: Maintain a valid user count
Message-ID: <20140306123403.5f29c071@gandalf.local.home>
In-Reply-To: <1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com>
References: <20140303133330.7031b2cb@gandalf.local.home>
	<1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

You want to push this to Linus?

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


On Tue,  4 Mar 2014 10:09:39 +0100
Romain Izard <romain.izard.pro@gmail.com> wrote:

> The replacement of the 'count' variable by two variables 'incs' and
> 'decs' to resolve some race conditions during module unloading was done
> in parallel with some cleanup in the trace subsystem, and was integrated
> as a merge.
> 
> Unfortunately, the formula for this replacement was wrong in the tracing
> code, and the refcount in the traces was not usable as a result.
> 
> Use 'count = incs - decs' to compute the user count.
> 
> Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
> ---
>  include/trace/events/module.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index 161932737416..ca298c7157ae 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
>  
>  	TP_fast_assign(
>  		__entry->ip	= ip;
> -		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
> +		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
>  		__assign_str(name, mod->name);
>  	),
>  

