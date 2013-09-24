Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3IXMkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:40:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56555 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:39:59 -0400
Message-ID: <52418818.3050308@gmail.com>
Date: Tue, 24 Sep 2013 06:39:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf bench: Change the procps visible command-name of
 invididual benchmark tests
References: <20130924103900.GA5085@gmail.com>
In-Reply-To: <20130924103900.GA5085@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/13 4:39 AM, Ingo Molnar wrote:
> +/*
> + * Run a specific benchmark but first rename the running task's ->comm[]
> + * to something meaningful:
> + */
> +static int run_bench(const char *subsys_name, const char *bench_name, bench_fn_t fn, int argc, const char **argv, const char *prefix)

As I recall you are a fan of longer line lengths, but this seems 
excessive. ;-)

---8<---

> +}
> +
> +static void all_suites(struct bench_subsys *subsys)	  /* FROM HERE */

Might as well drop the /* FROM HERE */.

---8<---

> @@ -244,8 +269,7 @@ int cmd_bench(int argc, const char **arg
>   				       subsystems[i].name,
>   				       subsystems[i].suites[j].name);
>   			fflush(stdout);
> -			status = subsystems[i].suites[j].fn(argc - 1,
> -							    argv + 1, prefix);
> +			status = run_bench(subsystems[i].name, subsystems[i].suites[j].name, subsystems[i].suites[j].fn, argc - 1, argv + 1, prefix);

another one that is rather long.

David


