Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab3CSI2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:28:47 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:48692 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964921Ab3CSI2p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:28:45 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 19 Mar 2013 09:28:26 +0100
Subject: Re: [PATCH 1/5] pinctrl: abx500: Staticize some symbols
Thread-Topic: [PATCH 1/5] pinctrl: abx500: Staticize some symbols
Thread-Index: Ac4ke7o8egAX+SmaR7qC59tv9CtLig==
Message-ID: <514821AA.2060201@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 07:31 AM, Sachin Kamat wrote:

> These symbols are used only in this file. Without this patch
> we get the following warnings:
> drivers/pinctrl/pinctrl-abx500.c:520:5: warning:
> symbol 'abx500_gpio_request' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:527:6: warning:
> symbol 'abx500_gpio_free' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:614:5: warning:
> symbol 'abx500_gpio_request_enable' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:714:5: warning:
> symbol 'abx500_pin_config_get' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-abx500.c:721:5: warning:
> symbol 'abx500_pin_config_set' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> ---
> This series is compile tested against linux-next tree (20130319).
> ---
>  drivers/pinctrl/pinctrl-abx500.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
> index 0cf3fa4..9b8db91 100644
> --- a/drivers/pinctrl/pinctrl-abx500.c
> +++ b/drivers/pinctrl/pinctrl-abx500.c
> @@ -517,14 +517,14 @@ static inline void abx500_gpio_dbg_show_one(struct seq_file *s,
>  #define abx500_gpio_dbg_show	NULL
>  #endif
>  
> -int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
> +static int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
>  {
>  	int gpio = chip->base + offset;
>  
>  	return pinctrl_request_gpio(gpio);
>  }
>  
> -void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
> +static void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
>  {
>  	int gpio = chip->base + offset;
>  
> @@ -611,7 +611,7 @@ static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
>  	dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
>  }
>  
> -int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
> +static int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
>  			       struct pinctrl_gpio_range *range,
>  			       unsigned offset)
>  {
> @@ -711,14 +711,14 @@ static const struct pinctrl_ops abx500_pinctrl_ops = {
>  	.pin_dbg_show = abx500_pin_dbg_show,
>  };
>  
> -int abx500_pin_config_get(struct pinctrl_dev *pctldev,
> +static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
>  			  unsigned pin,
>  			  unsigned long *config)
>  {
>  	return -ENOSYS;
>  }
>  
> -int abx500_pin_config_set(struct pinctrl_dev *pctldev,
> +static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>  			  unsigned pin,
>  			  unsigned long config)
>  {


Acked-by: Patrice Chotard <patrice.chotard@st.com>