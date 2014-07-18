Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbaGRFGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:06:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50960 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbaGRFGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:06:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for each run
References: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
	<20140717082613.GF19379@twins.programming.kicks-ass.net>
	<CAM9d7ciELhfJwdNBSJPCJcrVr43+hs+80m-FK7bE1mkuBcv0yQ@mail.gmail.com>
	<20140717084011.GG19379@twins.programming.kicks-ass.net>
	<20140717130943.GA4312@kernel.org>
Date: Fri, 18 Jul 2014 14:06:08 +0900
In-Reply-To: <20140717130943.GA4312@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 17 Jul 2014 10:09:43 -0300")
Message-ID: <87d2d3l0hr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Peter,

On Thu, 17 Jul 2014 10:09:43 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 17, 2014 at 10:40:11AM +0200, Peter Zijlstra escreveu:
>> On Thu, Jul 17, 2014 at 05:31:14PM +0900, Namhyung Kim wrote:
>> > On Thu, Jul 17, 2014 at 5:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Thu, Jul 17, 2014 at 05:21:06PM +0900, Namhyung Kim wrote:
>> > >> When perf stat runs multiple times via -r option, it's sometimes
>> > >> useful for a workload to know which run it executing.  So pass new
>> > >> PERF_STAT_RUN environment variable to the workload for each run
>> > >> (starting from 1).
>
>> > > This seems counter intuitive, runs should be _identical_ otherwise
>> > > there's no point. That means the workload should very much _not_ know
>> > > these things.
>
>> > But I think it can be useful if a workload wants to save logfiles
>> > based on the iteration number for example.  If it doesn't want, it can
>> > just ignore. :)
>
>> That's the wrong way around. Also, there's --pre and --post hooks to
>> preserve logfiles if you really have to do that kind of thing.
>
> Agreed, one can script this using --pre or --post if needed.

Hmm... okay, I'll drop this then.

Thanks,
Namhyung
