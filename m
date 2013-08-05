Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3HEJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:46:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3HEJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:46:37 -0400
Date: Mon, 5 Aug 2013 11:45:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] perf, tools: Output running time and run/enabled
 ratio in CSV mode
Message-ID: <20130805094556.GA25221@krava.redhat.com>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
 <1375490473-1503-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375490473-1503-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 05:41:13PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The information how much a counter ran in perf stat can be quite
> interesting for other tools to judge how trustworthy a measurement is.
> 
> Currently it is only output in non CSV mode.
> 
> This patches make perf stat always output the running time and the
> enabled/running ratio in CSV mode.
> 
> This adds two new fields at the end for each line. I assume that existing
> tools ignore new fields at the end, so it's on by default.
> 
> Only CSV mode is affected, no difference otherwise.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/builtin-stat.c | 57 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 45 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index f686d5f..940fcfd 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -982,6 +982,13 @@ static void print_aggr(char *prefix)
>  					fprintf(output, "%s%s",
>  						csv_sep, counter->cgrp->name);
>  
> +				if (csv_output)
> +					fprintf(output, "%s%" PRIu64 "%s%.2f",
> +						csv_sep,
> +						run,
> +						csv_sep,
> +						100.0 * run / ena);

looks like we could use function/macro for this

jirka
