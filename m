Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984Ab3CSIn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:43:27 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:33934 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964956Ab3CSInV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:43:21 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 19 Mar 2013 09:43:16 +0100
Subject: Re: [PATCH 5/5] pinctrl: ab8505: Staticize some symbols
Thread-Topic: [PATCH 5/5] pinctrl: ab8505: Staticize some symbols
Thread-Index: Ac4kfczJryanxXE0TeeZmRZyraZ8oQ==
Message-ID: <51482524.10605@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
 <1363674681-4015-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363674681-4015-5-git-send-email-sachin.kamat@linaro.org>
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
> drivers/pinctrl/pinctrl-ab8505.c:274:28: warning:
> symbol 'ab8505_alternate_functions' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-ab8505.c:351:32: warning:
> symbol 'ab8505_gpio_irq_cluster' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@stericsson.com>
> ---
>  drivers/pinctrl/pinctrl-ab8505.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/pinctrl-ab8505.c
> index 3a4238e..2841db7 100644
> --- a/drivers/pinctrl/pinctrl-ab8505.c
> +++ b/drivers/pinctrl/pinctrl-ab8505.c
> @@ -271,7 +271,8 @@ static const struct abx500_function ab8505_functions[] = {
>   *	alt_A	|       1       |          0          |          0
>   */
>  
> -struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1] = {
> +static struct
> +alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1] = {
>  	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
>  	ALTERNATE_FUNCTIONS(1,      0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
>  	ALTERNATE_FUNCTIONS(2,      1, UNUSED, UNUSED, 0, 0, 0), /* GPIO2, altA controlled by bit 1 */
> @@ -348,7 +349,7 @@ struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1
>   *	GPIO50
>   *	GPIO52 to GPIO53
>   */
> -struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
> +static struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
>  	GPIO_IRQ_CLUSTER(10, 11, AB8500_INT_GPIO10R),
>  	GPIO_IRQ_CLUSTER(13, 13, AB8500_INT_GPIO13R),
>  	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),



Acked-by: Patrice Chotard <patrice.chotard@st.com>