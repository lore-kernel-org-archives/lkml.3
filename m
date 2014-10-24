Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaJXNjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:39:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33767 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbaJXNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141023055825.GA4559@gmail.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org> <20141023055825.GA4559@gmail.com>
From: Robert Bragg <robert@sixbynine.org>
Date: Fri, 24 Oct 2014 14:39:28 +0100
X-Google-Sender-Auth: r1DwslK0WxKDqOlb0X2zB4sVwmI
Message-ID: <CAMou1-2LwVjP-42E92nM_xif2EhyhhhzNxOiPoKfVJo5jmgmTw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 6:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Robert Bragg <robert@sixbynine.org> wrote:
>
>> [...]
>>
>> I'd be interested to hear whether is sounds reasonable to
>> others for us to expose gpu device metrics via a perf pmu and
>> whether adding the PERF_PMU_CAP_IS_DEVICE flag as in my
>> following patch could be acceptable.
>
> I think it's perfectly reasonable, it's one of the interesting
> kernel features I hoped for years would be implemented for perf.

Ok, that's good to hear, thanks.

>
>> [...]
>>
>> In addition I also explicitly black list numerous attributes
>> and PERF_SAMPLE_ flags that I don't think make sense for a
>> device pmu. This could be handled in the pmu driver but it
>> seemed better to do in events/core, avoiding duplication in
>> case we later have multiple device pmus.
>
> Btw., if the GPU is able to dump (part of) its current execution
> status, you could in theory even do instruction profiling and
> in-GPU profiling (symbol resolution, maybe even annotation, etc.)
> with close to standard perf tooling - which I think is currently
> mostly the domain of proprietary tools.

I'm not entirely sure; but there are certainly quite a few hw debug features
I haven't really explored yet that might lend themselves to supporting
something like this. At least there's a breakpoint mechanism that looks like
it might help for something like this, including providing a way to focus on
specific threads of interest which would be pretty important here to reduce
how much state would have to be periodically captured. I could be
interested to experiment with this later for sure.

With respect to the OA counters I'm looking to expose first, I would note
that the counter snapshots being written periodically are written by a fixed
function unit where we only have a limited set of layouts that we can
choose.

Beyond the OA counters I can certainly see us wanting further pmus for other
metrics though. For reference Chris Wilson experimented with some related
ideas last year, here:

 http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?
 h=perf&id=f32c19f4fb3a3bda92ab7bd0b9f95da14e81ca0a

Regards,
- Robert

>
> Thanks,
>
>         Ingo
