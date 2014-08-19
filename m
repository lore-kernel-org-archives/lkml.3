Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaHSGXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:23:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55742 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaHSGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:23:14 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Add PERF_PID
References: <1407964337-23952-1-git-send-email-andi@firstfloor.org>
Date: Tue, 19 Aug 2014 15:23:12 +0900
In-Reply-To: <1407964337-23952-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Wed, 13 Aug 2014 14:12:17 -0700")
Message-ID: <874mx9c81b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, 13 Aug 2014 14:12:17 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> It's currently difficult to filter out perf itself using a filter.
> This can give cascading effects during IO tracing when the IO
> perf does itself causes more trace output.
>
> The best way to filter is to use the pid. But it's difficult to get the pid
> of perf without using hacks.
>
> Add a PERF_PID meta variable to the perf filter that contains the current pid.
>
> With this patch the following works
>
> % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...
>
> This won't work for more complex perf pipe lines with multiple processes,
> but at least solves the problem nicely for a single perf.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I like the idea, so with comments below fixed:

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


[SNIP]
> +	/* Assume a pid has not more than 8 characters */
> +	pid = strstr(last->filter, "PERF_PID");
> +	if (pid) {
> +		char buf[9];
> +		snprintf(buf, 9, "%08d", getpid());

Why do you add zero-paddings?  I guess it'd confuse the parser as if
it's an octal digits.  What about just using "%8d"?  It seems the parser
ignores whitespaces between tokens..


> +		memcpy(pid, buf, 8);
> +	}
> +	fprintf(stderr, "filter |%s|\n", last->filter);

Isn't it a debug message?

Thanks,
Namhyung


>  	return 0;
>  }
