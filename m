Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaEZRea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaEZRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:34:29 -0400
Date: Mon, 26 May 2014 19:33:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
Message-ID: <20140526173348.GA7657@krava.brq.redhat.com>
References: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:01:26PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> perf stat -rX prints the stddev for multiple measurements.
> Just looking at the stddev for judging the quality of the data
> is a bit dangerous The simplest sanity check is to just look
> at a simple plot. This patchs add a sparkline to the end
> of the measurements to make it simple to judge the data.
> 
> The sparkline only uses UTF-8, so should be readable
> in all modern tools and terminals.
> 
> The sparkline is between the minimum and maximum of the data,
> so it's mainly a indicator of variance. To keep the code
> simple and make the output not too wide only the first
> 8 values are printed. If more values are there it adds '..'
> 
> The code is inspired by Zach Holman's spark shell script.
> 
> Example output (view in non-proportial font):
> 
>  Performance counter stats for 'true' (10 runs):
> 
>           0.175672      task-clock (msec)         #    0.555 CPUs utilized            ( +-  1.77% ) █▄▁▁▁▁▁▁..
>                  0      context-switches          #    0.000 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                114      page-faults               #    0.647 M/sec                    ( +-  0.14% ) ▁█▁▁████..
>            520,798      cycles                    #    2.965 GHz                      ( +-  1.75% ) █▄▁▁▁▁▁▁..
>            433,525      instructions              #    0.83  insns per cycle          ( +-  0.28% ) ▅▇▅▄▇█▁▆..
>             83,012      branches                  #  472.537 M/sec                    ( +-  0.31% ) ▅▇▆▄▇█▁▆..
>              3,157      branch-misses             #    3.80% of all branches          ( +-  2.55% ) ▇█▃▅▁▃▁▂..
> 
>        0.000316660 seconds time elapsed                                          ( +-  1.78% ) █▅▁▁▁▁▁▁..
> 
> As you can see even in the most simple run there are quite interesting
> patterns. The time sparkline suggests it would be also useful to have an option
> to throw the first measurement away.
> 
> Known issues:
> - Makes the perf stat output wider. Could be adjust by shrinking
> some white space. Not done so far.
> - No output for -A/--per-socket/--per-core with -rX. This code
> is missing the basic noise detection code. Once it's added there
> sparklines could be shown too.
> 
> v2: Address review feedback. Use all_zero() and remove len.

ok.. confusing.. so this v2 has changes which are missing in v3 patch:
http://marc.info/?l=linux-kernel&m=139767371027557&w=2

jirka
