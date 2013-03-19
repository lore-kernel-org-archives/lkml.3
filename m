Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab3CSInG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:43:06 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:53486 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab3CSInD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:43:03 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 19 Mar 2013 09:42:58 +0100
Subject: Re: [PATCH 3/5] pinctrl: ab9540: Staticize some symbols
Thread-Topic: [PATCH 3/5] pinctrl: ab9540: Staticize some symbols
Thread-Index: Ac4kfcH65RVK3BfbRT2h3+50eExPnw==
Message-ID: <51482512.4050405@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
 <1363674681-4015-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363674681-4015-3-git-send-email-sachin.kamat@linaro.org>
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

> Fixes the following warnings:
> drivers/pinctrl/pinctrl-ab9540.c:382:28: warning:
> symbol 'ab9540alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab9540.c:457:32: warning:
> symbol 'ab9540_gpio_irq_cluster' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>
> ---
>  drivers/pinctrl/pinctrl-ab9540.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
> index 7610bd0..27835ce 100644
> --- a/drivers/pinctrl/pinctrl-ab9540.c
> +++ b/drivers/pinctrl/pinctrl-ab9540.c
> @@ -379,7 +379,8 @@ static const struct abx500_function ab9540_functions[] = {
>   *	alt_A	|       1       |          0          |          0
>   */
>  
> -struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1] = {
> +static struct
> +alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1] = {
>  	/* GPIOSEL1 - bits 4-7 are reserved */
>  	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
>  	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
> @@ -454,7 +455,7 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
>  	ALTERNATE_FUNCTIONS(54,	     5, UNUSED, UNUSED, 0, 0, 0), /* GPIO54 = GPIO60, altA controlled by bit 5 */
>  };
>  
> -struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
> +static struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
>  	GPIO_IRQ_CLUSTER(10, 13, AB8500_INT_GPIO10R),
>  	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
>  	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),


Fyi, don't use my stericsson email address as it has been disabled.

Acked-by: Patrice Chotard <patrice.chotard@st.com>