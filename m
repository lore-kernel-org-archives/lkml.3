Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaBRMxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:53:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbaBRMw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:52:59 -0500
Date: Tue, 18 Feb 2014 13:52:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
Message-ID: <20140218125206.GE4343@krava.brq.redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053356-23024-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:28:56PM -0500, Don Zickus wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> This is the start of a new perf tool that will collect information about
> memory accesses and analyse it to find things like hot cachelines, etc.
> 
> This is basically trying to get a prototype written by Richard Fowles
> written using the tools/perf coding style and libraries.
> 
> Start it from 'perf sched', this patch starts the process by adding the
> 'record' subcommand to collect the needed mem loads and stores samples.
> 
> It also have the basic 'report' skeleton, resolving the sample address
> and hooking the events found in a perf.data file with methods to handle
> them, right now just printing the resolved perf_sample data structure
> after each event name.

SNIP

> +		evsel->handler.func = assocs[i].handler;
> +	}
> +
> +	err = 0;
> +out:
> +	return err;
> +}
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index f5173cd..76f77c8 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -52,6 +52,13 @@ struct perf_evsel_str_handler {
>  	void	   *handler;
>  };
>  
> +int __perf_evlist__set_handlers(struct perf_evlist *evlist,
> +				const struct perf_evsel_str_handler *assocs,
> +				size_t nr_assocs);
> +
> +#define perf_evlist__set_handlers(evlist, array) \
> +	__perf_evlist__set_handlers(evlist, array, ARRAY_SIZE(array))
> +

this is already implemented in session object.. just need to be
changed to work over any event is globaly usable

jirka
