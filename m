Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3JKVvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:51:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:16487 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3JKVvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:51:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,478,1378882800"; 
   d="scan'208";a="306780952"
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<20131011055829.GA4975@gmail.com>
	<20131011073448.GA11064@krava.redhat.com> <52581511.2010909@gmail.com>
	<52581737.8090309@gmail.com>
Date: Fri, 11 Oct 2013 14:51:35 -0700
In-Reply-To: <52581737.8090309@gmail.com> (David Ahern's message of "Fri, 11
	Oct 2013 09:20:23 -0600")
Message-ID: <87wqljxyqg.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 10/11/13 9:11 AM, David Ahern wrote:
>> It would be nice to fix the callchain arg handler to not attempt to
>> process the next argument if it is not fp or dwarf.
>
> Specifically, something like this which maintains syntax and default
> fp option:

Yes please! This happens to me all the time too

(usually I train myself to use -g --, but i still sometimes forget)

It still wouldn't handle -ga, but naked -g seems to be the common case.

-Andi

>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 92ca541..23d782c 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -766,8 +766,8 @@ int record_parse_callchain_opt(const struct option *opt,
>                      opts->stack_dump_size);
>  #endif /* HAVE_LIBUNWIND_SUPPORT */
>         } else {
> -           pr_err("callchain: Unknown -g option "
> -                  "value: %s\n", arg);
> +           opts->call_graph = CALLCHAIN_FP;
> +           ret = 0;
>             break;
>         }
>
>

-- 
ak@linux.intel.com -- Speaking for myself only
