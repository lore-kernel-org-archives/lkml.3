Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLCKCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:02:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaLCKCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:02:36 -0500
Message-ID: <1417600949.12511.7.camel@linux-0dmf.site>
Subject: Re: [PATCH v10 2/6] backlight: Add support Skyworks SKY81452
 backlight driver
From: Oliver Neukum <oneukum@suse.de>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, jg1.han@samsung.com, cooloney@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        trivial@kernel.org, akpm@linux-foundation.org, jic23@kernel.org,
        thomas.petazzoni@free-electrons.com, ktsai@capellamicro.com,
        hs@denx.de, stwiss.opensource@diasemi.com, matti.vaittinen@nsn.com,
        broonie@kernel.org, jason@lakedaemon.net, heiko@sntech.de,
        shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch,
        antonynpavlov@gmail.com, hytszk@gmail.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, jack.yoo@skyworksinc.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Wed, 03 Dec 2014 11:02:29 +0100
In-Reply-To: <1417590332-4912-3-git-send-email-jack.yoo@skyworksinc.com>
References: <1417590332-4912-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1417590332-4912-3-git-send-email-jack.yoo@skyworksinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 16:05 +0900, gyungoh@gmail.com wrote:
> +static ssize_t sky81452_bl_store_enable(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t
> count)
> +{
> +       struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +       unsigned long value;
> +       int ret;
> +
> +       ret = kstrtoul(buf, 16, &value);
> +       if (IS_ERR_VALUE(ret))
> +               return ret;
> +
> +       ret = regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN,
> +                                       value << CTZ(SKY81452_EN));

No range checking for value?

> +       if (IS_ERR_VALUE(ret))
> +               return ret;
> +
> +       return count;
> +}

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

