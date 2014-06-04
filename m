Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaFDPdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:33:15 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49770 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaFDPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:33:13 -0400
Subject: Re: [PATCH 9/9] perf, tools, record: Always allow to overide
 default period v2
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
In-Reply-To: <1401486615-21374-10-git-send-email-andi@firstfloor.org>
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
	 <1401486615-21374-10-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jun 2014 00:33:07 +0900
Message-ID: <1401895987.1673.36.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

2014-05-30 (금), 14:50 -0700, Andi Kleen:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Fix the logic to allow overriding event default periods with -c or -F
> on the command line.  I'm not sure I understand this if() fully, but
> this change makes all cases I tested work (tracepoint with default, default,
> ,-c, -F)

Are you sure you tested all cases after this patch applied?

When I apply it, it doesn't record any samples..

  $ perf record -a sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.309 MB perf.data 
                 (~13494 samples) ]

  $ perf report --stdio
  Error:
  The perf.data file has no samples!
  # To display the perf.data header info,
  # please use --header/--header-only options.

  $ perf evlist -F
  cycles: sample_freq=0


Thanks,
Namhyung

> 
> This fixed specifying -c / -F with json event list events,
> which have a default period. It should do the same
> for trace point events.
> 
> Cc: fweisbec@gmail.com
> v2: Simplify, just change || to &&
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/evsel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 5c28d82..d9ceede 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -592,7 +592,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  	 * We default some events to a 1 default interval. But keep
>  	 * it a weak assumption overridable by the user.
>  	 */
> -	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
> +	if (!attr->sample_period && (opts->user_freq != UINT_MAX &&
>  				     opts->user_interval != ULLONG_MAX)) {
>  		if (opts->freq) {
>  			perf_evsel__set_sample_bit(evsel, PERIOD);



