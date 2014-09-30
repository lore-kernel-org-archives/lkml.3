Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaI3HoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:44:20 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65187 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaI3HoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:44:18 -0400
Message-ID: <542A5F4D.8070407@linaro.org>
Date: Tue, 30 Sep 2014 08:44:13 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org
CC: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org> <5429DA95.80505@codeaurora.org>
In-Reply-To: <5429DA95.80505@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/09/14 23:17, Stephen Boyd wrote:
> On 09/29/14 02:14, Srinivas Kandagatla wrote:
>> @@ -246,6 +247,24 @@
>>   			#reset-cells = <1>;
>>   		};
>>
>> +		apcs: syscon@2011000 {
>> +			compatible = "syscon";
>> +			reg = <0x2011000 0x1000>;
>> +		};
>
> This is actually a clock controller block that hw designers decided was
> good place to shove the ipc bits (because there's room!). Can we call it
>
>                  l2cc: clock-controller@2011000 {
>                          compatible = "syscon";
>                          reg = <0x2011000 0x1000>;
>                  };
>
yep, I will rename this in next version.

> Eventually I'll add the specific krait compatible when we merge krait
> clock support:
sounds good.

--srini
>
>                  l2cc: clock-controller@2011000 {
>                          compatible = "qcom,kpss-gcc", "syscon";
>                          reg = <0x2011000 0x1000>;
>                          clock-output-names = "acpu_l2_aux";
>                  };
>
>> +
>> +		rpm@108000 {
>> +			compatible	= "qcom,rpm-apq8064";
>> +			reg		= <0x108000 0x1000>;
>> +			qcom,ipc = <&apcs 0x8 2>;
>
> There are actually 3 ipc bits. I guess if we ever have to use the other
> two we'll extend this binding to have the other bits specified some
> other way?
>
