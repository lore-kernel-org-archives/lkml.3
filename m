Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaI3Htj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:49:39 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43807 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaI3Hth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:49:37 -0400
Message-ID: <542A608B.5010408@linaro.org>
Date: Tue, 30 Sep 2014 08:49:31 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
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
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org> <20140930051138.GH28481@sonymobile.com>
In-Reply-To: <20140930051138.GH28481@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/09/14 06:11, Bjorn Andersson wrote:

>>
>> +		apcs: syscon@2011000 {
>> +			compatible = "syscon";
>> +			reg = <0x2011000 0x1000>;
>> +		};
>> +
>> +		rpm@108000 {
>> +			compatible	= "qcom,rpm-apq8064";
>> +			reg		= <0x108000 0x1000>;
>> +			qcom,ipc = <&apcs 0x8 2>;
>
> I don't like your indentation, but please stick with one way of doing it :)
>
I agree, Will fix this in next version.
>> +
>> +			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
>> +			interrupt-names = "ack", "err", "wakeup";
>> +
>> +			#address-cells	= <1>;
>> +			#size-cells	= <0>;
>> +
>
> This part looks good.
>
> But how about adding all the regulators here as well?
Yes we can add for the sake of completeness but w.r.t testing only some 
of them will be tested
> Like:
>
>                          pm8921_l5: pm8921-l5 {
> 				compatible = "qcom,rpm-pm8921-pldo";
> 				reg = <QCOM_RPM_PM8921_LDO5>;
> 			};
>
Adding nodes like this should be trival.
> 			...
>
> That way we can update the references from this file (while still allowing the
> dts to override it if needed). I'm not sure if we should add some sane defaults
> or just completely deferr specifying the voltage ranges to the dts. The benefit
> of the latter is that the regulators not configured by the dts author will not
> be accessible.
>
> But simply listing all the nodes here would be nice and I dont see much reason
> to postpone this work.
Ok.. will be done in next version.


--srini
>
>> +		};
>> +
>>   		/* Temporary fixed regulator */
>>   		vsdcc_fixed: vsdcc-regulator {
>>   			compatible = "regulator-fixed";
>
> Regards,
> Bjorn
>
