Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaFSM4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:56:53 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63830 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaFSM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:56:51 -0400
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file
 option
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1403178076-14072-6-git-send-email-jolsa@kernel.org>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
	 <1403178076-14072-6-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jun 2014 21:56:44 +0900
Message-ID: <1403182604.1670.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-06-19 (목), 13:41 +0200, Jiri Olsa:
> Adding report.show-headers config file option to setup
> the appearance of the columns headers.
> 
> Currently columns headers are displayed by default, following
> lines in ~/.perfconfig file will disable that:
> 
>   [report]
>         show-headers = true

This also applies to perf top, right?  And it's TUI-specific.  So how
about calling it something like "tui.show-headers"?


[SNIP]
> @@ -35,6 +35,7 @@ struct symbol_conf symbol_conf = {
>  	.demangle		= true,
>  	.cumulate_callchain	= true,
>  	.symfs			= "",
> +	.show_headers		= -1,

Hmm.. why not just making it boolean and set it to true (like others)?

Thanks,
Namhyung


>  };
>  
>  static enum dso_binary_type binary_type_symtab[] = {
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 615c752..8f1854a 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -139,6 +139,7 @@ struct symbol_conf {
>  			*sym_from_list,
>  			*sym_to_list;
>  	const char	*symfs;
> +	int		show_headers;
>  };
>  
>  extern struct symbol_conf symbol_conf;



