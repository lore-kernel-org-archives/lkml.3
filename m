Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaGQIbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:31:41 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:64871 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaGQIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140717082613.GF19379@twins.programming.kicks-ass.net>
References: <1405585266-28268-1-git-send-email-namhyung@kernel.org> <20140717082613.GF19379@twins.programming.kicks-ass.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 17 Jul 2014 17:31:14 +0900
X-Google-Sender-Auth: 3FQST7yFsxIvmz5EgbkLeIzC2ps
Message-ID: <CAM9d7ciELhfJwdNBSJPCJcrVr43+hs+80m-FK7bE1mkuBcv0yQ@mail.gmail.com>
Subject: Re: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for
 each run
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jul 17, 2014 at 5:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jul 17, 2014 at 05:21:06PM +0900, Namhyung Kim wrote:
>> When perf stat runs multiple times via -r option, it's sometimes
>> useful for a workload to know which run it executing.  So pass new
>> PERF_STAT_RUN environment variable to the workload for each run
>> (starting from 1).
>
> This seems counter intuitive, runs should be _identical_ otherwise
> there's no point. That means the workload should very much _not_ know
> these things.

But I think it can be useful if a workload wants to save logfiles
based on the iteration number for example.  If it doesn't want, it can
just ignore. :)

Thanks,
Namhyung
