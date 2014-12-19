Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaLSTvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:51:38 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:19761 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaLSTvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:51:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,608,1413270000"; 
   d="scan'208";a="53501091"
Message-ID: <549481C5.7050802@broadcom.com>
Date: Fri, 19 Dec 2014 11:51:33 -0800
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] Input: touchscreen-iproc: Add Broadcom iProc touchscreen
 driver
References: <Jonathan Richardson <jonathar@broadcom.com>  <1418867992-3550-1-git-send-email-jonathar@broadcom.com>  <1418867992-3550-2-git-send-email-jonathar@broadcom.com> <1418868881.28384.8.camel@perches.com>
In-Reply-To: <1418868881.28384.8.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe. I'll send out a new patch set with your suggestions/fixes
shortly.

On 14-12-17 06:14 PM, Joe Perches wrote:
> On Wed, 2014-12-17 at 17:59 -0800, Jonathan Richardson wrote:
>> Add initial version of the Broadcom touchscreen driver.
> 
> trivia:
> 
>> diff --git a/drivers/input/touchscreen/bcm_iproc_tsc.c b/drivers/input/touchscreen/bcm_iproc_tsc.c
> 
>> +/* Bit values for REGCTL2 */
>> +#define TS_CONTROLLER_EN_BIT    (1 << 16)
>> +#define TS_CONTROLLER_AVGDATA_SHIFT 8
>> +#define TS_CONTROLLER_AVGDATA_MASK (0x7 << TS_CONTROLLER_AVGDATA_SHIFT)
>> +#define TS_CONTROLLER_PWR_LDO   (1<<5)
>> +#define TS_CONTROLLER_PWR_ADC   (1<<4)
>> +#define TS_CONTROLLER_PWR_BGP   (1<<3)
>> +#define TS_CONTROLLER_PWR_TS    (1<<2)
>> +#define TS_WIRE_MODE_BIT        (1<<1)
> 
> Be nicer to use the same spacing around <<
> or maybe use the BIT macro.
> 
> []
> 
>> +static int get_tsc_config(struct device_node *np, struct iproc_ts_priv *priv)
>> +{
>> +	int ret;
>> +	u32 val;
>> +	struct device *dev = &priv->pdev->dev;
>> +
>> +	priv->cfg_params = default_config;
>> +
>> +	ret = of_property_read_u32(np, "scanning_period", &val);
>> +	if (ret >= 0) {
>> +		if ((1 <= val) && (val <= 256))
>> +			priv->cfg_params.scanning_period = val;
>> +		else {
>> +			dev_err(dev, "scanning_period must be [1-256]");
>> +			return -EINVAL;
>> +		}
> 
> ret is never used so I'd probably remove it
> from all these blocks.
> 
> It's probably be nicer to invert the logic ald
> remove the else.
> 
> There's a missing terminating newline too.
> 
> Something like:
> 
> 	if (of_property_read_u32(np, "scanning_period", &val) >= 0) {
> 		if (val < 1 || val > 256) {
> 			dev_err(dev, "scanning_period must be [1-256]\n");
> 			return -EINVAL;
> 		}
> 		priv->cfg_params.scanning_period = val;
> 	}
> 
> etc...
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

