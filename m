Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaLRCOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:14:49 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:51942 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751889AbaLRCOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:14:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4250:4321:4419:4605:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats75_8087f24f9f545
X-Filterd-Recvd-Size: 2865
Message-ID: <1418868881.28384.8.camel@perches.com>
Subject: Re: [PATCH 1/2] Input: touchscreen-iproc: Add Broadcom iProc
 touchscreen driver
From: Joe Perches <joe@perches.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Wed, 17 Dec 2014 18:14:41 -0800
In-Reply-To: <1418867992-3550-2-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
	 <1418867992-3550-1-git-send-email-jonathar@broadcom.com>
	 <1418867992-3550-2-git-send-email-jonathar@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 17:59 -0800, Jonathan Richardson wrote:
> Add initial version of the Broadcom touchscreen driver.

trivia:

> diff --git a/drivers/input/touchscreen/bcm_iproc_tsc.c b/drivers/input/touchscreen/bcm_iproc_tsc.c

> +/* Bit values for REGCTL2 */
> +#define TS_CONTROLLER_EN_BIT    (1 << 16)
> +#define TS_CONTROLLER_AVGDATA_SHIFT 8
> +#define TS_CONTROLLER_AVGDATA_MASK (0x7 << TS_CONTROLLER_AVGDATA_SHIFT)
> +#define TS_CONTROLLER_PWR_LDO   (1<<5)
> +#define TS_CONTROLLER_PWR_ADC   (1<<4)
> +#define TS_CONTROLLER_PWR_BGP   (1<<3)
> +#define TS_CONTROLLER_PWR_TS    (1<<2)
> +#define TS_WIRE_MODE_BIT        (1<<1)

Be nicer to use the same spacing around <<
or maybe use the BIT macro.

[]

> +static int get_tsc_config(struct device_node *np, struct iproc_ts_priv *priv)
> +{
> +	int ret;
> +	u32 val;
> +	struct device *dev = &priv->pdev->dev;
> +
> +	priv->cfg_params = default_config;
> +
> +	ret = of_property_read_u32(np, "scanning_period", &val);
> +	if (ret >= 0) {
> +		if ((1 <= val) && (val <= 256))
> +			priv->cfg_params.scanning_period = val;
> +		else {
> +			dev_err(dev, "scanning_period must be [1-256]");
> +			return -EINVAL;
> +		}

ret is never used so I'd probably remove it
from all these blocks.

It's probably be nicer to invert the logic ald
remove the else.

There's a missing terminating newline too.

Something like:

	if (of_property_read_u32(np, "scanning_period", &val) >= 0) {
		if (val < 1 || val > 256) {
			dev_err(dev, "scanning_period must be [1-256]\n");
			return -EINVAL;
		}
		priv->cfg_params.scanning_period = val;
	}

etc...


