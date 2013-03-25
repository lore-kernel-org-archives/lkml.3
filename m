Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3CYE3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:29:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32123 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3CYE3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:29:15 -0400
X-Spam-Score: -100.8
Message-ID: <514FD27B.6050706@asianux.com>
Date: Mon, 25 Mar 2013 12:28:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, michael@ellerman.id.au,
        dhowells@redhat.com, geoff@infradead.org,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Michael Neuling <mikey@neuling.org>
CC: linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC:kernel: section mismatch from smp_release_cpus
 to __initdata spinning_secondaries
References: <51495774.9080809@asianux.com>
In-Reply-To: <51495774.9080809@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  could you help check this patch whether is ok ?

  thanks.


On 2013年03月20日 14:30, Chen Gang wrote:
> 
>   the smp_release_cpus is a normal funciton and called in normal environments,
>   but it calls the __initdata spinning_secondaries.
>   need modify spinning_secondaries to match smp_release_cpus.
> 
> the related warning:
>   (the linker report boot_paca.33377, but it should be spinning_secondaries)
> 
> -----------------------------------------------------------------------------
> 
> WARNING: arch/powerpc/kernel/built-in.o(.text+0x23176): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
> The function .smp_release_cpus() references
> the variable __initdata boot_paca.33377.
> This is often because .smp_release_cpus lacks a __initdata 
> annotation or the annotation of boot_paca.33377 is wrong.
> 
> WARNING: arch/powerpc/kernel/built-in.o(.text+0x231fe): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
> The function .smp_release_cpus() references
> the variable __initdata boot_paca.33377.
> This is often because .smp_release_cpus lacks a __initdata 
> annotation or the annotation of boot_paca.33377 is wrong.
> 
> -----------------------------------------------------------------------------
> 
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/powerpc/kernel/setup_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index 75fbaceb..e8a2f2e 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -76,7 +76,7 @@
>  #endif
>  
>  int boot_cpuid = 0;
> -int __initdata spinning_secondaries;
> +int spinning_secondaries;
>  u64 ppc64_pft_size;
>  
>  /* Pick defaults since we might want to patch instructions
> 


-- 
Chen Gang

Asianux Corporation
