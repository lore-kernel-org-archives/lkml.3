Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbbALLob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:44:31 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56187 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbALLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:30 -0500
Message-ID: <54B3B397.8080808@hitachi.com>
Date: Mon, 12 Jan 2015 20:44:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/4] perf tools: Allow use of an exclusive option more
 than once
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/10 19:33), Namhyung Kim wrote:
> The exclusive options are to prohibit use of conflicting options at the
> same time.  But it had a side effect that it also limits a such option
> can be used at most once.  Currently the only user of the flag is perf
> probe and it allows to use such options more than once, but when one
> tries to use it, perf will fail like below:
> 
>   $ sudo perf probe -x /lib/libc-2.20.so --add malloc --add free
>     Error: option `add' cannot be used with add
>   ...
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/parse-options.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
> index f62dee7bd924..4a015f77e2b5 100644
> --- a/tools/perf/util/parse-options.c
> +++ b/tools/perf/util/parse-options.c
> @@ -46,7 +46,7 @@ static int get_value(struct parse_opt_ctx_t *p,
>  		return opterror(opt, "is not usable", flags);
>  
>  	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
> -		if (p->excl_opt) {
> +		if (p->excl_opt && p->excl_opt != opt) {
>  			char msg[128];
>  
>  			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


