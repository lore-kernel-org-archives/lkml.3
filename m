Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaIKFaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:30:04 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61757 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaIKFaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:30:02 -0400
Date: Thu, 11 Sep 2014 00:29:56 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: BUG uncore_assign_events
Message-ID: <20140911002956.5e4aa1d9@as>
In-Reply-To: <20140910215908.GL4120@two.firstfloor.org>
References: <20140910091626.GO16043@twins.programming.kicks-ass.net>
	<20140910215908.GL4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 23:59:08 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > # addr2line -i -e ivb-ep-build/vmlinux ffffffff81025f18
> > 
> > arch/x86/include/asm/bitops.h:318
> > arch/x86/kernel/cpu/perf_event_intel_uncore.c:3339
> 
> i == zero  (ok)
> c points to some kernel looking address
> hwc->idx is 64
> 
>      /* fastpath, try to reuse previous register */
>         for (i = 0; i < n; i++) {
>                 hwc = &box->event_list[i]->hw;
>                 c = hwc->constraint;
> 
>                 /* never assigned */
>                 if (hwc->idx == -1)
>                         break;
> 
>                 /* constraint still honored */
>                 if (!test_bit(hwc->idx, c->idxmsk))
>                         break;
> 

hwc->idx is not 64 -- it's 0xd000064

The bt insn is causing a page fault 27 MB past c->idxmsk
