Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaETKdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:33:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39412 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaETKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:33:12 -0400
Message-ID: <537B2F16.6030504@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 16:01:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/powernv: Fix build error when CONFIG_SMP=n
References: <1400579726-26206-1-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1400579726-26206-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052010-3568-0000-0000-00000584A81A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 03:25 PM, Shreyas B. Prabhu wrote:
> Fix the following build error when compiled with CONFIG_SMP=n
> arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
> arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’ [-Werror=implicit-function-declaration]
>     rc = opal_query_cpu_status(get_hard_smp_processor_id(i),
> 
> The usage of get_hard_smp_processor_id() needs the declaration from <asm/smp.h>.
> The file setup.c includes <linux/sched.h>, which in-turn includes <linux/smp.h>.
> However, <linux/smp.h> includes <asm/smp.h> only on SMP configs and hence UP
> builds fail. Fix this by directly including <asm/smp.h> in setup.c
> unconditionally.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  arch/powerpc/platforms/powernv/setup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 8723d32..e6bde98 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -34,6 +34,7 @@
>  #include <asm/rtas.h>
>  #include <asm/opal.h>
>  #include <asm/kexec.h>
> +#include <asm/smp.h>
> 
>  #include "powernv.h"
> 

