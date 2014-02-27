Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaB0QFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:05:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:31362 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751063AbaB0QFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:05:40 -0500
Date: Thu, 27 Feb 2014 11:05:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        <stable@vger.kernel.org>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFA][PATCH 2/5] ftrace/x86: One more missing sync after fixup
 of function modification failure
Message-ID: <20140227110538.2b62c197@gandalf.local.home>
In-Reply-To: <20140227154923.103932155@goodmis.org>
References: <20140227154616.703252665@goodmis.org>
	<20140227154923.103932155@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter, I forgot to Cc you on this one. As you are the one I'm
looking for an Ack from.

-- Steve


On Thu, 27 Feb 2014 10:46:18 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> [Request for Ack]
> 
> From: Petr Mladek <pmladek@suse.cz>
> 
> If a failure occurs while modifying ftrace function, it bails out and will
> remove the tracepoints to be back to what the code originally was.
> 
> There is missing the final sync run across the CPUs after the fix up is done
> and before the ftrace int3 handler flag is reset.
> 
> Link: http://lkml.kernel.org/r/1393258342-29978-2-git-send-email-pmladek@suse.cz
> 
> Fixes: 8a4d0a687a5 "ftrace: Use breakpoint method to update ftrace caller"
> Cc: stable@vger.kernel.org # 3.5+
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 6b566c8..69885e2 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -660,8 +660,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
>  		ret = -EPERM;
>  		goto out;
>  	}
> -	run_sync();
>   out:
> +	run_sync();
>  	return ret;
>  
>   fail_update:

