Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889Ab3JQWCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:02:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36492 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289Ab3JQWCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:02:11 -0400
Date: Fri, 18 Oct 2013 00:01:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017220156.GB10651@twins.programming.kicks-ass.net>
References: <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016205227.GJ7456@tassilo.jf.intel.com>
 <20131016210319.GI10651@twins.programming.kicks-ass.net>
 <20131016230712.GC26785@twins.programming.kicks-ass.net>
 <20131017094145.GE3364@laptop.programming.kicks-ass.net>
 <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:26:23AM -0700, Linus Torvalds wrote:
> On Thu, Oct 17, 2013 at 9:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > So avoid having to call copy_from_user_nmi() for every instruction.
> > Since we already limit the max basic block size, we can easily
> > pre-allocate a piece of memory to copy the entire thing into in one
> > go.
> 
> copy_from_user_nmi() itself is all kinds of nasty.

Oh wait,.. now that Steven fixed being able to take faults from NMI
context; we could actually try copy_from_user_inatomic(). Being able to
directly access userspace would make the whole deal a lot easier again.

I'll go try this tomorrow.
