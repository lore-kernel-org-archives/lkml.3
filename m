Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbbAFRP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:15:56 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20723 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755860AbbAFRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:15:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18t7/ywsZgXxGvGK9qwDXK5
Date: Tue, 6 Jan 2015 09:12:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 13/14] mfd: twl-core: Constify struct regmap_config and
 reg_default array
Message-ID: <20150106171201.GS4081@atomide.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-13-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420448493-9355-13-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Krzysztof Kozlowski <k.kozlowski@samsung.com> [150105 01:04]:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make array of
> struct reg_default const as well.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> Cc: linux-omap@vger.kernel.org
> ---
>  drivers/mfd/twl-core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index db11b4f40611..489674a2497e 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -207,7 +207,7 @@ static struct twl_mapping twl4030_map[] = {
>  	{ 2, TWL5031_BASEADD_INTERRUPTS },
>  };
>  
> -static struct reg_default twl4030_49_defaults[] = {
> +static const struct reg_default twl4030_49_defaults[] = {
>  	/* Audio Registers */
>  	{ 0x01, 0x00}, /* CODEC_MODE	*/
>  	{ 0x02, 0x00}, /* OPTION	*/
> @@ -306,7 +306,7 @@ static const struct regmap_access_table twl4030_49_volatile_table = {
>  	.n_yes_ranges = ARRAY_SIZE(twl4030_49_volatile_ranges),
>  };
>  
> -static struct regmap_config twl4030_regmap_config[4] = {
> +static const struct regmap_config twl4030_regmap_config[4] = {
>  	{
>  		/* Address 0x48 */
>  		.reg_bits = 8,
> @@ -369,7 +369,7 @@ static struct twl_mapping twl6030_map[] = {
>  	{ 1, TWL6030_BASEADD_GASGAUGE },
>  };
>  
> -static struct regmap_config twl6030_regmap_config[3] = {
> +static const struct regmap_config twl6030_regmap_config[3] = {
>  	{
>  		/* Address 0x48 */
>  		.reg_bits = 8,
> @@ -1087,7 +1087,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	struct twl4030_platform_data	*pdata = dev_get_platdata(&client->dev);
>  	struct device_node		*node = client->dev.of_node;
>  	struct platform_device		*pdev;
> -	struct regmap_config		*twl_regmap_config;
> +	const struct regmap_config	*twl_regmap_config;
>  	int				irq_base = 0;
>  	int				status;
>  	unsigned			i, num_slaves;
> -- 
> 1.9.1
> 
