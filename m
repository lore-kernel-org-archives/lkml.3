Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbaDVQyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbaDVQyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:54:22 -0400
Date: Tue, 22 Apr 2014 18:53:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/9] perf tools: Introduce hists__inc_dump_events()
Message-ID: <20140422165355.GK1104@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:46PM +0900, Namhyung Kim wrote:

SNIP

> index f955ae5a41c5..883340d7d43e 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -333,6 +333,19 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
>  	__events_stats__add(&hists->stats, type, 1);
>  }
>  
> +void hists__inc_dump_events(struct hists *hists)
> +{
> +	if (!dump_trace)
> +		return;
> +
> +	/*
> +	 * If dump_trace is enabled, perf will exit before accounting
> +	 * sample events during hists__output_resort().  Thus it needs to
> +	 * be done separately.
> +	 */
> +	__events_stats__add(&hists->stats, PERF_RECORD_SAMPLE, 1);
> +}

hum, we already clear all the stats before resorting for output so why done
we call hists__inc_nr_entries from add_hist_entry? (at out label)

jirka
