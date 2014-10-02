Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaJBNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbaJBNs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:48:26 -0400
Date: Thu, 2 Oct 2014 15:46:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3.1 1/5] perf report: Set callchain_param.record_mode
 for future use
Message-ID: <20141002134606.GI9764@krava.brq.redhat.com>
References: <1412219335-17417-2-git-send-email-namhyung@kernel.org>
 <1412219534-17600-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412219534-17600-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 12:12:14PM +0900, Namhyung Kim wrote:
> Normally the callchain_param.record_mode is used only for record path.
> But as it might need to prepare something for dwarf unwinding, setup
> this info for perf report too.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c     | 6 ++++++
>  tools/perf/tests/dwarf-unwind.c | 3 +++
>  tools/perf/util/callchain.h     | 2 ++
>  tools/perf/util/hist.h          | 2 --
>  4 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index ac145fae0521..495168e73d4a 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -257,6 +257,12 @@ static int report__setup_sample_type(struct report *rep)
>  		}
>  	}
>  
> +	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain) {
> +		if (sample_type & PERF_SAMPLE_REGS_USER)

should we check also for PERF_SAMPLE_STACK_USER?
as in machine__resolve_callchain

thanks,
jirka
