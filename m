Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3JRW64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:58:56 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:45242
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab3JRW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:58:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI936eI1432I853kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382137119.7979.916.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 4/6] powerpc/book3e: support kgdb for kernel space
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 17:58:39 -0500
In-Reply-To: <1371724110-8250-5-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-5-git-send-email-tiejun.chen@windriver.com>
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
> Currently we need to skip this for supporting KGDB.

Does it need to depend on CONFIG_KGDB?  Either you've fixed the "can't
quite save properly" part, or you haven't.

-Scott

> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 07cf657..a286b51 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -639,11 +639,13 @@ kernel_dbg_exc:
>  	rfdi
>  
>  	/* Normal debug exception */
> +1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
> +#ifndef CONFIG_KGDB
>  	/* XXX We only handle coming from userspace for now since we can't
>  	 *     quite save properly an interrupted kernel state yet
>  	 */
> -1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
>  	beq	kernel_dbg_exc;		/* if from kernel mode */
> +#endif
>  
>  	/* Now we mash up things to make it look like we are coming on a
>  	 * normal exception



