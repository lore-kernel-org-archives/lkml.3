Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3BENLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:11:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47102 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3BENLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:11:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] spi: make sure all transfer has proper speed set
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com>
References: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com>
Date: Tue, 05 Feb 2013 13:11:22 +0000
Message-Id: <20130205131122.8C84A3E0E27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2013 00:17:14 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> When spi client does the spi transfer and if it does not set
> the speed for each transfer then set it as default
> of spi device in spi core before calling low level transfer.
> 
> This will remove the extra check in low level driver for setting
> speed.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 19ee901..9676a29 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1366,12 +1366,14 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
>  	}
>  
>  	/**
> -	 * Set transfer bits_per_word as spi device default if it is not
> -	 * set for this transfer.
> +	 * Set transfer bits_per_word and max speed as spi device default if
> +	 * it is not set for this transfer.
>  	 */
>  	list_for_each_entry(xfer, &message->transfers, transfer_list) {
>  		if (!xfer->bits_per_word)
>  			xfer->bits_per_word = spi->bits_per_word;
> +		if (!xfer->speed_hz)
> +			xfer->speed_hz = spi->max_speed_hz;
>  	}
>  
>  	message->spi = spi;
> -- 
> 1.7.1.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
