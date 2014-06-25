Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaFYARl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:17:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaFYARj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:17:39 -0400
Message-ID: <53AA151E.9090701@suse.de>
Date: Wed, 25 Jun 2014 02:17:34 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Andy Gross <agross@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: msm: Add msm8960 definitions
References: <1403633766-25796-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1403633766-25796-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.06.2014 20:16, schrieb Bjorn Andersson:
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
> new file mode 100644
> index 0000000..6e79eea
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
[...]
> +Example:
> +
> +	msmgpio: pinctrl@800000 {
> +		compatible = "qcom,msm8960-pinctrl";
> +		reg = <0x800000 0x4000>;
> +
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +                interrupts = <0 32 0x4>;

This line seems space-indented while surrounding ones are tab-indented.

> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&debug_uart>;
> +
> +		debug_uart: debug_uart {

While at it, might debug-uart be a better node name? That seems the
predominant convention and distinguishes from the label.

Regards,
Andreas

> +			mux {
> +				pins = "gpio34", "gpio35";
> +				function = "gsbi8";
> +			};
> +
> +			tx {
> +				pins = "gpio34";
> +				drive-strength = <4>;
> +				bias-disable;
> +			};
> +
> +			rx {
> +				pins = "gpio35";
> +				drive-strength = <2>;
> +				bias-pull-up;
> +			};
> +		};
> +	};
[snip]

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
