Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab3DYQ1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:27:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab3DYQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:27:00 -0400
Date: Thu, 25 Apr 2013 18:25:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130425162535.GA5828@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:04:53PM -0700, Andi Kleen wrote:
> Possible options:
> 
> I) Disable FAR calls for ANY_CALL/RETURNS.
> This just means syscalls are not logged
> as calls. This also lowers the overhead of call logging.
> This changes semantics slightly.
> This is reasonable on Sandy Bridge and later, but would
> cause additional problems on Nehalem and Westmere with
> their additional filters.
> 
> II) Simple disable any filtering for kernel space.
> This means interrupts in kernel space are reported as calls
> and on Nehalem/Westmere some indirect jumps are reported
> as calls too
> 
> III) Enumerate all the kernel entry points and check.
> Any bad call must have a kernel entry point as to.
> This seemed to fragile to maintain.
> 
> IV) Enumerate all kernel code and check for these ranges.
> Quite complicated, especially with the new kernel code JITs.
> Would also allow to probe for kernel code (defeating randomized kernel)

So why not do the same as we do for userspace? Copy MAX_INSN_SIZE bytes
and trap -EFAULT.

With Steven's recent NMI nesting stuff we should be able to take the fault and
do the fixup_exception() thing. Or alternatively we could software walk the
kernel pagetables.

