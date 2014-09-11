Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaIKQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:27:16 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:29785 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbaIKQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:27:13 -0400
Message-ID: <5411CD5B.4080705@atmel.com>
Date: Thu, 11 Sep 2014 18:27:07 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@atmel.com>
Subject: Re: [PATCH] pinctrl: at91: disable Pull-Down or Pull-Up property
 before enabling Pull-Up or Pull-Down.
References: <1410446415-29410-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410446415-29410-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 16:40, Alexandre Belloni :
> From: Wenyou Yang <wenyou.yang@atmel.com>
> 
> Because the pin's Pull-Up and Pull-Down property is mutually exclusive.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Yes, indeed:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/pinctrl/pinctrl-at91.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index a3d8902438c7..ee9c0b7aad14 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -371,6 +371,9 @@ static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
>  
>  static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
>  {
> +	if (on)
> +		writel_relaxed(mask, pio + PIO_PPDDR);
> +
>  	writel_relaxed(mask, pio + (on ? PIO_PUER : PIO_PUDR));
>  }
>  
> @@ -499,6 +502,9 @@ static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
>  
>  static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
>  {
> +	if (is_on)
> +		__raw_writel(mask, pio + PIO_PUDR);
> +
>  	__raw_writel(mask, pio + (is_on ? PIO_PPDER : PIO_PPDDR));
>  }
>  
> 


-- 
Nicolas Ferre
