Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaAEO4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 09:56:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaAEO4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 09:56:09 -0500
Date: Sun, 5 Jan 2014 15:55:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct add_entry_iter
Message-ID: <20140105145542.GA7734@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:07PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

> -		return err;
> +		goto out;
> +
> +	err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
> +	if (err)
> +		goto out;
> +
> +	evsel->hists.stats.total_period += 1;
> +	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> +
> +out:
> +	iter->curr++;
> +	return err;
> +}
> +
> +static int
> +iter_finish_branch_entry(struct add_entry_iter *iter,
> +			 struct addr_location *al __maybe_unused)
> +{
> +	free(iter->priv);
> +	iter->priv = NULL;

Arnaldo just added zfree ;-)

jirka
