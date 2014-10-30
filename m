Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbaJ3TIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:08:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaJ3TIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:08:45 -0400
Date: Thu, 30 Oct 2014 20:08:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Message-ID: <20141030190841.GI23531@worktop.programming.kicks-ass.net>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:28:48PM +0100, Robert Bragg wrote:
> Our desired permission model seems consistent with perf's current model
> whereby you would need privileges if you want to profile across all gpu
> contexts but not need special permissions to profile your own context.
> 
> The awkward part is that it doesn't make sense for us to have userspace
> open a perf event with a specific pid as the way to avoid needing root
> permissions because a side effect of doing this is that the events will
> be dynamically added/deleted so as to only monitor while that process is
> scheduled and that's not really meaningful when we're monitoring the
> gpu.

There is precedent in PERF_FLAG_PID_CGROUP to replace the pid argument
with a fd to your object.

And do I take it right that if you're able/allowed/etc.. to open/have
the fd to the GPU/DRM/DRI whatever context you have the right
credentials to also observe these counters?

> Conceptually I suppose we want to be able to open an event that's not
> associated with any cpu or process, but to keep things simple and fit
> with perf's current design, the pmu I have a.t.m expects an event to be
> opened for a specific cpu and unspecified process.

There are no actual scheduling ramifications right? Let me ponder his
for a little while more..
