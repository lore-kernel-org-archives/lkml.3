Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaIXP7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:59:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47420 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaIXP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:59:37 -0400
Message-ID: <5422EA64.1070907@atmel.com>
Date: Wed, 24 Sep 2014 17:59:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@kernel.org>, <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] misc: atmel-ssc: prepare clock only when request
References: <1411551235-16502-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1411551235-16502-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2014 11:33, Bo Shen :
> Prepare SSC clock only when request SSC channel, the clock will be
> enabled when initialize the SSC.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

okay: it is the driver that uses the ssc that would enable the clock as
it is done in sound/soc/atmel/atmel_ssc_dai.c

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Bye,

> ---
> Send this patch to driver/misc maintainer as Mark Brown suggested.
> 
>  drivers/misc/atmel-ssc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> index 60843a2..f9807a7 100644
> --- a/drivers/misc/atmel-ssc.c
> +++ b/drivers/misc/atmel-ssc.c
> @@ -57,7 +57,7 @@ struct ssc_device *ssc_request(unsigned int ssc_num)
>  	ssc->user++;
>  	spin_unlock(&user_lock);
>  
> -	clk_prepare_enable(ssc->clk);
> +	clk_prepare(ssc->clk);
>  
>  	return ssc;
>  }
> @@ -77,7 +77,7 @@ void ssc_free(struct ssc_device *ssc)
>  	spin_unlock(&user_lock);
>  
>  	if (disable_clk)
> -		clk_disable_unprepare(ssc->clk);
> +		clk_unprepare(ssc->clk);
>  }
>  EXPORT_SYMBOL(ssc_free);
>  
> 


-- 
Nicolas Ferre
