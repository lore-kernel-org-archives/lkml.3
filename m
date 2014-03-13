Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaCMOfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:35:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:63015 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaCMOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:35:12 -0400
Date: Thu, 13 Mar 2014 11:34:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf bench: Fix NULL pointer dereference in "perf bench
 all"
Message-ID: <20140313143456.GA2396@ghostprotocols.net>
References: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 12, 2014 at 06:40:51PM -0400, Patrick Palka escreveu:
> for_each_bench() must check that the "benchmarks" field of a collection
> is not NULL before dereferencing it because the "all" collection in
> particular has a NULL "benchmarks" field (signifying that it has no
> benchmarks to iterate over).
> 
> This fixes a NULL pointer dereference when running "perf bench all".

Can you please mention against which tree you're fixing things? I just
tried to reproduce it here on perf/urgent and this problem is not
reproducible by simply running:

  perf bench all

So now I'm going to try on perf/core, tip/master, etc :-\

- Arnaldo
 
> Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
> ---
>  tools/perf/builtin-bench.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
> index e47f90c..8a987d2 100644
> --- a/tools/perf/builtin-bench.c
> +++ b/tools/perf/builtin-bench.c
> @@ -76,7 +76,7 @@ static struct collection collections[] = {
>  
>  /* Iterate over all benchmarks within a collection: */
>  #define for_each_bench(coll, bench) \
> -	for (bench = coll->benchmarks; bench->name; bench++)
> +	for (bench = coll->benchmarks; bench && bench->name; bench++)
>  
>  static void dump_benchmarks(struct collection *coll)
>  {
> -- 
> 1.9.0
