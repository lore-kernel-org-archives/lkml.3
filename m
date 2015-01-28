Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbbA2CJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:09:34 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:54145 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbbA2CEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:04:01 -0500
X-IronPort-AV: E=Sophos;i="5.09,483,1418079600"; 
   d="scan'208";a="119087737"
Date: Wed, 28 Jan 2015 23:36:19 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Heena Sirwani <heenasirwani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: mite: Removed variables that
 is never used
In-Reply-To: <1422484584-9164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.DEB.2.02.1501282336070.2087@localhost6.localdomain6>
References: <1422484584-9164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Rickard Strandqvist wrote:

> Variable ar assigned a value that is never used.

The variable is lkar.

julia

> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/comedi/drivers/mite.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
> index ffc9e61..8d2903b 100644
> --- a/drivers/staging/comedi/drivers/mite.c
> +++ b/drivers/staging/comedi/drivers/mite.c
> @@ -494,9 +494,8 @@ EXPORT_SYMBOL_GPL(mite_bytes_read_from_memory_ub);
>  unsigned mite_dma_tcr(struct mite_channel *mite_chan)
>  {
>  	struct mite_struct *mite = mite_chan->mite;
> -	int lkar;
>  
> -	lkar = readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
> +	readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
>  	return readl(mite->mite_io_addr + MITE_TCR(mite_chan->channel));
>  }
>  EXPORT_SYMBOL_GPL(mite_dma_tcr);
> -- 
> 1.7.10.4
> 
> 
