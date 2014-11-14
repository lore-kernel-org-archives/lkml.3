Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965314AbaKNNRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:17:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965167AbaKNNRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:17:35 -0500
Date: Fri, 14 Nov 2014 14:17:28 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 12/23 v4] tracing: Remove return values of most
 trace_seq_*() functions
Message-ID: <20141114131728.GC2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011411.992510720@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011411.992510720@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:12:56, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The trace_seq_printf() and friends are used to store strings into a buffer
> that can be passed around from function to function. If the trace_seq buffer
> fills up, it will not print any more. The return values were somewhat
> inconsistant and using trace_seq_has_overflowed() was a better way to know
> if the write to the trace_seq buffer succeeded or not.
> 
> Now that all users have removed reading the return value of the printf()
> type functions, they can safely return void and keep future users of them
> from reading the inconsistent values as well.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/trace_seq.h | 37 +++++++++------------
>  kernel/trace/trace_seq.c  | 84 +++++++++++++----------------------------------
>  2 files changed, 37 insertions(+), 84 deletions(-)

[...]

> diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> index b100994a17fe..e54c0a1fb3f0 100644
> --- a/kernel/trace/trace_seq.c
> +++ b/kernel/trace/trace_seq.c

[...]

> @@ -303,20 +269,17 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
>   * This is similar to trace_seq_putmem() except instead of just copying the
>   * raw memory into the buffer it writes its ASCII representation of it
>   * in hex characters.
> - *
> - * Returns how much it wrote to the buffer.
>   */
> -int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> +void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
>  			 unsigned int len)
>  {
>  	unsigned char hex[HEX_CHARS];
>  	const unsigned char *data = mem;
>  	unsigned int start_len;
>  	int i, j;
> -	int cnt = 0;
>  
>  	if (s->full)
> -		return 0;
> +		return;
>  
>  	while (len) {
>  		start_len = min(len, HEX_CHARS - 1);
> @@ -334,10 +297,7 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
>  		/* j increments twice per loop */
>  		len -= j / 2;
>  		hex[j++] = ' ';
> -
> -		cnt += trace_seq_putmem(s, hex, j);

trace_seq_putmem(s, hex, j); should stay ;-)

Best Regards,
Petr

>  	}
> -	return cnt;
>  }
>  EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
>  
> -- 
> 2.1.1
> 
> 
