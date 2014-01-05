Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaAERK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:10:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaAERK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:10:56 -0500
Date: Sun, 5 Jan 2014 18:10:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 07/21] perf report: Cache cumulative callchains
Message-ID: <20140105171036.GG10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-8-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:13PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 

SNIP

>  	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
>  }
>  
> @@ -476,6 +522,8 @@ iter_finish_cumulative_entry(struct add_entry_iter *iter,
>  	evsel->hists.stats.total_period += sample->period;
>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
>  
> +	free(iter->priv);
> +	iter->priv = NULL;

zfree ;-) 

jirka
