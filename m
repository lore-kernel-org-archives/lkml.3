Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJWF6b (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 23 Oct 2014 01:58:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47395 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaJWF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:58:30 -0400
Date: Thu, 23 Oct 2014 07:58:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Message-ID: <20141023055825.GA4559@gmail.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Bragg <robert@sixbynine.org> wrote:

> [...]
> 
> I'd be interested to hear whether is sounds reasonable to 
> others for us to expose gpu device metrics via a perf pmu and 
> whether adding the PERF_PMU_CAP_IS_DEVICE flag as in my 
> following patch could be acceptable.

I think it's perfectly reasonable, it's one of the interesting 
kernel features I hoped for years would be implemented for perf.

> [...]
> 
> In addition I also explicitly black list numerous attributes 
> and PERF_SAMPLE_ flags that I don't think make sense for a 
> device pmu. This could be handled in the pmu driver but it 
> seemed better to do in events/core, avoiding duplication in 
> case we later have multiple device pmus.

Btw., if the GPU is able to dump (part of) its current execution 
status, you could in theory even do instruction profiling and 
in-GPU profiling (symbol resolution, maybe even annotation, etc.) 
with close to standard perf tooling - which I think is currently 
mostly the domain of proprietary tools.

Thanks,

	Ingo
