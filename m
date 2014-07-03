Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbaGCRxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:53:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59997 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbaGCRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:53:33 -0400
Date: Thu, 3 Jul 2014 18:53:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Sneha Priya <sneha.cse@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 1/3] ARM: perf: Check that current->mm is alive before
 getting user callchain
Message-ID: <20140703175306.GG17372@arm.com>
References: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
 <1403881067-22690-2-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403881067-22690-2-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 03:57:45PM +0100, Jean Pihet wrote:
> An event may occur when an mm is already released.
> 
> As per commit 20afc60f892d285fde179ead4b24e6a7938c2f1b
>  'x86, perf: Check that current->mm is alive before getting user callchain'
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> ---

Acked-by: Will Deacon <will.deacon@arm.com>

>  arch/arm/kernel/perf_event.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 4238bcb..6493c4c 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -590,6 +590,10 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
>  	}
>  
>  	perf_callchain_store(entry, regs->ARM_pc);
> +
> +	if (!current->mm)
> +		return;
> +
>  	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
>  
>  	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
> -- 
> 1.8.1.2
> 
> 
