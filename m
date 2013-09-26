Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3IZSFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:05:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56827 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3IZSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:05:48 -0400
Message-ID: <52447779.3010908@codeaurora.org>
Date: Thu, 26 Sep 2013 11:05:45 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv4 2/3] ARM: msm: Add support for APQ8074 Dragonboard
References: <1379992406-3541-1-git-send-email-rvaswani@codeaurora.org> <1379992406-3541-2-git-send-email-rvaswani@codeaurora.org> <4E7868D6-56CB-4AF8-8EBF-069966899C23@codeaurora.org> <5243652F.7090408@codeaurora.org> <B0F416B8-042A-49F1-81E9-B217F02AAD1E@codeaurora.org>
In-Reply-To: <B0F416B8-042A-49F1-81E9-B217F02AAD1E@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2013 9:37 AM, Kumar Gala wrote:
> <snip>

> +++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
> @@ -0,0 +1,6 @@
> +/include/ "qcom-msm8974.dtsi"
> +
> +/ {
> +	model = "Qualcomm APQ8074 Dragonboard";
> +	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
> +};
> diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
> new file mode 100644
> index 0000000..f04b643
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
> @@ -0,0 +1,35 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974";
> +	compatible = "qcom,msm8974";
> +	interrupt-parent = <&intc>;
> +
> +	soc: soc { };
>>> We should have a unit address here:
>>>
>>> 	  soc: soc@FOOBAR {
>>>
>>> also, split out the curly braces so any future patches do have to muck with that.
>>>
>>> 	};
>>>
>> Im not sure I understand the reasoning behind the unit address for soc ?
> Its fairly standard practice and there is a fair amount of discussion about the lack of a unit address for memory nodes.
>
That still doesn't really answer anything :) - and I couldn't find any 
discussions about this either.
I don't see anybody in upstream adding an address to soc except sun.
What is that address supposed to be for - what does it mean ?
The soc is way of encapsulating meaningful blocks  for the particular SoC.

>
>>>> +};
>>>> +
>>>> +&soc {
>>>> +	#address-cells = <1>;
>>>> +	#size-cells = <1>;
>>>> +	ranges;
>>>> +	compatible = "simple-bus";
>>>> +
>>>> +	intc: interrupt-controller@f9000000 {
>>>> +		compatible = "qcom,msm-qgic2";
>>>> +		interrupt-controller;
>>>> +		#interrupt-cells = <3>;
>>>> +		reg = <0xf9000000 0x1000>,
>>>> +		      <0xf9002000 0x1000>;
>>>> +	};
>>>> +
>>>> +	timer {
>>>> +		compatible = "arm,armv7-timer";
>>>> +		interrupts = <1 2 0xf08>,
>>>> +			     <1 3 0xf08>,
>>>> +			     <1 4 0xf08>,
>>>> +			     <1 1 0xf08>;
>>>> +		clock-frequency = <19200000>;
>>>> +	};
>>>> +};
> - k
>


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

