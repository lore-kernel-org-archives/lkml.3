Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaLYWyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:54:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaLYWyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:54:11 -0500
Date: Thu, 25 Dec 2014 23:53:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 13/37] perf tools: Use thread__comm_time() when adding
 hist entries
Message-ID: <20141225225339.GA15569@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-14-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-14-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:09PM +0900, Namhyung Kim wrote:

SNIP

>  
>  			he = __hists__add_entry(hists, &al, NULL,
> -						NULL, NULL, 1, 1, 0, true);
> +						NULL, NULL, 1, 1, 0, -1, true);
>  			if (he == NULL)
>  				goto out;
>  
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 9314286ed25c..d322264bac22 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -451,11 +451,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
>  				      struct branch_info *bi,
>  				      struct mem_info *mi,
>  				      u64 period, u64 weight, u64 transaction,
> -				      bool sample_self)
> +				      u64 timestamp, bool sample_self)
>  {
>  	struct hist_entry entry = {
>  		.thread	= al->thread,
> -		.comm = thread__comm(al->thread),
> +		.comm = thread__comm_time(al->thread, timestamp),

with thread object having multiple comm entries, could this hurt
the single threaded performance?

The thread__comm_time function iterates comm_list each time,
maybe you could add some 'last_comm found check' logic in it?

jirka
