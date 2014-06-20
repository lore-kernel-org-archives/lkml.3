Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967039AbaFTLit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:38:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40410 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645AbaFTLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:38:47 -0400
Message-ID: <53A41D43.3010907@linaro.org>
Date: Fri, 20 Jun 2014 12:38:43 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: kernel@stlinux.com, patrice.chotard@st.com
Subject: Re: [PATCH] pinctrl: st: Fix irqmux handler
References: <1403264094-16140-1-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1403264094-16140-1-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/06/14 12:34, Maxime COQUELIN wrote:
> st_gpio_irqmux_handler() reads the status register to find out
> which banks inside the controller have pending IRQs.
> For each banks having pending IRQs, it calls the corresponding handler.
>
> Problem is that current code restricts the number of possible banks inside the
> controller to ST_GPIO_PINS_PER_BANK. This define represents the number of pins
> inside a bank, so it shouldn't be used here.
You are right.
Good find.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


>
> On STiH407, PIO_FRONT0 controller has 10 banks, so IRQs pending in the two
> last banks (PIO18 & PIO19) aren't handled.
>
> This patch replace ST_GPIO_PINS_PER_BANK by the number of banks inside the
> controller.
>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: <stable@vger.kernel.org> #v3.15+
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>   drivers/pinctrl/pinctrl-st.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 1bd6363bc9..9f43916 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1431,7 +1431,7 @@ static void st_gpio_irqmux_handler(unsigned irq, struct irq_desc *desc)
>
>   	status = readl(info->irqmux_base);
>
> -	for_each_set_bit(n, &status, ST_GPIO_PINS_PER_BANK)
> +	for_each_set_bit(n, &status, info->nbanks)
>   		__gpio_irq_handler(&info->banks[n]);
>
>   	chained_irq_exit(chip, desc);
>
