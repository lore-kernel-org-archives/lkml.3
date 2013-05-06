Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3EFO6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:58:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49789 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3EFO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:58:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,622,1363132800"; 
   d="scan'208";a="22393948"
Date: Mon, 6 May 2013 15:57:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 4/4] xen/spinlock: Fix check from greater than to be also
 be greater or equal to.
In-Reply-To: <1367845498-14290-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1305061557440.4756@kaball.uk.xensource.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com> <1367845498-14290-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Konrad Rzeszutek Wilk wrote:
> During review of git commit cb9c6f15f318aa3aeb62fe525aa5c6dcf6eee159
> ("xen/spinlock:  Check against default value of -1 for IRQ line.")
> Stefano pointed out a bug in the patch. Unfortunatly due to vacation
> timing the fix was not applied and this patch fixes it up.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/spinlock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 8b54603..3002ec1 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -364,7 +364,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  	int irq;
>  	const char *name;
>  
> -	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
> +	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
>  	     cpu, per_cpu(lock_kicker_irq, cpu));
>  
>  	/*
> -- 
> 1.8.1.4
> 
