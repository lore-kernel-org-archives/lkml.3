Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3IZVKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:10:15 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58509 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3IZVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:10:11 -0400
Message-ID: <5244A2AA.6050901@gmail.com>
Date: Thu, 26 Sep 2013 16:10:02 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv4 2/3] ARM: msm: Add support for APQ8074 Dragonboard
References: <1379992406-3541-1-git-send-email-rvaswani@codeaurora.org> <1379992406-3541-2-git-send-email-rvaswani@codeaurora.org> <4E7868D6-56CB-4AF8-8EBF-069966899C23@codeaurora.org> <5243652F.7090408@codeaurora.org> <B0F416B8-042A-49F1-81E9-B217F02AAD1E@codeaurora.org> <52447779.3010908@codeaurora.org> <52448852.9050608@codeaurora.org> <50877C70-6066-4E87-9DEA-9F29D098525B@codeaurora.org>
In-Reply-To: <50877C70-6066-4E87-9DEA-9F29D098525B@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 02:33 PM, Kumar Gala wrote:
> 
> On Sep 26, 2013, at 2:17 PM, Rohit Vaswani wrote:
> 
>> On 9/26/2013 11:05 AM, Rohit Vaswani wrote:
>>> On 9/26/2013 9:37 AM, Kumar Gala wrote:
>>>> <snip>
>>> 
>>>> +++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts @@ -0,0
>>>> +1,6 @@ +/include/ "qcom-msm8974.dtsi" + +/ { +    model =
>>>> "Qualcomm APQ8074 Dragonboard"; +    compatible =
>>>> "qcom,apq8074-dragonboard", "qcom,apq8074"; +}; diff --git
>>>> a/arch/arm/boot/dts/qcom-msm8974.dtsi
>>>> b/arch/arm/boot/dts/qcom-msm8974.dtsi new file mode 100644 
>>>> index 0000000..f04b643 --- /dev/null +++
>>>> b/arch/arm/boot/dts/qcom-msm8974.dtsi @@ -0,0 +1,35 @@ 
>>>> +/dts-v1/; + +/include/ "skeleton.dtsi" + +/ { +    model =
>>>> "Qualcomm MSM8974"; +    compatible = "qcom,msm8974"; +
>>>> interrupt-parent = <&intc>; + +    soc: soc { };
>>>>>> We should have a unit address here:
>>>>>> 
>>>>>> soc: soc@FOOBAR {
>>>>>> 
>>>>>> also, split out the curly braces so any future patches do
>>>>>> have to muck with that.
>>>>>> 
>>>>>> };
>>>>>> 
>>>>> Im not sure I understand the reasoning behind the unit
>>>>> address for soc ?
>>>> Its fairly standard practice and there is a fair amount of
>>>> discussion about the lack of a unit address for memory nodes.
>>>> 
>>> That still doesn't really answer anything :) - and I couldn't
>>> find any discussions about this either. I don't see anybody in
>>> upstream adding an address to soc except sun. What is that
>>> address supposed to be for - what does it mean ? The soc is way
>>> of encapsulating meaningful blocks  for the particular SoC.
>> 
>> I see the mail from Stephen Warren for adding a check stating that
>> 
>> "ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that
>> any node that has a reg property must include a unit address in its
>> name with value matching the first entry in its reg property.
>> Conversely, if a node does not have a reg property, the node name
>> must not include a unit address."
>> 
>> The soc node we have does not have a reg property ?
> 
> Not 100% sure what people will decide on this.  There are a number of
> examples on the PPC side (arch/powerpc/boot/dts) that are soc@ADDR,
> but they don't typically have "reg" properties at the soc level.

No, but you may have a ranges property which is related.

I've just hit this on highbank in needing to add a second bank of
peripherals for midway. So my vote would be to have unit address.

Rob
