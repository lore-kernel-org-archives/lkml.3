Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3GWPzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:55:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26834 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab3GWPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:55:47 -0400
Date: Tue, 23 Jul 2013 11:55:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Wang <jasowang@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/4] xen: switch to use hypervisor_cpuid_base()
Message-ID: <20130723155504.GA5328@phenom.dumpdata.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
 <1374572465-15278-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374572465-15278-2-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:41:03PM +0800, Jason Wang wrote:
> Switch to use hypervisor_cpuid_base() to detect Xen.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: xen-devel@lists.xensource.com
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/include/asm/xen/hypervisor.h |   16 +---------------
>  1 files changed, 1 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
> index 125f344..d866959 100644
> --- a/arch/x86/include/asm/xen/hypervisor.h
> +++ b/arch/x86/include/asm/xen/hypervisor.h
> @@ -40,21 +40,7 @@ extern struct start_info *xen_start_info;
>  
>  static inline uint32_t xen_cpuid_base(void)
>  {
> -	uint32_t base, eax, ebx, ecx, edx;
> -	char signature[13];
> -
> -	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> -		cpuid(base, &eax, &ebx, &ecx, &edx);
> -		*(uint32_t *)(signature + 0) = ebx;
> -		*(uint32_t *)(signature + 4) = ecx;
> -		*(uint32_t *)(signature + 8) = edx;
> -		signature[12] = 0;
> -
> -		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> -			return base;
> -	}
> -
> -	return 0;
> +	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
>  }
>  
>  #ifdef CONFIG_XEN
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
