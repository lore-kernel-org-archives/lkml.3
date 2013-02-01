Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3BAImW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:42:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63123 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BAImS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:42:18 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-98-510b7fe677ba
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf: add new uncore command
References: <1359640479-5289-1-git-send-email-eranian@google.com>
Date: Fri, 01 Feb 2013 17:42:13 +0900
In-Reply-To: <1359640479-5289-1-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Thu, 31 Jan 2013 14:54:37 +0100")
Message-ID: <878v78togq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephane

On Thu, 31 Jan 2013 14:54:37 +0100, Stephane Eranian wrote:
> This patchset adds a new command to perf: perf uncore.
> It is used to measure processor socket-level metrics
> on a system-wide basis and at all priv levels.
>
> The command comes with a set of predefined key metrics
> which are useful to measure multi-socket system imbalance
> and various bandwidths.
>
> The following metrics are currently defined:
>   - memory bandwidth (Nehalem, Westmere, SandyBridge-EP)
>   - PCIe bandwidth (SandyBridge-EP)
>   - QPI bandwidth (SandyBridge-EP)
>   - C-state residency (SandyBridge-EP)
>
> Others can be added in the future.
>
> The command provides options to modify the unit of the metrics
> (default: MB/s for bandwidth).
>
> Example on Nehalem:
>
>  # perf uncore
>  #------------------------------
>  #           Socket0           |
>  #------------------------------
>  #        RAM Bandwidth        |
>  #            Wr             Rd|
>  #          MB/s           MB/s|
>  #------------------------------
>          4954.99       14897.29
>          4953.97       14894.56
>          4947.52       14874.97
>
> To make plotting easier, the output can be augmented with a timestamp:
>
>  # perf uncore -T
>  #----------------------------------------
>  #         |           Socket0           |
>  #         |------------------------------
>  #   Time  |        RAM Bandwidth        |
>  #    in   |            Wr             Rd|
>  #   secs  |          MB/s           MB/s|
>  #----------------------------------------
>           1        4952.50       14890.49
>           2        4955.55       14900.19
>           3        4949.13       14879.60
>           4        4954.66       14896.26
>
> The code is split between generic layer (builtin-uncore.c) and
> an arch specific layer (arch/*/util/uncore.c). All events are
> hardcoded because they don't change for a given processor and
> metric computation requires combining multiple events.

>From a quick glancing, I think this is basically what perf stat does
with selected events, right?  As we now have your interval printing I
can't find much difference.

And there's a patchset [1] from Jiri to support some kind of formula -
yeah, now I've written the correct spelling. :) - that might fit to this
purpose if you provide suitable formula file IMHO.  So I guess we don't
need to have another command and can reuse perf stat, no?

Thanks,
Namhyung


[1] http://lwn.net/Articles/532634/
