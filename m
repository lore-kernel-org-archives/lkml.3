Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3JRWnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:43:40 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48339
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757067Ab3JRWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:43:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382136213.7979.908.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 2/6] powerpc/book3e: store critical/machine/debug
 exception thread info
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 17:43:33 -0500
In-Reply-To: <1371724110-8250-3-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-3-git-send-email-tiejun.chen@windriver.com>
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
> We need to store thread info to these exception thread info like something
> we already did for PPC32.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 4d8e57f..07cf657 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -67,6 +67,18 @@
>  	std	r10,PACA_##level##_STACK(r13);
>  #endif
>  
> +/* Store something to exception thread info */
> +#define	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(type)					\
> +	ld	r14,PACAKSAVE(r13);						\
> +	CURRENT_THREAD_INFO(r14, r14);						\
> +	CURRENT_THREAD_INFO(r15, r1);						\
> +	ld	r10,TI_FLAGS(r14);		     				\
> +	std	r10,TI_FLAGS(r15);			     			\
> +	ld	r10,TI_PREEMPT(r14);		     				\
> +	std	r10,TI_PREEMPT(r15);		     				\
> +	ld	r10,TI_TASK(r14);			     			\
> +	std	r10,TI_TASK(r15);

Where is "type" used?

BTW, no need for a BOOK3E prefix for things local to this file.

-Scott



