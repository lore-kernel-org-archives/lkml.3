Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaAEReW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:34:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaAEReV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:34:21 -0500
Date: Sun, 5 Jan 2014 18:33:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/21] perf ui/browser: Add support to accumulated hist
 stat
Message-ID: <20140105173355.GI10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:16PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Print accumulated stat of a hist entry if requested.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index a440e03cd8c2..efa78894f70d 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -693,11 +693,26 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
>  	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
>  }
>  
> +#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field, _cb)			\
> +static u64 __hpp_get_acc_##_field(struct hist_entry *he)		\
> +{									\
> +	return he->stat_acc->_field;					\
> +}									\
> +									\
> +static int								\
> +hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
> +				struct perf_hpp *hpp,			\
> +				struct hist_entry *he)			\
> +{									\
> +	return __hpp__color_fmt(hpp, he, __hpp_get_acc_##_field, _cb);	\
> +}
> +
>  __HPP_COLOR_PERCENT_FN(overhead, period, __hpp__color_callchain)
>  __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, NULL)
>  __HPP_COLOR_PERCENT_FN(overhead_us, period_us, NULL)
>  __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, NULL)
>  __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
> +__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period, NULL)

same comment as for ui/hist.c..

including _type parameter in __HPP_COLOR_PERCENT_FN ;-)

jirka
