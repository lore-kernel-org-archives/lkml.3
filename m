Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaAESIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:08:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaAESIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:08:36 -0500
Date: Sun, 5 Jan 2014 19:08:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 21/21] perf tools: Enable --children option by default
Message-ID: <20140105180818.GN10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-22-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-22-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:27PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Now perf top and perf report will show children column by default if
> it has callchain information.
> 
> Requested-by: Ingo Molnar <mingo@kernel.org>

hum, so I could easily put 'children = false' to my .perfconfig
to get the previous default behaviour back..

but I thought the notion was not to disturb user with
new features ...and I feel disturbed ;-)

I probably missed some discussion about this

jirka

> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/symbol.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 923d00040bbf..3e73079e6c92 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -29,11 +29,12 @@ int vmlinux_path__nr_entries;
>  char **vmlinux_path;
>  
>  struct symbol_conf symbol_conf = {
> -	.use_modules	  = true,
> -	.try_vmlinux_path = true,
> -	.annotate_src	  = true,
> -	.demangle	  = true,
> -	.symfs            = "",
> +	.use_modules		= true,
> +	.try_vmlinux_path	= true,
> +	.annotate_src		= true,
> +	.demangle		= true,
> +	.cumulate_callchain	= true,
> +	.symfs			= "",
>  };
>  
>  static enum dso_binary_type binary_type_symtab[] = {
> -- 
> 1.7.11.7
> 
