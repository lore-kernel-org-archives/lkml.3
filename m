Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3KHPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:42:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39012 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3KHPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:42:54 -0500
Message-ID: <527D05BA.3000008@ti.com>
Date: Fri, 8 Nov 2013 17:39:38 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 1/7] gpio: davinci: remove unnecessary printk
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com> <1383905510-31760-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1383905510-31760-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 12:11 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> the devm_*() helper prints error messages in case of
> errors no need to do the same in the driver.

Pls, drop it - devm_clk_get() doesn't always print error messages
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   drivers/gpio/gpio-davinci.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 84be701..7230c43 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -389,11 +389,9 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	}
>
>   	clk = devm_clk_get(dev, "gpio");
> -	if (IS_ERR(clk)) {
> -		printk(KERN_ERR "Error %ld getting gpio clock?\n",
> -		       PTR_ERR(clk));
> +	if (IS_ERR(clk))
>   		return PTR_ERR(clk);
> -	}
> +
>   	clk_prepare_enable(clk);
>
>   	/*
>

