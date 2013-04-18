Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935407Ab3DRAC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:02:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:47518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3DRAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:02:27 -0400
Message-ID: <516F37FF.8040703@infradead.org>
Date: Wed, 17 Apr 2013 17:02:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: [patch] x86, kvm: fix build failure with CONFIG_SMP disabled
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au> <516EE5AB.4080201@infradead.org> <alpine.DEB.2.02.1304171555030.10112@chino.kir.corp.google.com> <alpine.DEB.2.02.1304171609580.5541@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304171609580.5541@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/13 16:12, David Rientjes wrote:
> The build fails when CONFIG_SMP is disabled:
> 
> 	arch/x86/kvm/vmx.c: In function 'vmx_deliver_posted_interrupt':
> 	arch/x86/kvm/vmx.c:3950:3: error: 'apic' undeclared (first use in this function)
> 
> Fix it by including the necessary header.

Sorry, i386 build still fails with the same error message plus this one:

ERROR: "apic" [arch/x86/kvm/kvm-intel.ko] undefined!


> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/kvm/vmx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -34,6 +34,7 @@
>  #include "kvm_cache_regs.h"
>  #include "x86.h"
>  
> +#include <asm/apic.h>
>  #include <asm/io.h>
>  #include <asm/desc.h>
>  #include <asm/vmx.h>
> --


-- 
~Randy
