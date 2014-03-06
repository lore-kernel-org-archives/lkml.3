Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaCFUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:31:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:16582 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751645AbaCFUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:31:54 -0500
Date: Thu, 6 Mar 2014 15:31:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 6/6] ftrace: Fix compilation warning about
 control_ops_free
Message-ID: <20140306153151.4f7ca9ca@gandalf.local.home>
In-Reply-To: <1393268401-24379-6-git-send-email-jslaby@suse.cz>
References: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
	<1393268401-24379-6-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 20:00:01 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> With CONFIG_DYNAMIC_FTRACE=n, I see a warning:
> kernel/trace/ftrace.c:240:13: warning: 'control_ops_free' defined but not used
>  static void control_ops_free(struct ftrace_ops *ops)
>              ^
> Add an ifdef block with CONFIG_DYNAMIC_FTRACE around that function as
> it is used solely from the dynamic function tracing functions.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ftrace.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5bd70e8b09b0..34b1de9390af 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -237,10 +237,12 @@ static int control_ops_alloc(struct ftrace_ops *ops)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE
>  static void control_ops_free(struct ftrace_ops *ops)
>  {
>  	free_percpu(ops->disabled);
>  }
> +#endif

I've pulled in all your patches up to this one.

But instead of adding another #ifdef CONFIG_DYNAMIC_FTRACE, please just
move the function into the block that it's used in.

Just resend this patch. The others are already in my 3.15 queue.

Thanks,

-- Steve

>  
>  static void update_global_ops(void)
>  {

