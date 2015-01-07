Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbbAGPJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:09:25 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:47316 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbbAGPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:09:22 -0500
Message-ID: <54AD4C1C.60505@akamai.com>
Date: Wed, 07 Jan 2015 10:09:16 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "mmarek@suse.cz" <mmarek@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] powerpc: Include linux/jump_label.h to get HAVE_JUMP_LABEL
 define
References: <1420626958-31254-1-git-send-email-anton@samba.org> <1420626958-31254-3-git-send-email-anton@samba.org>
In-Reply-To: <1420626958-31254-3-git-send-email-anton@samba.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 05:35 AM, Anton Blanchard wrote:
> Commit 1bc9e47aa8e4 ("powerpc/jump_label: Use HAVE_JUMP_LABEL")
> converted uses of CONFIG_JUMP_LABEL to HAVE_JUMP_LABEL in
> some assembly files.
>
> HAVE_JUMP_LABEL is defined in linux/jump_label.h, so we need to
> include this or we always get the non jump label fallback code.
>
> Fixes: 1bc9e47aa8e4 ("powerpc/jump_label: Use HAVE_JUMP_LABEL")
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>  arch/powerpc/platforms/powernv/opal-wrappers.S | 2 +-
>  arch/powerpc/platforms/pseries/hvCall.S        | 2 +-
>  arch/powerpc/platforms/pseries/lpar.c          | 1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
> index 0509bca..fcbe899 100644
> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
> @@ -9,11 +9,11 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> +#include <linux/jump_label.h>
>  #include <asm/ppc_asm.h>
>  #include <asm/hvcall.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/opal.h>
> -#include <asm/jump_label.h>
>  
>  	.section	".text"
>  
> diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
> index ccd53f9..74b5b8e 100644
> --- a/arch/powerpc/platforms/pseries/hvCall.S
> +++ b/arch/powerpc/platforms/pseries/hvCall.S
> @@ -7,12 +7,12 @@
>   * as published by the Free Software Foundation; either version
>   * 2 of the License, or (at your option) any later version.
>   */
> +#include <linux/jump_label.h>
>  #include <asm/hvcall.h>
>  #include <asm/processor.h>
>  #include <asm/ppc_asm.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/ptrace.h>
> -#include <asm/jump_label.h>
>  
>  	.section	".text"
>  	
> diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
> index 469751d..14ac1ad 100644
> --- a/arch/powerpc/platforms/pseries/lpar.c
> +++ b/arch/powerpc/platforms/pseries/lpar.c
> @@ -27,6 +27,7 @@
>  #include <linux/console.h>
>  #include <linux/export.h>
>  #include <linux/static_key.h>
> +#include <linux/jump_label.h>
>  #include <asm/processor.h>
>  #include <asm/mmu.h>
>  #include <asm/page.h>

You can drop the 'static_key.h' include here since its redundant.

Thanks,

-Jason

