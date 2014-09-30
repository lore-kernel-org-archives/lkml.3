Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaI3FRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:17:22 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10383 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbaI3FRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:17:20 -0400
Date: Mon, 29 Sep 2014 22:17:29 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: DT: apq8064: Add usb host support.
Message-ID: <20140930051728.GI28481@sonymobile.com>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982100-7964-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411982100-7964-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Sep 02:15 PDT 2014, Srinivas Kandagatla wrote:

> This patch adds device tree nodes to support two usb hosts on APQ8064
> SOC.
> 

Sorry for not looking at the entire series before answering patch 1.
I still think you should add all the regulators in the first patch anyways.

> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
> @@ -263,6 +263,91 @@
>  			#address-cells	= <1>;
>  			#size-cells	= <0>;
>  
> +			pm8921_s3: pm8921-s3 {
> +				compatible	= "qcom,rpm-pm8921-smps";
> +				reg		= <QCOM_RPM_PM8921_SMPS3>;
> +
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1400000>;
> +				qcom,boot-load 		= <49360>;

As it was unclear how to handle load in the driver I dropped boot-load for now.
Please leave it out until someone have added it to the driver.

> +				qcom,switch-mode-frequency = <3200000>;
> +				regulator-always-on;
> +			};
> +
> +			pm8921_l3: pm8921-l3 {
> +				compatible	= "qcom,rpm-pm8921-pldo";
> +				reg		= <QCOM_RPM_PM8921_LDO3>;
> +
> +				regulator-min-microvolt = <3050000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-always-on;
> +				qcom,boot-load = <50000>;

Dito

> +			};
> +
> +			pm8921_l23: pm8921-l23 {
> +				compatible	= "qcom,rpm-pm8921-pldo";
> +				reg		= <QCOM_RPM_PM8921_LDO23>;
> +
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1800000>;
> +				qcom,boot-load = <50000>;

Dito

> +				regulator-always-on;

Why are all these "always-on"?

> +			};
> +
> +		};
> +
>  
>  		/* Temporary fixed regulator */
> -- 
> 1.9.1
> 
