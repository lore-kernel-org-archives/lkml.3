Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaBDI7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:59:06 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:54057 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbaBDI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:59:00 -0500
Message-ID: <52F0A7F5.6070201@overkiz.com>
Date: Tue, 04 Feb 2014 09:42:29 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2] at91: pmc: Fixed irq's name allocation for programmable
 clocks
References: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com> <1391502105-24612-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1391502105-24612-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12105112850059982937
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello JJ,

Sorry for the noise (I added Mike in the CC list).

BTW, thanks for fixing this bug.

Mike, could you take this bug fix for the next 3.14 release ?

Best Regards,

Boris

On 04/02/2014 09:21, Jean-Jacques Hiblot wrote:
> The name provided to request_irq() must be valid until the irq is released.
> This patch stores the name in the internal data structure.
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   drivers/clk/at91/clk-programmable.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
> index 8e242c7..799b75c 100644
> --- a/drivers/clk/at91/clk-programmable.c
> +++ b/drivers/clk/at91/clk-programmable.c
> @@ -44,6 +44,7 @@ struct clk_programmable {
>   	u8 css;
>   	u8 pres;
>   	u8 slckmck;
> +	char irq_name[11];
>   	const struct clk_programmable_layout *layout;
>   };
>   
> @@ -247,7 +248,6 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>   	struct clk_programmable *prog;
>   	struct clk *clk = NULL;
>   	struct clk_init_data init;
> -	char irq_name[11];
>   
>   	if (id > PROG_ID_MAX)
>   		return ERR_PTR(-EINVAL);
> @@ -269,9 +269,9 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>   	prog->irq = irq;
>   	init_waitqueue_head(&prog->wait);
>   	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
> -	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
> +	snprintf(prog->irq_name, sizeof(prog->irq_name), "clk-prog%d", id);
>   	ret = request_irq(prog->irq, clk_programmable_irq_handler,
> -			  IRQF_TRIGGER_HIGH, irq_name, prog);
> +			  IRQF_TRIGGER_HIGH, prog->irq_name, prog);
>   	if (ret)
>   		return ERR_PTR(ret);
>   

