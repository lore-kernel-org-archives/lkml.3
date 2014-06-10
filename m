Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaFJFR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:17:58 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:33682 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaFJFR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:17:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 3/6] tracing: Only calculate stats of tracepoint benchmarks for 2^32 times
References: <20140606163034.516780857@goodmis.org>
	<20140606172104.552734596@goodmis.org>
Date: Tue, 10 Jun 2014 14:17:54 +0900
In-Reply-To: <20140606172104.552734596@goodmis.org> (Steven Rostedt's message
	of "Fri, 06 Jun 2014 12:30:37 -0400")
Message-ID: <87sindbawt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Fri, 06 Jun 2014 12:30:37 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> When calculating the average and standard deviation, it is required that
> the count be less than UINT_MAX, otherwise the do_div() will get
> undefined results. After 2^32 counts of data, the average and standard
> deviation should pretty much be set anyway.

[SNIP]
>  	if (bm_cnt > 1) {
>  		/*
>  		 * Apply Welford's method to calculate standard deviation:
>  		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
>  		 */
>  		stddev = (u64)bm_cnt * bm_totalsq - bm_total * bm_total;
> -		do_div(stddev, bm_cnt);
> -		do_div(stddev, bm_cnt - 1);
> +		do_div(stddev, (u32)bm_cnt);
> +		do_div(stddev, (u32)bm_cnt - 1);
>  	} else
>  		stddev = 0;

I also think that this if-else can go as it checks bm_cnt == 1 above.

Thanks,
Namhyung
