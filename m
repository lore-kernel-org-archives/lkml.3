Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaIUKxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 06:53:37 -0400
Received: from svenfoo.org ([82.94.215.22]:33714 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaIUKxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 06:53:35 -0400
Message-ID: <541EAE2D.2080700@zonque.org>
Date: Sun, 21 Sep 2014 12:53:33 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>, galak@codeaurora.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] cap1106: Add support for various cap11xx devices
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com> <1411268469-21283-2-git-send-email-mranostay@gmail.com>
In-Reply-To: <1411268469-21283-2-git-send-email-mranostay@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/21/2014 05:01 AM, Matt Ranostay wrote:
>  	priv->regmap = devm_regmap_init_i2c(i2c_client, &cap1106_regmap_config);
>  	if (IS_ERR(priv->regmap))
>  		return PTR_ERR(priv->regmap);
>  
> -	error = regmap_read(priv->regmap, CAP1106_REG_PRODUCT_ID, &val);
> -	if (error)
> -		return error;
> -
> -	if (val != CAP1106_PRODUCT_ID) {
> -		dev_err(dev, "Product ID: Got 0x%02x, expected 0x%02x\n",
> -			val, CAP1106_PRODUCT_ID);
> -		return -ENODEV;
> -	}
> -

Btw - the purpose of this code was to detect board configuration
mismatch. After all, I2C lacks a way to properly identify peripherals,
so the more runtime checks we do at probe time, the more of a chance we
have to detect wrong setups. This device is actually well implemented
and tells us something about itself.

Hence, I'd propose to define a structure like this:

struct cap11xx_hw_model {
	uint8_t product_id;
	unsigned int num_channels;
};

... and attach instances of that to the members of cap1106_dt_ids[] and
cap1106_i2c_ids[]. In the probe function, check that the contents of
CAP1106_PRODUCT_ID match what is expected by the configured model.


Thanks,
Daniel

