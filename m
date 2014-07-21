Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaGUQCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:02:30 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57558 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbaGUQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
	<1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
Date: Mon, 21 Jul 2014 21:32:24 +0530
Message-ID: <CADsdr6Pwa+Vzugy7_-yWePmT6Wj5bpJRDq=qq2KLdG2woioY4g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
From: divya ojha <odivya77@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 17, 2014 at 8:55 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
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
>  include/dt-bindings/pinctrl/qcom,pm8xxx-mpp.h |   34 +
..
+       struct device *dev = qctrl->dev;
> +       struct pinctrl_pin_desc *desc, *descs;
> +       struct qpnp_padinfo *pad, *pads;
> +       int idx, ret, cnt, gps, ais, aos, css;
> +       const char **names, *format;
> +       unsigned int addr;
> +
> +       pads = devm_kcalloc(dev, qchip->npads, sizeof(*pads), GFP_KERNEL);

when do we free these structures..?

> +       if (!pads)
> +               return -ENOMEM;
> +
> +       descs = devm_kcalloc(dev, qchip->npads, sizeof(*descs), GFP_KERNEL);

ditto..

> +       if (!descs)
> +               return -ENOMEM;
> +
..
> +               cnt = qctrl->groups[idx].npins;
> +               if (!cnt)
> +                       continue;
> +
> +               names = devm_kcalloc(dev, cnt, sizeof(names), GFP_KERNEL);

ditto..

> +               if (!names)
> +                       return -ENOMEM;

> +#define PM8XXX_MPP_AIN_ABUS4                   7
> +
> +#endif
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Regards
Divya
