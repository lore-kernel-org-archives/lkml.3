Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaCCTv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:51:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29255 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082AbaCCTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:51:27 -0500
Date: Mon, 3 Mar 2014 14:51:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Filipe Brandenburger <filbranden@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing: correctly expand len expressions from
 __dynamic_array macro
Message-ID: <20140303145110.0c09709c@gandalf.local.home>
In-Reply-To: <1393651938-16418-2-git-send-email-filbranden@google.com>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
	<1393651938-16418-2-git-send-email-filbranden@google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 21:32:16 -0800
Filipe Brandenburger <filbranden@google.com> wrote:

> This fixes expansion of the len argument in __dynamic_array macros.
> The previous code from commit 7d536cb3f would not fully evaluate the
> expression before multiplying its result by the size of the type.
> 
> This went unnoticed because the length stored in the high 16 bits of the
> offset (which is the one that was broken here) is only used by
> filter_pred_strloc which only acts on strings for which the size of the
> type is 1.
> 

Was this visible in any of the tracepoints? Should this be marked for
stable? It's been in the kernel for a long time (2009). Or is a new
tracepoint showing a problem?

-- Steve

> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
>  include/trace/ftrace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 1a8b28d..82e8d89 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -375,7 +375,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
>  #define __dynamic_array(type, item, len)				\
>  	__data_offsets->item = __data_size +				\
>  			       offsetof(typeof(*entry), __data);	\
> -	__data_offsets->item |= (len * sizeof(type)) << 16;		\
> +	__data_offsets->item |= ((len) * sizeof(type)) << 16;		\
>  	__data_size += (len) * sizeof(type);
>  
>  #undef __string

