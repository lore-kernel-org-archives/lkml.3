Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbaIIL10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:27:26 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56124 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaIIL1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:27:25 -0400
Message-ID: <540EE41A.2070807@linaro.org>
Date: Tue, 09 Sep 2014 12:27:22 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH v2] pinctrl: st: remove gpiochip in failure cases
References: <1410249101-12234-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1410249101-12234-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


On 09/09/14 08:51, Pramod Gurav wrote:
> This patch releases gpiochip related resources by calling
> gpiochip_remove when gpiochip_irqchip_add fails.
>
> CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>
> CC: Maxime Coquelin <maxime.coquelin@st.com>
> CC: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
> Changes since v1:
> Dropped adding remove function as it will never be tested as
> the driver is bool.
>
>   drivers/pinctrl/pinctrl-st.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 5475374..af2f589 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1517,6 +1517,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>   					   0, handle_simple_irq,
>   					   IRQ_TYPE_LEVEL_LOW);
>   		if (err) {
> +			gpiochip_remove(&bank->gpio_chip);
>   			dev_info(dev, "could not add irqchip\n");
>   			return err;
>   		}
>
