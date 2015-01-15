Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbbAOBDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:03:04 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59429 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbAOBDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:03:02 -0500
Date: Wed, 14 Jan 2015 17:02:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc
 touchscreen driver
Message-ID: <20150115010256.GC9134@dtor-ws>
References: <jonathar@broadcom.com>
 <1419027470-7969-1-git-send-email-jonathar@broadcom.com>
 <1419027470-7969-2-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419027470-7969-2-git-send-email-jonathar@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Fri, Dec 19, 2014 at 02:17:49PM -0800, Jonathan Richardson wrote:
> +	if (of_property_read_u32(np, "scanning_period", &val) >= 0) {
> +		if (val < 1 || val > 256) {
> +			dev_err(dev, "scanning_period must be [1-256]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.scanning_period = val;
> +	}
> +
> +	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
> +		if (val < 0 || val > 255) {
> +			dev_err(dev, "debounce_timeout must be [0-255]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.debounce_timeout = val;
> +	}
> +
> +	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
> +		if (val < 0 || val > 11) {
> +			dev_err(dev, "settling_timeout must be [0-11]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.settling_timeout = val;
> +	}
> +
> +	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
> +		if (val < 0 || val > 255) {
> +			dev_err(dev, "touch_timeout must be [0-255]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.touch_timeout = val;
> +	}
> +
> +	if (of_property_read_u32(np, "average_data", &val) >= 0) {
> +		if (val < 0 || val > 8) {
> +			dev_err(dev, "average_data must be [0-8]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.average_data = val;
> +	}
> +
> +	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
> +		if (val < 0 || val > 31) {
> +			dev_err(dev, "fifo_threshold must be [0-31]\n");
> +			return -EINVAL;
> +		}
> +		priv->cfg_params.fifo_threshold = val;
> +	}

I think these are dveice specific and thus should have "brcm," prefix.

> +
> +	priv->ts_rotation = TS_ROTATION_0;
> +	if (of_property_read_u32(np, "ts-rotation", &val) >= 0) {
> +		priv->ts_rotation = val;
> +		dev_dbg(dev, "ts rotation [%d] degrees\n",
> +			90 * priv->ts_rotation);
> +	}

This I am not quite sure about - if we want rotation or swap+invert. You
are CCed on another email (tsc2007) that talks about need of generic
touchscreen transforms in input core/of bindings.

Thanks.

-- 
Dmitry
