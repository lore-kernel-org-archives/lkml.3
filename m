Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab3CSIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:41:48 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:53679 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab3CSIlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:41:46 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 19 Mar 2013 09:41:37 +0100
Subject: Re: [PATCH 2/5] pinctrl: ab8500: Staticize some symbols
Thread-Topic: [PATCH 2/5] pinctrl: ab8500: Staticize some symbols
Thread-Index: Ac4kfZGpy0G7P3WBTI2aUjZHcTHpjQ==
Message-ID: <514824C1.8040306@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
 <1363674681-4015-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363674681-4015-2-git-send-email-sachin.kamat@linaro.org>
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

> These symbols are used only in this file. Silences the following
> warnings:
> drivers/pinctrl/pinctrl-ab8500.c:392:28: warning:
> symbol 'ab8500_alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab8500.c:458:32: warning:
> symbol 'ab8500_gpio_irq_cluster' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>
> ---
>  drivers/pinctrl/pinctrl-ab8500.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
> index 3b471d8..2ac2d0a 100644
> --- a/drivers/pinctrl/pinctrl-ab8500.c
> +++ b/drivers/pinctrl/pinctrl-ab8500.c
> @@ -389,7 +389,8 @@ static const struct abx500_function ab8500_functions[] = {
>   *	alt_A	|       1       |          0          |          0
>   */
>  
> -struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1] = {
> +static struct
> +alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1] = {
>  	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
>  	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
>  	ALTERNATE_FUNCTIONS(2,      1, UNUSED, UNUSED, 0, 0, 0), /* GPIO2, altA controlled by bit 1 */
> @@ -455,7 +456,7 @@ struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1
>   *	GPIO24 and GPIO25
>   *	GPIO36 to GPIO41
>   */
> -struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
> +static struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
>  	GPIO_IRQ_CLUSTER(6,  13, AB8500_INT_GPIO6R),
>  	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
>  	GPIO_IRQ_CLUSTER(36, 41, AB8500_INT_GPIO36R),


Acked-by: Patrice Chotard <patrice.chotard@st.com>