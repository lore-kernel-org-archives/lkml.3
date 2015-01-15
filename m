Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbbAOFoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:44:46 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60291 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbbAOFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:44:44 -0500
X-IronPort-AV: E=Sophos;i="5.09,401,1418112000"; 
   d="scan'208";a="54715769"
Message-ID: <54B753C7.6000006@broadcom.com>
Date: Wed, 14 Jan 2015 21:44:39 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Richardson <jonathar@broadcom.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc touchscreen
 driver
References: <jonathar@broadcom.com> <1419027470-7969-1-git-send-email-jonathar@broadcom.com> <1419027470-7969-2-git-send-email-jonathar@broadcom.com> <20150115010256.GC9134@dtor-ws>
In-Reply-To: <20150115010256.GC9134@dtor-ws>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-01-14 05:02 PM, Dmitry Torokhov wrote:
> Hi Jonathan,
>
> On Fri, Dec 19, 2014 at 02:17:49PM -0800, Jonathan Richardson wrote:
>> +	if (of_property_read_u32(np, "scanning_period", &val) >= 0) {
>> +		if (val < 1 || val > 256) {
>> +			dev_err(dev, "scanning_period must be [1-256]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.scanning_period = val;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
>> +		if (val < 0 || val > 255) {
>> +			dev_err(dev, "debounce_timeout must be [0-255]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.debounce_timeout = val;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
>> +		if (val < 0 || val > 11) {
>> +			dev_err(dev, "settling_timeout must be [0-11]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.settling_timeout = val;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
>> +		if (val < 0 || val > 255) {
>> +			dev_err(dev, "touch_timeout must be [0-255]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.touch_timeout = val;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "average_data", &val) >= 0) {
>> +		if (val < 0 || val > 8) {
>> +			dev_err(dev, "average_data must be [0-8]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.average_data = val;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
>> +		if (val < 0 || val > 31) {
>> +			dev_err(dev, "fifo_threshold must be [0-31]\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->cfg_params.fifo_threshold = val;
>> +	}
>
> I think these are dveice specific and thus should have "brcm," prefix.
I'm confused as to why we need the brcm prefix?  Other device tree 
bindings we have for other drivers do not need such prefix.  Is this 
convention documented somewhere?
>
>> +
>> +	priv->ts_rotation = TS_ROTATION_0;
>> +	if (of_property_read_u32(np, "ts-rotation", &val) >= 0) {
>> +		priv->ts_rotation = val;
>> +		dev_dbg(dev, "ts rotation [%d] degrees\n",
>> +			90 * priv->ts_rotation);
>> +	}
>
> This I am not quite sure about - if we want rotation or swap+invert. You
> are CCed on another email (tsc2007) that talks about need of generic
> touchscreen transforms in input core/of bindings.
Does such generic binding exist today?  If not, I would like to go with 
this implementation and update to the new binding if/when it exists?
>
> Thanks.
>

