Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaAERCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:02:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaAERCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:02:37 -0500
Date: Sun, 5 Jan 2014 18:02:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 06/21] perf tools: Update cpumode for each cumulative
 entry
Message-ID: <20140105170219.GF10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:12PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The cpumode and level in struct addr_localtion was set for a sample
> and but updated as cumulative callchains were added.  This led to have
> non-matching symbol and cpumode in the output.
> 
> Update it accordingly based on the fact whether the map is a part of
> the kernel or not.  This is a reverse of what thread__find_addr_map()
> does.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 34 +++++++++++++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 4fde0ab82498..17c41c686042 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -100,6 +100,7 @@ struct add_entry_iter {
>  	struct report *rep;
>  	struct perf_evsel *evsel;
>  	struct perf_sample *sample;
> +	struct machine *machine;
>  	struct hist_entry *he;
>  	struct symbol *parent;
>  	void *priv;
> @@ -362,7 +363,7 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
>  
>  static int
>  iter_prepare_cumulative_entry(struct add_entry_iter *iter,
> -			      struct machine *machine __maybe_unused,
> +			      struct machine *machine,
>  			      struct perf_evsel *evsel,
>  			      struct addr_location *al __maybe_unused,
>  			      struct perf_sample *sample)
> @@ -371,6 +372,7 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
>  
>  	iter->evsel = evsel;
>  	iter->sample = sample;
> +	iter->machine = machine;

machine is already in 'al->machine'

jirka
