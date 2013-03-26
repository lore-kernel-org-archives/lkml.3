Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3CZMMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:12:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37967 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab3CZMMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:12:37 -0400
Date: Tue, 26 Mar 2013 17:37:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, oleg@redhat.com,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: remove additional trap
 instruction check
Message-ID: <20130326120739.GD20399@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130322151627.GB20010@in.ibm.com>
 <20130322151946.GE20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130322151946.GE20010@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-9360-0000-0000-0000117975AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli <ananth@in.ibm.com> [2013-03-22 20:49:46]:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> prepare_uprobe() already checks if the underlying unstruction
> (on file) is a trap variant. We don't need to check this again.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/powerpc/kernel/uprobes.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> Index: linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
> ===================================================================
> --- linux-3.9-rc3.orig/arch/powerpc/kernel/uprobes.c
> +++ linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
> @@ -53,12 +53,6 @@ int arch_uprobe_analyze_insn(struct arch
>  	if (addr & 0x03)
>  		return -EINVAL;
> 
> -	/*
> -	 * We currently don't support a uprobe on an already
> -	 * existing breakpoint instruction underneath
> -	 */
> -	if (is_trap(auprobe->ainsn))
> -		return -ENOTSUPP;
>  	return 0;
>  }
> 

-- 
Thanks and Regards
Srikar Dronamraju

