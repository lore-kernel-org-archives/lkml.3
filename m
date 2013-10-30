Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3J3WcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:32:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab3J3WcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:32:21 -0400
Date: Wed, 30 Oct 2013 22:31:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030223139.GA27743@mudshark.cambridge.arm.com>
References: <20131030143750.GT19466@laptop.lan>
 <20131030195013.GA2253@localhost.localdomain>
 <20131030201622.GR16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030201622.GR16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Oct 30, 2013 at 08:16:22PM +0000, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 08:50:28PM +0100, Frederic Weisbecker wrote:
> > 
> > Would it make sense to rather make copy_from_user_nmi() to use a return value
> > pattern that is closer to those of the existing copy_from_user_*() ?
> 
> Yeah we can do that I suppose; copy_form_user_nmi() actually uses
> __copy_from_user_inatomic() since about a week.
> 
> Something like so I suppose.. please check, I'm in fail mode.
> 
> It looks like DEFINE_OUTPUT_COPY() functions already returned the bytes
> not copied, and all its users appear to indeed expect that.
> 
> ---
>  arch/x86/kernel/cpu/perf_event.c           |  4 ++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |  2 +-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 +-
>  arch/x86/lib/usercopy.c                    |  2 +-
>  arch/x86/oprofile/backtrace.c              |  4 ++--
>  kernel/events/internal.h                   | 35 ++++++++++++++++++++++--------
>  6 files changed, 33 insertions(+), 16 deletions(-)

The core changes look good to me, and I've tested that this still produces
callchain information for ARM. It's odd that this worked so well before...

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
