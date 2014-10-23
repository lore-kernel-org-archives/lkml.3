Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaJWFFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:05:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44384 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWFFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:05:17 -0400
Message-ID: <54488C84.3040408@hitachi.com>
Date: Thu, 23 Oct 2014 14:05:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] perf tools: Add support for exclusive option
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org> <1413990949-13953-5-git-send-email-namhyung@kernel.org>
In-Reply-To: <1413990949-13953-5-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/23 0:15), Namhyung Kim wrote:
> Some options cannot be used at the same time.  To handle such options
> add a new PARSE_OPT_EXCLUSIVE flag and show error message if more than
> one of them is used.

Looks useful for me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

I just have a comment below;

> @@ -360,19 +378,21 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>  		}
>  
>  		if (arg[1] != '-') {
> -			ctx->opt = arg + 1;
> +			ctx->opt = ++arg;
>  			if (internal_help && *ctx->opt == 'h')
>  				return usage_with_options_internal(usagestr, options, 0);
>  			switch (parse_short_opt(ctx, options)) {
>  			case -1:
> -				return parse_options_usage(usagestr, options, arg + 1, 1);
> +				return parse_options_usage(usagestr, options, arg, 1);
>  			case -2:
>  				goto unknown;
> +			case -3:
> +				goto exclusive;

BTW, it may be a time to define return error codes.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


