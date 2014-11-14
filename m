Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845AbaKNPbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:31:08 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53160 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720AbaKNPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:31:04 -0500
Message-ID: <54662031.2060603@hitachi.com>
Date: Sat, 15 Nov 2014 00:30:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC][PATCH 09/23 v4] tracing/probes: Do not use return value
 of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org> <20141114011411.530216306@goodmis.org>
In-Reply-To: <20141114011411.530216306@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/14 10:12), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The functions trace_seq_printf() and friends will soon not have a return
> value and will only be a void function. Use trace_seq_has_overflowed()
> instead to know if the trace_seq operations succeeded or not.
> 

OK, Looks good to me.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_probe.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index d4b9fc22cd27..b983b2fd2ca1 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -40,7 +40,8 @@ const char *reserved_field_names[] = {
>  int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
>  				void *data, void *ent)			\
>  {									\
> -	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
> +	trace_seq_printf(s, " %s=" fmt, name, *(type *)data);		\
> +	return !trace_seq_has_overflowed(s);				\
>  }									\
>  const char PRINT_TYPE_FMT_NAME(type)[] = fmt;				\
>  NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
> @@ -61,10 +62,11 @@ int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, const char *name,
>  	int len = *(u32 *)data >> 16;
>  
>  	if (!len)
> -		return trace_seq_printf(s, " %s=(fault)", name);
> +		trace_seq_printf(s, " %s=(fault)", name);
>  	else
> -		return trace_seq_printf(s, " %s=\"%s\"", name,
> -					(const char *)get_loc_data(data, ent));
> +		trace_seq_printf(s, " %s=\"%s\"", name,
> +				 (const char *)get_loc_data(data, ent));
> +	return !trace_seq_has_overflowed(s);
>  }
>  NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
>  


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


