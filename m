Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995Ab3FTIdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:33:35 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41060 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3FTIdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:33:32 -0400
Date: Thu, 20 Jun 2013 10:33:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jed Davis <jld@mozilla.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: arm64: Record the user-mode PC in the call chain.
Message-ID: <20130620083327.GA5288@gmail.com>
References: <20130620030713.GA27428@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620030713.GA27428@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jed Davis <jld@mozilla.com> wrote:

> With this change, we no longer lose the innermost entry in the user-mode
> part of the call chain.  See also the x86 port, which includes the ip,
> and the corresponding change in arch/arm.
> 
> Signed-off-by: Jed Davis <jld@mozilla.com>
> ---
>  arch/arm64/kernel/perf_event.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 1e49e5eb..9ba33c4 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -1336,6 +1336,7 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
>  		return;
>  	}
>  
> +	perf_callchain_store(entry, regs->pc);
>  	tail = (struct frame_tail __user *)regs->regs[29];
>  
>  	while (entry->nr < PERF_MAX_STACK_DEPTH &&

Acked-by: Ingo Molnar <mingo@kernel.org>

I suspect this goes to v3.10 via the ARM64 tree?

Thanks,

	Ingo
