Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161061Ab3BGS2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:28:55 -0500
Received: from [213.199.154.139] ([213.199.154.139]:20192 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758690Ab3BGS2y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:28:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1155h)
Date: Thu, 7 Feb 2013 12:27:29 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] mpic: fix Destination Registers init problem
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1360224420-5009-1-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1360224420-5009-1-git-send-email-chenhui.zhao@freescale.com>
	(from chenhui.zhao@freescale.com on Thu Feb  7 02:07:00 2013)
X-Mailer: Balsa 2.4.11
Message-ID: <1360261649.27002.5@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 02:07:00 AM, Zhao Chenhui wrote:
> The Freescale implementation of the MPIC only allows a single CPU
> destination for non-IPI interrupts. Test the flag MPIC_SINGLE_DEST_CPU
> to check if the Destination registers should be set.
> 
> This prevents more than one bit is set at secondary processors
> initilizing time if the flag MPIC_SINGLE_DEST_CPU is set.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
>  arch/powerpc/sysdev/mpic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 9c6e535..cc537f8 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -1675,7 +1675,7 @@ void mpic_setup_this_cpu(void)
>  	 * it differently, then we should make sure we also change the  
> default
>  	 * values of irq_desc[].affinity in irq.c.
>   	 */
> -	if (distribute_irqs) {
> +	if (distribute_irqs && !(mpic->flags & MPIC_SINGLE_DEST_CPU)) {
>  	 	for (i = 0; i < mpic->num_sources ; i++)
>  			mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION),
>  				mpic_irq_read(i,  
> MPIC_INFO(IRQ_DETINATION)) | msk);

http://patchwork.ozlabs.org/patch/211454/

-Scott
