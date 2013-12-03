Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3LCQKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:10:48 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34533 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3LCQKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:10:44 -0500
Message-ID: <529E00F6.7000802@gmail.com>
Date: Tue, 03 Dec 2013 09:04:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/7] perf script: Add an option to print the source line
 number
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com> <1386055390-13757-3-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1386055390-13757-3-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/13, 12:23 AM, Adrian Hunter wrote:
> @@ -348,6 +355,24 @@ static void print_sample_start(struct perf_sample *sample,
>   	}
>   }
>
> +static void print_sample_finish(struct perf_evsel *evsel,
> +				struct addr_location *al)
> +{
> +	struct perf_event_attr *attr = &evsel->attr;
> +
> +	if (PRINT_FIELD(SRCLINE) && al->map && al->map->dso) {
> +		char *srcline;
> +
> +		srcline = get_srcline(al->map->dso,
> +				      map__rip_2objdump(al->map, al->addr));
> +		if (srcline != SRCLINE_UNKNOWN)
> +			printf("\n  %s", srcline);
> +		free_srcline(srcline);
> +	}
> +
> +	printf("\n");
> +}
> +
>   static bool is_bts_event(struct perf_event_attr *attr)
>   {
>   	return ((attr->type == PERF_TYPE_HARDWARE) &&
> @@ -438,7 +463,7 @@ static void print_sample_bts(union perf_event *event,
>   	     !output[attr->type].user_set))
>   		print_sample_addr(event, sample, machine, thread, attr);
>
> -	printf("\n");
> +	print_sample_finish(evsel, al);
>   }
>
>   static void process_event(union perf_event *event, struct perf_sample *sample,
> @@ -480,7 +505,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
>   				     PERF_MAX_STACK_DEPTH);
>   	}
>
> -	printf("\n");
> +	print_sample_finish(evsel, al);
>   }
>
>   static int default_start_script(const char *script __maybe_unused,

What about callchains?

David

