Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaHTXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:06:21 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4711 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbaHTXGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:06:19 -0400
Date: Wed, 20 Aug 2014 16:06:13 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] ARM: dts: qcom: Add APQ8074 Dragonboard PMIC GPIO
 bindings
Message-ID: <20140820230612.GE16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-7-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407771634-14946-7-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11 Aug 08:40 PDT 2014, Ivan T. Ivanov wrote:
> diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi b/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi
[...]
> +
> +&pm8941_gpios {
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pm8941_gpios_default>;
> +
> +	pm8941_gpios_default: default {
> +		group-1 {
> +			pins = "gpio1", "gpio2", "gpio5", "gpio29";
> +			function = PMIC_GPIO_FUNC_NORMAL;

This looks really strange, I can't get myself to stop thinking that you forgot
the <> around this (I know it's a string). I don't like these defines.

> +			input-enable;
> +			power-source = <PM8941_GPIO_S3>;
> +			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
> +		};
> +		group-6 {	/* TUSB3_HUB-RESET */

Why not name the nodes something useful?
If you name it tusb3-hub-reset you can skip the comment.

> +			pins = "gpio6";
> +			function = PMIC_GPIO_FUNC_NORMAL;
> +			output-high;
> +			drive-push-pull;
> +			power-source = <PM8941_GPIO_VPH>;
> +			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
> +			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
> +		};

Regards,
Bjorn
