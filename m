Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaEUUQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:16:42 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42343 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbaEUUQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:16:41 -0400
Message-ID: <537D0989.6080108@mm-sol.com>
Date: Wed, 21 May 2014 23:16:09 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rvaswani@codeaurora.org, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 1/4] ARM: dts: qcom: Add APQ8084 SoC support
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com> <1400684225-21381-2-git-send-email-gdjakov@mm-sol.com> <537CE141.6010500@codeaurora.org>
In-Reply-To: <537CE141.6010500@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.14, 20:24, Stephen Boyd wrote:
> On 05/21/14 07:57, Georgi Djakov wrote:
>> +
>> +		L2: l2-cache {
>> +			compatible = "qcom,arch-cache";
>> +			cache-level = <2>;
>> +			interrupts = <0 2 0x4>;
> 
> Let's leave out interrupts until the binding is accepted.
> 
>> +			qcom,saw = <&saw_l2>;
>> +		};
>> +	};
>> +
>> +	cpu-pmu {
>> +		compatible = "qcom,krait-pmu";
>> +		interrupts = <1 7 0xf04>;
>> +	};
>> +
>> +	soc: soc {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +		compatible = "simple-bus";
>> +
>> +		intc: interrupt-controller@f9000000 {
>> +			compatible = "qcom,msm-qgic2";
>> +			interrupt-controller;
>> +			#interrupt-cells = <3>;
>> +			reg = <0xf9000000 0x1000>,
>> +			      <0xf9002000 0x1000>;
>> +		};
>> +
>> +		timer {
>> +			compatible = "arm,armv7-timer";
>> +			interrupts = <1 2 0xf08>,
>> +				     <1 3 0xf08>,
>> +				     <1 4 0xf08>,
>> +				     <1 1 0xf08>;
>> +			clock-frequency = <19200000>;
>> +		};
> 
> Please move this timer node out of the soc container below the pmu.
> 

Will do. Thanks for the comments!

BR,
Georgi
