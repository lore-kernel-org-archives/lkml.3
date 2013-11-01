Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3KAMIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab3KAMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:08:16 -0400
Date: Fri, 1 Nov 2013 13:07:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 02/14] perf tools: Introduce struct add_entry_iter
Message-ID: <20131101120735.GB10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:56:04PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

> +
> +static int
> +perf_evsel__add_entry(struct perf_evsel *evsel, struct addr_location *al,
> +		      struct perf_sample *sample, struct machine *machine,
> +		      struct add_entry_iter *iter)
> +{
> +	int err;
> +
> +	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
> +		err = machine__resolve_callchain(machine, evsel, al->thread,
> +						 sample, &iter->parent, al,
> +						 iter->rep->max_stack);
> +		if (err)
> +			return err;
> +	}
> +
> +	err = iter->prepare_entry(iter, machine, evsel, al, sample);
> +	if (err)
> +		return err;
> +
> +	err = iter->add_single_entry(iter, al);
> +	if (err)
> +		return err;
> +
> +	while (iter->next_entry(iter, al)) {
> +		err = iter->add_next_entry(iter, al);
> +		if (err)
> +			break;
> +	}
> +
> +	err = iter->finish_entry(iter, al);
> +
> +	return err;

	return iter->finish_entry(iter, al);  ?

