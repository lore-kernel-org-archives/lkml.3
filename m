Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaKKNFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:05:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:58235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaKKNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:05:15 -0500
Date: Tue, 11 Nov 2014 10:05:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Fix annotation with kcore
Message-ID: <20141111130511.GU18464@kernel.org>
References: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 11, 2014 at 12:04:54PM +0200, Adrian Hunter escreveu:
> Patch "perf tools: Fix build-id matching on vmlinux"

So, I will check this, but please state for which branch this is
supposed to be applied, i.e. does it fixes perf/urgent stuff and thus
needs to go ASAP, or is this something that affects perf/core and thus
can wait till I process more urgent stuff?

- Arnaldo

> breaks annotation with kcore.  The problem is that
> symbol__annotate() first gets the filename based on
> the build-id which was previously not set.
> This patch provides a quick fix, however there should
> probably be only one way to determine the filename. e.g.
> symbol__annotate() should use the same way as
> dso__data_fd().
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/annotate.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 7dabde1..873c877 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -915,6 +915,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
>  			return -ENOMEM;
>  		}
>  		goto fallback;
> +	} else if (dso__is_kcore(dso)) {
> +		goto fallback;
>  	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
>  		   strstr(command, "[kernel.kallsyms]") ||
>  		   access(symfs_filename, R_OK)) {
> -- 
> 1.9.1
