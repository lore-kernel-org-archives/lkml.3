Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3JUQbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:31:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26843 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3JUQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:31:00 -0400
Date: Mon, 21 Oct 2013 12:30:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, gleb@redhat.com,
        pbonzini@redhat.com, tglx@linutronix.de, linux@eikelenboom.it,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86 kconfig: Add recommendation to enable paravirt
 spinlock
Message-ID: <20131021163038.GA17709@phenom.dumpdata.com>
References: <n>
 <1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 09:35:08PM +0530, Raghavendra K T wrote:
> Since paravirt spinlock optimization are in 3.12 kernel, we have
> very good performance benefit for paravirtualized KVM / Xen kernel.
> Also we no longer suffer from 5% side effect on native kernel.

Yeey!
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  Would like to thank Sander for spotting and suggesting this.
>  pvspinlock benefit on KVM link: https://lkml.org/lkml/2013/8/6/178 
>  
>  Attilio's tests on native kernel impact:
>  http://blog.xen.org/index.php/2012/05/11/benchmarking-the-new-pv-ticketlock-implementation/
> 
>  arch/x86/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f67e839..4ba9d32 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -638,10 +638,10 @@ config PARAVIRT_SPINLOCKS
>  	  spinlock implementation with something virtualization-friendly
>  	  (for example, block the virtual CPU rather than spinning).
>  
> -	  Unfortunately the downside is an up to 5% performance hit on
> -	  native kernels, with various workloads.
> +	  It has minimal impact on native kernels and gives nice performance
> +	  benefit for paravirtualized KVM / Xen kernels.
>  
> -	  If you are unsure how to answer this question, answer N.
> +	  If you are unsure how to answer this question, answer Y.
>  
>  source "arch/x86/xen/Kconfig"
>  
> -- 
> 1.7.11.7
> 
