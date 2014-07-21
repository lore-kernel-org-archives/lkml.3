Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaGUL3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:29:41 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:48346 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbaGUL3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:29:39 -0400
Date: Mon, 21 Jul 2014 07:29:37 -0400 (EDT)
Subject: RE: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
From: kiran.padwal@smartplayin.com
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "Bjorn Andersson" <bjorn.andersson@sonymobile.com>,
        "Mark Brown" <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com> 
 <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
Message-ID: <1405942177.790123849@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, July 17, 2014 11:25am, "Ivan T. Ivanov" <iivanov@mm-sol.com> said:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/pinctrl/Kconfig                       |   12 +
>  drivers/pinctrl/Makefile                      |    1 +
>  drivers/pinctrl/pinctrl-qpnp.c                | 1565 +++++++++++++++++++++++++
.
<snip>
.
> diff --git a/drivers/pinctrl/pinctrl-qpnp.c b/drivers/pinctrl/pinctrl-qpnp.c
> new file mode 100644
> index 0000000..aedc72e
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-qpnp.c
.
<snip>
.
> +#define QPNP_MPP_CS_OUT_35MA			6
> +#define QPNP_MPP_CS_OUT_40MA			7
> +
> +/* revision registers base address offsets */

unused define, can you please remove it

> +#define QPNP_REG_DIG_MINOR_REV			0x0
> +#define QPNP_REG_DIG_MAJOR_REV			0x1

ditto

> +#define QPNP_REG_ANA_MINOR_REV			0x2
> +
> +/* type registers base address offsets */
> +#define QPNP_REG_TYPE				0x4
> +#define QPNP_REG_SUBTYPE			0x5
> +
> +/* GPIO peripheral type and subtype values */
> +#define QPNP_GPIO_TYPE				0x10
> +#define QPNP_GPIO_SUBTYPE_GPIO_4CH		0x1
> +#define QPNP_GPIO_SUBTYPE_GPIOC_4CH		0x5
> +#define QPNP_GPIO_SUBTYPE_GPIO_8CH		0x9
> +#define QPNP_GPIO_SUBTYPE_GPIOC_8CH		0xd
> +
> +/* mpp peripheral type and subtype values */
> +#define QPNP_MPP_TYPE				0x11
> +#define QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT		0x3
> +#define QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT	0x4
> +#define QPNP_MPP_SUBTYPE_4CH_NO_SINK		0x5
> +#define QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK	0x6
> +#define QPNP_MPP_SUBTYPE_4CH_FULL_FUNC		0x7
> +#define QPNP_MPP_SUBTYPE_8CH_FULL_FUNC		0xf
> +
> +#define QPNP_REG_STATUS1			0x8
> +#define QPNP_REG_STATUS1_VAL_MASK		0x1
> +#define QPNP_REG_STATUS1_GPIO_EN_REV0_MASK	0x2
> +#define QPNP_REG_STATUS1_GPIO_EN_MASK		0x80
> +#define QPNP_REG_STATUS1_MPP_EN_MASK		0x80
> +
> +/* control register base address offsets */
> +#define QPNP_REG_MODE_CTL			0x40
> +#define QPNP_REG_DIG_VIN_CTL			0x41
> +#define QPNP_REG_DIG_PULL_CTL			0x42

ditto

> +#define QPNP_REG_DIG_IN_CTL			0x43
> +#define QPNP_REG_DIG_OUT_CTL			0x45
> +#define QPNP_REG_EN_CTL				0x46
> +#define QPNP_REG_AOUT_CTL			0x4b
> +#define QPNP_REG_AIN_CTL			0x4a
> +#define QPNP_REG_SINK_CTL			0x4c
> +
.
<snip>
.
> +#define PM8XXX_MPP_AIN_ABUS3			6
> +#define PM8XXX_MPP_AIN_ABUS4			7
> +
> +#endif
> --
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Regards,
--Kiran

