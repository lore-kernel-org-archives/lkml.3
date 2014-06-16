Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaFPRJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:09:42 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48909 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFPRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:09:40 -0400
Date: Mon, 16 Jun 2014 18:09:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tc3589x: translate onecell, not twocell
Message-ID: <20140616170933.GE14323@lee--X1>
References: <1402403492-24960-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402403492-24960-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Linus Walleij wrote:

> Something changed in the OF parser in the v3.16 merge window
> making it be strict about passing the number of IRQ cells
> correctly and disturbing the irqdomain xlate function guard
> to crash when subdevices try to obtain IRQs like this:

[...]

> The TC3589x device trees specify the MFD core device
> as having one interrupt cell (cannot specify flags) so the
> twocell translation function is clearly wrong, changing it to
> onecell, as it should be, fixes the regression.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/tc3589x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good.  Applied, thanks.

> diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
> index bd83accc0f6d..0072e668c208 100644
> --- a/drivers/mfd/tc3589x.c
> +++ b/drivers/mfd/tc3589x.c
> @@ -236,7 +236,7 @@ static void tc3589x_irq_unmap(struct irq_domain *d, unsigned int virq)
>  static struct irq_domain_ops tc3589x_irq_ops = {
>  	.map    = tc3589x_irq_map,
>  	.unmap  = tc3589x_irq_unmap,
> -	.xlate  = irq_domain_xlate_twocell,
> +	.xlate  = irq_domain_xlate_onecell,
>  };
>  
>  static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
