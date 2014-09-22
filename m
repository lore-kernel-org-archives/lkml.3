Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaIVOZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbaIVOZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:25:27 -0400
Date: Mon, 22 Sep 2014 16:25:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
Message-ID: <20140922142510.GE18187@krava.brq.redhat.com>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
 <1411229886-24390-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411229886-24390-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 01:18:05AM +0900, Namhyung Kim wrote:
> This patch adds support for following config options to ~/.perfconfig file.
> 
>   [call-graph]
>     record-mode = dwarf
>     dump-size = 8192
>     print-type = fractal
>     order = callee
>     threshold = 0.5
>     print-limit = 128
>     sort-key = function
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/callchain.c | 33 +++++++++++++++++++++++++++++++++
>  tools/perf/util/callchain.h |  1 +
>  tools/perf/util/config.c    |  3 +++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index ba7297230143..ee489a1e3f4c 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -168,6 +168,39 @@ parse_callchain_report_opt(const char *arg)
>  	return 0;
>  }
>  
> +int perf_callchain_config(const char *var, const char *value)
> +{
> +	if (prefixcmp(var, "call-graph."))
> +		return 0;
> +	var += 11; /* strlen("call-graph.") == 11 */

should we use sizeof("call-graph.") - 1 instead ?

jirka
