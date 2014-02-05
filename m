Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBEOE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:04:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49788 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBEOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:04:57 -0500
Date: Wed, 5 Feb 2014 14:04:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
Message-ID: <20140205140450.GE5196@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-12-git-send-email-k.kozlowski@samsung.com>
 <52F18A08.6070409@samsung.com>
 <1391596810.3726.5.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391596810.3726.5.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Following patch has conflict on extcon-next branch(Linus 3.14-rc1)
> > when apply patchset by using git am.
> > 
> > [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
> > [PATCH 12/18] extcon: max14577: Choose muic_irqs according to device type
> > [PATCH 14/18] extcon: max14577: Add support for max77836
> > 
> > The base commit of this patchset isn't mainline. You need to rebase this patchset 
> > on extcon-next branch and please resend this patchset.

<snip>

> This patch patch (along with other) depends on previous rename patches
> from this patchset:
> [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to prepare
> for max77836
> http://article.gmane.org/gmane.linux.kernel/1636674
> 
> I can resolve the conflict but then they will return on applying patch
> 7/18.
> 
> I think this patch may wait for a little until the rename-like patches
> will be accepted.
> 
> Can you ACK other patches touch extcon?
>  - [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols...
>  - [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
>  - [PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and irq_chip

If you can obtain Acks for all of the patches, I can apply the entire
patch-set to an immutable branch and issue a pull-request for the
other maintainers to pull from.

> > On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> > > Add max14577 prefix to muic_irqs array. This prepares for max77836
> > > support in this extcon driver.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  drivers/extcon/extcon-max14577.c |   12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
> > > index fd48b4909470..fb343f4042d2 100644
> > > --- a/drivers/extcon/extcon-max14577.c
> > > +++ b/drivers/extcon/extcon-max14577.c
> > > @@ -85,7 +85,7 @@ struct max14577_muic_irq {
> > >  	unsigned int virq;
> > >  };
> > >  
> > > -static struct max14577_muic_irq muic_irqs[] = {
> > > +static struct max14577_muic_irq max14577_muic_irqs[] = {
> > >  	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
> > >  	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
> > >  	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
> > > @@ -541,9 +541,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
> > >  	 * However we only need to know whether it was ADC, charger
> > >  	 * or both interrupts so decode IRQ and turn on proper flags.
> > >  	 */
> > > -	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
> > > -		if (irq == muic_irqs[i].virq)
> > > -			irq_type = muic_irqs[i].irq;
> > > +	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++)
> > > +		if (irq == max14577_muic_irqs[i].virq)
> > > +			irq_type = max14577_muic_irqs[i].irq;
> > >  
> > >  	switch (irq_type) {
> > >  	case MAXIM_IRQ_INT1_ADC:
> > > @@ -647,8 +647,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
> > >  	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
> > >  
> > >  	/* Support irq domain for max14577 MUIC device */
> > > -	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
> > > -		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
> > > +	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++) {
> > > +		struct max14577_muic_irq *muic_irq = &max14577_muic_irqs[i];
> > >  		unsigned int virq = 0;
> > >  
> > >  		virq = regmap_irq_get_virq(maxim_core->irq_data_muic,
> > > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
