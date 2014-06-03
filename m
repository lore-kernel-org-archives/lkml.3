Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbaFCTrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:47:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaFCTrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:47:42 -0400
Date: Tue, 3 Jun 2014 21:47:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v5
Message-ID: <20140603194702.GC4213@krava.brq.redhat.com>
References: <1401486136-20892-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401486136-20892-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 02:42:16PM -0700, Andi Kleen wrote:
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
> v2: Avoid printing spark lines for normal CSV case (Jiri)
> v3: LONG->ULONG, random changes
> v4: Add some missing changes from the forked v2: checks value is not
> zero instead of all the same. Update documentation. Remove n variable.
> Remove #pragma once
> v5: Add overflow fixes from Jiri.

got compilation error on Fedora 15 i386:

  CC       util/stat.o
util/stat.c: In function ‘print_stat_spark’:
util/stat.c:91:2: error: passing argument 1 of ‘all_zero’ from incompatible pointer type [-Werror]
util/stat.c:71:12: note: expected ‘long unsigned int *’ but argument is of type ‘u64 *’
util/stat.c:94:2: error: passing argument 2 of ‘print_spark’ from incompatible pointer type [-Werror]
util/spark.h:3:6: note: expected ‘long unsigned int *’ but argument is of type ‘u64 *’
cc1: all warnings being treated as errors
make[1]: *** [util/stat.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2


jirka
