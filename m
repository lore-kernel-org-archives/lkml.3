Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaFRUcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:32:41 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:45499 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaFRUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:32:39 -0400
Date: Wed, 18 Jun 2014 16:32:34 -0400
From: Matt Porter <mporter@linaro.org>
To: Graham Williams <graham.williams@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: bcm590xx: fix vbus name
Message-ID: <20140618203234.GQ4173@beef>
References: <1403120530-27395-1-git-send-email-graham.williams@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403120530-27395-1-git-send-email-graham.williams@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:42:10PM -0700, Graham Williams wrote:
> The vbus regulator was not getting its name set. This results
> in the sysfs entry being empty. The lack of a bcm590xx_regs[]
> table entry also upsets Coverity runs. Add the table entry
> so the name gets set properly.
> 
> Signed-off-by: Graham Williams <graham.williams@linaro.org>
> ---
>  drivers/regulator/bcm590xx-regulator.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index 57544e2..58ece59 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -119,6 +119,10 @@ static const unsigned int ldo_c_table[] = {
>  	2900000, 3000000, 3300000,
>  };
>  
> +static const unsigned int ldo_vbus[] = {
> +	5000000,
> +};
> +
>  /* DCDC group CSR: supported voltages in microvolts */
>  static const struct regulator_linear_range dcdc_csr_ranges[] = {
>  	REGULATOR_LINEAR_RANGE(860000, 2, 50, 10000),
> @@ -192,6 +196,7 @@ static struct bcm590xx_info bcm590xx_regs[] = {
>  	BCM590XX_REG_TABLE(gpldo4, ldo_a_table),
>  	BCM590XX_REG_TABLE(gpldo5, ldo_a_table),
>  	BCM590XX_REG_TABLE(gpldo6, ldo_a_table),
> +	BCM590XX_REG_TABLE(vbus, ldo_vbus),
>  };

Also fixes the functional problem for me on the Capri board, thanks.
Coverity should also be much happier now.

Acked-by: Matt Porter <mporter@linaro.org>

Mark: can you pick this up for 3.16 fixes?

-Matt
