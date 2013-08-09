Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667Ab3HIJMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:12:18 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42345 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845Ab3HIJMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:12:14 -0400
Message-ID: <5204B268.3020201@hitachi.com>
Date: Fri, 09 Aug 2013 18:12:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 02/13] tracing/probes: Fix basic print type functions
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1376037909-17797-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 17:44), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The print format of s32 type was "ld" and it's casted to "long".  So
> it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
> sure whether it worked well on 32-bit systems.
> 
> Anyway, it'd be better if we have exact format and type cast for each
> types on both of 32- and 64-bit systems.  In fact, the only difference
> is on s64/u64 types.
> 

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_probe.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 412e959709b4..b571e4de0769 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -49,14 +49,19 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
>  }									\
>  static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
>  
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%x", unsigned char)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned short)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%x", unsigned int)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", short)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d", int)
> +#if BITS_PER_LONG == 32
>  DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
>  DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
> +#else /* BITS_PER_LONG == 64 */
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%lx", unsigned long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%ld", long)
> +#endif
>  
>  static inline void *get_rloc_data(u32 *dl)
>  {
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


