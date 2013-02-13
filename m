Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab3BMQaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:30:30 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:37481 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759377Ab3BMQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:30:29 -0500
Message-ID: <511BBFC4.7090601@xenotime.net>
Date: Wed, 13 Feb 2013 08:31:00 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] fix 32-bit compile warning from printk()
References: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
In-Reply-To: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/13 11:19, Dave Hansen wrote:
> My patch "Fix kvm's use of __pa() on percpu areas" introduced a
> compile warning:
> 
> arch/x86/kernel/kvm.c: In function 'kvm_register_steal_time':
> arch/x86/kernel/kvm.c:302:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]
> 
> According to: Documentation/printk-formats.txt
> 
> 	If <type> is dependent on a config option for its size
> 	(e.g., phys_addr_t) ... use a format specifier of its
> 	largest possible type and explicitly cast to it.
> 
> So, we'll do just that.  We will consider it an unsigned long
> long, and cast to it explicitly.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

This warning is still present in linux-next (20130213).

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

Someone please merge...  (kvm@ cc added)

> ---
> 
>  linux-2.6.git-dave/arch/x86/kernel/kvm.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN arch/x86/kernel/kvm.c~fix-32-bit-compile-warning arch/x86/kernel/kvm.c
> --- linux-2.6.git/arch/x86/kernel/kvm.c~fix-32-bit-compile-warning	2013-01-28 11:16:39.786938232 -0800
> +++ linux-2.6.git-dave/arch/x86/kernel/kvm.c	2013-01-28 11:16:39.790938273 -0800
> @@ -298,8 +298,8 @@ static void kvm_register_steal_time(void
>  	memset(st, 0, sizeof(*st));
>  
>  	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
> -		cpu, slow_virt_to_phys(st));
> +	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %llx\n",
> +		cpu, (unsigned long long)slow_virt_to_phys(st));
>  }
>  
>  static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> _



-- 
~Randy
