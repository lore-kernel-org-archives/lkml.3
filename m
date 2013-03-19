Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab3CSInT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:43:19 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:38031 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964956Ab3CSInO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:43:14 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 19 Mar 2013 09:43:09 +0100
Subject: Re: [PATCH 4/5] pinctrl: ab8540: Staticize some symbols
Thread-Topic: [PATCH 4/5] pinctrl: ab8540: Staticize some symbols
Thread-Index: Ac4kfcjIzm6Nk29OQrmVLOePp4U3Yw==
Message-ID: <5148251D.8050802@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
 <1363674681-4015-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363674681-4015-4-git-send-email-sachin.kamat@linaro.org>
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

> Silences the following warnings:
> drivers/pinctrl/pinctrl-ab8540.c:302:28: warning:
> symbol 'ab8540_alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab8540.c:379:32: warning:
> symbol 'ab8540_gpio_irq_cluster' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>
> ---
>  drivers/pinctrl/pinctrl-ab8540.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/pinctrl-ab8540.c
> index 8ee1e8d..9867535 100644
> --- a/drivers/pinctrl/pinctrl-ab8540.c
> +++ b/drivers/pinctrl/pinctrl-ab8540.c
> @@ -299,7 +299,8 @@ static const struct abx500_function ab8540_functions[] = {
>   *
>   */
>  
> -struct alternate_functions ab8540_alternate_functions[AB8540_GPIO_MAX_NUMBER + 1] = {
> +static struct
> +alternate_functions ab8540_alternate_functions[AB8540_GPIO_MAX_NUMBER + 1] = {
>  	/* GPIOSEL1 - bit 4-7 reserved */
>  	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
>  	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
> @@ -376,7 +377,7 @@ static struct pullud ab8540_pullud = {
>   *	GPIO43 to GPIO44
>   *	GPIO51 to GPIO54
>   */
> -struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
> +static struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
>  	GPIO_IRQ_CLUSTER(43, 43, AB8540_INT_GPIO43F),
>  	GPIO_IRQ_CLUSTER(44, 44, AB8540_INT_GPIO44F),
>  	GPIO_IRQ_CLUSTER(51, 54, AB9540_INT_GPIO51R),



Acked-by: Patrice Chotard <patrice.chotard@st.com>