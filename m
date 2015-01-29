Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbbA2Ms0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:48:26 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:42734 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbbA2MsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:48:24 -0500
Message-ID: <1422535712.28891.3.camel@mm-sol.com>
Subject: Re: [PATCH v2 2/2] leds: add Qualcomm PM8941 WLED driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Thu, 29 Jan 2015 14:48:32 +0200
In-Reply-To: <1422060853-1067-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422060853-1067-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1422060853-1067-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1.2~trusty 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjorn,

Just few nitpick comments. 

On Fri, 2015-01-23 at 16:54 -0800, Bjorn Andersson wrote:
> From: Courtney Cavin cavin@sonymobile.com>
> 
> This adds support for the WLED ('White' LED) block on Qualcomm's
> PM8941 PMICs.
> 
> Signed-off-by: Courtney Cavin cavin@sonymobile.com>
> Signed-off-by: Bjorn Andersson andersson@sonymobile.com>
> ---
>  drivers/leds/Kconfig            |   8 +
>  drivers/leds/Makefile           |   1 +
>  drivers/leds/leds-pm8941-wled.c | 459 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 468 insertions(+)
>  create mode 100644 drivers/leds/leds-pm8941-wled.c
> 

<snip>

> +
> +#define PM8941_WLED_REG_VAL_BASE               0x40
> +#define  PM8941_WLED_REG_VAL_MAX               0xFFF
> +
> +#define PM8941_WLED_REG_MOD_EN                 0x46
> +#define  PM8941_WLED_REG_MOD_EN_BIT            BIT(7)
> +#define  PM8941_WLED_REG_MOD_EN_MASK           BIT(7)

Is it possible bit definitions to have same indentation like registers offsets?

> 
> +struct pm8941_wled_config {
> +       u32 i_boost_limit;
> +       u32 ovp;
> +       u32 switch_freq;
> +       u32 num_strings;
> +       u32 i_limit;
> +       bool cs_out_en;
> +       bool ext_gen;
> +       bool cabc_en;
> +};
> +

Could this be further squashed to bellow structure?

> +struct pm8941_wled {
> +       struct regmap *regmap;
> +       u16 addr;
> +
> +       struct led_classdev cdev;
> +
> +       struct pm8941_wled_config cfg;
> +};
> +
> 

<snip>

> +static void pm8941_wled_set_brightness(struct led_classdev *cdev,
> +                                                                                       enum 
> led_brightness value)
> +{
> +       if (pm8941_wled_set(cdev, value)) {

pm8941_wled_set() is used only here, could it be merged into this function?
 
> +               dev_err(cdev->dev, "Unable to set brightness\n");
> +               return;
> +       }
> +       cdev->brightness = value;
> +}
> +
> 

Otherwise it looks good. Driver is loaded and device is detected
properly (i have added readings for type and subtype registers).
Do you know where I can measure result from changing brightness 
sysfs entry. I am using 8074 dragonboard?

Thank you,
Ivan
