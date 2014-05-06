Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbaEFP5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:57:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12576 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaEFP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:57:42 -0400
Message-ID: <53690672.8050708@atmel.com>
Date: Tue, 6 May 2014 17:57:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH] spi: atmel: fix incorrect comparison
References: <1399391081-16095-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399391081-16095-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 17:44, Alexandre Belloni :
> Found using smatch:
> drivers/spi/spi-atmel.c:878 atmel_spi_pump_pio_data() warn: unsigned
> 'as->current_remaining_bytes' is never less than zero.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Yes as the variable is declared as unsigned:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
>  drivers/spi/spi-atmel.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 079e6b1b0cdb..39417fd8462f 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -874,8 +874,9 @@ atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
>  		spi_readl(as, RDR);
>  	}
>  	if (xfer->bits_per_word > 8) {
> -		as->current_remaining_bytes -= 2;
> -		if (as->current_remaining_bytes < 0)
> +		if (as->current_remaining_bytes > 2)
> +			as->current_remaining_bytes -= 2;
> +		else
>  			as->current_remaining_bytes = 0;
>  	} else {
>  		as->current_remaining_bytes--;
> 


-- 
Nicolas Ferre
