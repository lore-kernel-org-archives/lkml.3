Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3JRXz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:55:28 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:47540
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab3JRXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:55:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI936eI1432I168aJzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382140519.7979.936.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 1/6] powerpc/book3e: load critical/machine/debug
 exception stack
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 18:55:19 -0500
In-Reply-To: <1371724110-8250-2-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-2-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
> We always alloc critical/machine/debug check exceptions. This is
> different from the normal exception. So we should load these exception
> stack properly like we did for booke.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |   49 +++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 4b23119..4d8e57f 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -36,6 +36,37 @@
>   */
>  #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
>  
> +/* only on book3e */
> +#define DBG_STACK_BASE		dbgirq_ctx
> +#define MC_STACK_BASE		mcheckirq_ctx
> +#define CRIT_STACK_BASE		critirq_ctx
> +
> +#ifdef CONFIG_RELOCATABLE
> +#define LOAD_STACK_BASE(reg, level)			\
> +	tovirt(r2,r2);					\
> +	LOAD_REG_ADDR(reg, level##_STACK_BASE);

Where does r2 come from here, where does it get used, and why do we need
tovirt() on book3e?

-Scott



