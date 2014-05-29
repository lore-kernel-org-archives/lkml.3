Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbaE2RJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:09:51 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38684 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaE2RJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:09:49 -0400
Message-ID: <538769D9.1090305@linaro.org>
Date: Thu, 29 May 2014 18:09:45 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com> <53875E17.6010406@linaro.org> <7FA6C80D-8076-4E41-AF55-11BBA2FD9AB0@codeaurora.org>
In-Reply-To: <7FA6C80D-8076-4E41-AF55-11BBA2FD9AB0@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/05/14 17:30, Kumar Gala wrote:
>
> On May 29, 2014, at 11:19 AM, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
>
>>> += SUBDEVICES
>>> +
>>> +The RPM exposes resources to its subnodes. The below bindings specify the set
>>> +of valid subnodes that can operate on these resources.
>>
>> Why should these devices be on sub nodes?
>>
>> Any reason not to implement it like this,
>>
>> rpm: rpm@108000 {
>> 	compatible = "qcom,rpm-msm8960";
>> 	reg = <0x108000 0x1000 0x2011008 0x4>;
>>
>> 	interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
>> 	interrupt-names = "ack", "err", "wakeup";
>> };
>>
>> pm8921_s1: pm8921-s1 {
>> 	compatible = "qcom,rpm-pm8921-smps";
>> 	
>> 	regulator-min-microvolt = <1225000>;
>> 	regulator-max-microvolt = <1225000>;
>> 	regulator-always-on;
>>
>> 	qcom,rpm = <&rpm QCOM_RPM_PM8921_S1>;
>> 	qcom,switch-mode-frequency = <3200000>;
>> 	qcom,hpm-threshold = <100000>;
>> };
>>
>> This would simplify the driver code too and handle the interface neatly then depending on device hierarchy.
>> rpm would be a interface library to the clients. Makes the drivers more independent, and re-usable if we do this way.
>>
>> ??
>
> One reason to go with sub nodes is it creates a proper driver ordering dependency as I assume rpm driver will end up calling of_platform_populate for the sub nodes at the point that the RPM driver is ready.  We could do this with deferred probe but doing it explicitly is better in my opinion as it limits the amount of time between when RPM is ready vs when the children can start doing things
>

I agree, there might be a win. But Am not sure to what extent this win 
is a win to rpm driver, as a side effect this brings other 
responsibilities to the rpm driver like adding sub-device power 
management awareness, device life cycle management to the rpm driver.

Only thing which made me think of this approach is the number of sub 
nodes it would end up with and passing ID using reg property.

Thanks,
srini

> - k
>
