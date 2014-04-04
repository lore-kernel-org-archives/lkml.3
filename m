Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDDSQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:16:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57645 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaDDSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:16:40 -0400
Message-ID: <533EF706.6050001@codeaurora.org>
Date: Fri, 04 Apr 2014 11:16:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: qcom: Add initial IPQ8064 SoC and AP148 device trees
References: <1396628986-6613-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396628986-6613-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 09:29, Kumar Gala wrote:
> diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
> new file mode 100644
> index 0000000..31f735c
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
> @@ -0,0 +1,122 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"

#include?

> +
> +#include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> +
> +/ {
> +	model = "Qualcomm IPQ8064";
> +	compatible = "qcom,ipq8064";
> +	interrupt-parent = <&intc>;
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		interrupts = <1 14 0x304>;

It may be better to leave this out for now as the binding was never
accepted. Which reminds me, I need to send a patch to fix up the
interrupts we currently have queued for 3.15.

> +		compatible = "qcom,krait";
> +		enable-method = "qcom,kpss-acc-v1";
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			reg = <0>;
> +			next-level-cache = <&L2>;
> +			qcom,acc = <&acc0>;
> +			qcom,saw = <&saw0>;
> +		};
> +
> +		cpu@1 {
> +			device_type = "cpu";
> +			reg = <1>;
> +			next-level-cache = <&L2>;
> +			qcom,acc = <&acc1>;
> +			qcom,saw = <&saw1>;
> +		};
> +
> +		L2: l2-cache {
> +			compatible = "cache";
> +			cache-level = <2>;
> +			interrupts = <0 2 0x4>;
> +		};
> +	};

Can you also throw in the pmu here please?

> +
> +	soc: soc {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +		compatible = "simple-bus";
> +
> +		intc: interrupt-controller@2000000 {
> +			compatible = "qcom,msm-qgic2";
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			reg = < 0x02000000 0x1000 >,
> +			      < 0x02002000 0x1000 >;
> +		};
> +
> +		timer@200a000 {
> +			compatible = "qcom,kpss-timer", "qcom,msm-timer";
> +			interrupts = <1 1 0x301>,
> +				     <1 2 0x301>,
> +				     <1 3 0x301>;
> +			reg = <0x0200a000 0x100>;
> +			clock-frequency = <27000000>,

If PXO is actually 25Mhz this is wrong. How long does 'sleep 10' take?

> +					  <32768>;
> +			cpu-offset = <0x80000>;
> +		};
> +
>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

