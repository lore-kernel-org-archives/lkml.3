Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaKQFJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:09:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39938 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaKQFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:09:35 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V2 2/3] perf tool:perf diff support for different binaries
References: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
	<1415653280-1374-3-git-send-email-kan.liang@intel.com>
Date: Mon, 17 Nov 2014 14:09:33 +0900
In-Reply-To: <1415653280-1374-3-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Mon, 10 Nov 2014 16:01:19 -0500")
Message-ID: <87fvditnua.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 16:01:19 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> Currently, the perf diff only works with same binaries. That's because
> it compares the symbol start address. It doesn't work if the perf.data
> comes from different binaries. This patch matches the function names.
>
> Signed-off-by: Kan Liang <kan.liang@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/sort.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 9402885..ee235ab 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1430,6 +1430,15 @@ int sort_dimension__add(const char *tok)
>  			sort__has_parent = 1;
>  		} else if (sd->entry == &sort_sym) {
>  			sort__has_sym = 1;
> +			/*
> +			 * perf diff displays the performance difference amongst
> +			 * two or more perf.data files. Those files could come from
> +			 * different binaries. So we should not compare their ips.
> +			 * The name of symble should be the key we do compare.
> +			 */
> +			if (sort__mode == SORT_MODE__DIFF)
> +				sd->entry->se_collapse = sort__sym_sort;
> +
>  		} else if (sd->entry == &sort_dso) {
>  			sort__has_dso = 1;
>  		}
