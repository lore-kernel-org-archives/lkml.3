Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3KTLDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:03:39 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50274 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab3KTLDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:03:37 -0500
Date: Wed, 20 Nov 2013 16:33:20 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Document xol_area and arch_uprobe->insn/ixol
Message-ID: <20131120110320.GA22744@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131109190344.GA32281@redhat.com>
 <20131111084149.GC12405@gmail.com>
 <20131111195836.GA20615@redhat.com>
 <20131111210327.GG18886@gmail.com>
 <20131119162545.GA776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131119162545.GA776@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112011-5806-0000-0000-00002378E94E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> OK. Let me try to make a first step to improve this a little bit...
> 
> How about the patch below? Srikar?
> 
> 
> Subject: [PATCH] uprobes: Document xol_area and arch_uprobe->insn/ixol
> 
> Document xol_area and arch_uprobe.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

>  kernel/events/uprobes.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 51a7f53..b886a5e 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -73,6 +73,17 @@ struct uprobe {
>  	struct inode		*inode;		/* Also hold a ref to inode */
>  	loff_t			offset;
>  	unsigned long		flags;
> +
> +	/*
> +	 * The generic code assumes that it has two members of unknown type
> +	 * owned by the arch-specific code:
> +	 *
> +	 * 	insn -	copy_insn() saves the original instruction here for
> +	 *		arch_uprobe_analyze_insn().
> +	 *
> +	 *	ixol -	potentially modified instruction to execute out of
> +	 *		line, copied to xol_area by xol_get_insn_slot().
> +	 */
>  	struct arch_uprobe	arch;
>  };
> 
> @@ -86,6 +97,10 @@ struct return_instance {
>  };
> 
>  /*
> + * Execute out of line area: anonymous executable mapping installed
> + * by the probed task to execute the copy of the original instruction
> + * mangled by set_swbp().
> + *
>   * On a breakpoint hit, thread contests for a slot.  It frees the
>   * slot after singlestep. Currently a fixed number of slots are
>   * allocated.
> -- 
> 1.5.5.1
> 
> 

-- 
Thanks and Regards
Srikar Dronamraju

