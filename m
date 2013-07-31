Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3GaLXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:23:16 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:59332 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379Ab3GaLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:23:15 -0400
Message-ID: <51F8F0FA.1050200@st.com>
Date: Wed, 31 Jul 2013 12:11:54 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 1/2] pinctrl: st: Convert to use devm_ioremap_resource
References: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/13 05:22, Sachin Kamat wrote:
> devm_request_and_ioremap is deprecated. Use devm_ioremap_resource
> instead.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-st.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 04d4506..6246d7a 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1222,11 +1222,9 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>  	if (of_address_to_resource(np, 0, &res))
>  		return -ENODEV;
>  
> -	bank->base = devm_request_and_ioremap(dev, &res);
> -	if (!bank->base) {
> -		dev_err(dev, "Can't get IO memory mapping!\n");
> -		return -ENODEV;
> -	}
> +	bank->base = devm_ioremap_resource(dev, &res);
> +	if (IS_ERR(bank->base))
> +		return PTR_ERR(bank->base);
>  
>  	bank->gpio_chip = st_gpio_template;
>  	bank->gpio_chip.base = bank_num * ST_GPIO_PINS_PER_BANK;
> 
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

