Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3GIGS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:18:26 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63897 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3GIGSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:18:24 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-56-51dbab2d445c
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan\, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old events
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
	<20130708121557.GA17211@twins.programming.kicks-ass.net>
Date: Tue, 09 Jul 2013 15:18:20 +0900
In-Reply-To: <20130708121557.GA17211@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 8 Jul 2013 14:15:57 +0200")
Message-ID: <87vc4kxnmb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 8 Jul 2013 14:15:57 +0200, Peter Zijlstra wrote:
[SNIP]
> +static void 
> +perf_event_set_overflow(struct perf_event *event, struct ring_buffer *rb)
> +{
> +	if (event->overflow_handler != perf_event_output ||

I guess you wanted "&&" instead of "||" here.

Thanks,
Namhyung


> +	    event->overflow_handler != perf_event_output_overwrite)
> +		return;
> +
> +	if (rb->overwrite)
> +		event->overflow_handler = perf_event_output_overwrite;
> +	else
> +		event->overflow_handler = perf_event_output;
> +}
