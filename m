Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3CSQZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:25:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3CSQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:25:39 -0400
Date: Tue, 19 Mar 2013 16:25:35 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>, Matt Porter <mporter@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [ 41/75] ARM: davinci: edma: fix dmaengine induced null pointer
 dereference on da830
Message-ID: <20130319162535.GG8398@hercules>
References: <20130318210510.203500214@linuxfoundation.org>
 <20130318210513.183706082@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318210513.183706082@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 02:07:04PM -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Matt Porter <mporter@ti.com>
> 
> commit 069552777a121eb39da29de4bc0383483dbe1f7e upstream.
> 
> This adds additional error checking to the private edma api implementation
> to catch the case where the edma_alloc_slot() has an invalid controller
> parameter. The edma dmaengine wrapper driver relies on this condition
> being handled in order to avoid setting up a second edma dmaengine
> instance on DA830.
> 
> Verfied using a DA850 with the second EDMA controller platform instance
> removed to simulate a DA830 which only has a single EDMA controller.
> 
> Reported-by: Tomas Novotny <tomas@novotny.cz>
> Signed-off-by: Matt Porter <mporter@ti.com>
> Tested-by: Tomas Novotny <tomas@novotny.cz>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/arm/mach-davinci/dma.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/arch/arm/mach-davinci/dma.c
> +++ b/arch/arm/mach-davinci/dma.c
> @@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
>   */
>  int edma_alloc_slot(unsigned ctlr, int slot)
>  {
> +	if (!edma_cc[ctlr])
> +		return -EINVAL;
> +
>  	if (slot >= 0)
>  		slot = EDMA_CHAN_SLOT(slot);

I couldn't figure out the reason why this is tagged for v3.7.x+ only.
Shouldn't this be applied to 3.2, 3.4 and 3.5 as well?

Cheers,
--
Luis
