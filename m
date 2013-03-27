Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3C0Hd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:33:57 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:39874
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab3C0Hd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:33:56 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: Re: [patch v1] mfd: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
In-Reply-To: <1363597958.4228.7.camel@dhruva>
References: <1363597958.4228.7.camel@dhruva>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Mar 2013 13:00:32 +0530
Message-ID: <1364369432.13582.0.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 14:42 +0530, Ashish Jangam wrote:
> This patch changes the irq state from high to the now default low.
> Because the default PMIC irq state of DA9055 got changed from high to low.
> This change should not affect any of the existing users since all of them
> use active low state.
> 
> This patch has been tested on smdkv6410.
> 
> Signed-off-by: Ashish <ashish.jangam@kpitcummins.com>
> 
> ---
>  drivers/mfd/da9055-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
> index f56a1a9..49cb23d 100644
> --- a/drivers/mfd/da9055-core.c
> +++ b/drivers/mfd/da9055-core.c
> @@ -391,7 +391,7 @@ int da9055_device_init(struct da9055 *da9055)
>  		da9055->irq_base = pdata->irq_base;
>  
>  	ret = regmap_add_irq_chip(da9055->regmap, da9055->chip_irq,
> -				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>  				  da9055->irq_base, &da9055_regmap_irq_chip,
>  				  &da9055->irq_data);
>  	if (ret < 0)
If there are no comments then can this patch get merged.


