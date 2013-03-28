Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3C1PpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:45:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:32089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3C1PpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,927,1355126400"; 
   d="scan'208";a="285839313"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] perf: Enable function tracing for perf core
References: <1362785086-12901-1-git-send-email-andi@firstfloor.org>
Date: Thu, 28 Mar 2013 08:45:08 -0700
In-Reply-To: <1362785086-12901-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 8 Mar 2013 15:24:46 -0800")
Message-ID: <m2y5d7h6kb.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> According to Steven R. there is no reason left to not support
> function tracing for the perf core. This makes it easier to debug
> perf.
>
> Don't remove -pg for the x86 and generic perf core.

Ping! patch is missing review.


>
> Cc: rostedt@goodmis.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/Makefile |    1 -
>  kernel/events/Makefile       |    4 ----
>  2 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index a0e067d..8eb5d28 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -5,7 +5,6 @@
>  # Don't trace early stages of a secondary CPU boot
>  ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_common.o = -pg
> -CFLAGS_REMOVE_perf_event.o = -pg
>  endif
>  
>  # Make sure load_percpu_segment has no stackprotector
> diff --git a/kernel/events/Makefile b/kernel/events/Makefile
> index 103f5d1..a630994 100644
> --- a/kernel/events/Makefile
> +++ b/kernel/events/Makefile
> @@ -1,7 +1,3 @@
> -ifdef CONFIG_FUNCTION_TRACER
> -CFLAGS_REMOVE_core.o = -pg
> -endif
> -
>  obj-y := core.o ring_buffer.o callchain.o
>  
>  obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o

-- 
ak@linux.intel.com -- Speaking for myself only
