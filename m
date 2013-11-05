Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3KERfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:35:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60237 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KERfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:35:30 -0500
Message-ID: <52792C60.2030405@codeaurora.org>
Date: Tue, 05 Nov 2013 09:35:28 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/11] devicetree: bindings: Document Qualcomm cpus and
 enable-method
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-3-git-send-email-sboyd@codeaurora.org> <CAL_JsqLObXEWJJ=SuifTjpPz9qTW0n43fyQNA-vjLNeLy-7-XA@mail.gmail.com> <20131104173606.GL21983@codeaurora.org> <378446F7-DC51-448D-AF99-93F98CEAFB03@codeaurora.org>
In-Reply-To: <378446F7-DC51-448D-AF99-93F98CEAFB03@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 09:12, Kumar Gala wrote:
> On Nov 4, 2013, at 11:36 AM, Stephen Boyd wrote:
>
>> On 11/01, Rob Herring wrote:
>>> On Fri, Nov 1, 2013 at 5:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> From: Rohit Vaswani <rvaswani@codeaurora.org>
>>>>
>>>> Scorpion and Krait are Qualcomm cpus. These cpus don't use the
>>>> spin-table enable-method. Instead they rely on mmio register
>>>> accesses to enable power and clocks to bring CPUs out of reset.
>>>>
>>>> Cc: <devicetree@vger.kernel.org>
>>>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>>>> [sboyd: Split off into separate patch, renamed method to
>>>> qcom,mmio]
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> ---
>>>>
>>>> This slightly conflicts with my krait EDAC series.
>>>>
>>>> Documentation/devicetree/bindings/arm/cpus.txt | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
>>>> index 37258f9..e2969fa2 100644
>>>> --- a/Documentation/devicetree/bindings/arm/cpus.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
>>>> @@ -44,6 +44,8 @@ For the ARM architecture every CPU node must contain the following properties:
>>>>                "marvell,mohawk"
>>>>                "marvell,xsc3"
>>>>                "marvell,xscale"
>>>> +               "qcom,scorpion"
>>>> +               "qcom,krait"
>>>>
>>>> And the following optional properties:
>>>>
>>>> @@ -52,6 +54,7 @@ And the following optional properties:
>>>>                 different types of cpus.
>>>>                 This should be one of:
>>>>                 "spin-table"
>>>> +                "qcom,mmio"
>>> Not exactly specific. How would you handle variations in the enable
>>> method? The mmio method to enable is tied to the core type or SOC
>>> type?
>> Variations in the enable method are handled by searching for
>> another node with different compatible strings. Later on in this
>> series you'll see that we search for gcc-8660, kpss-acc-v1, or
>> kpps-acc-v2. Once we find one of these nodes we perform the
>> correct cold boot routine.
>>
>> I'm actually considering renaming this to "qcom,cold-boot". We
>> could further extend the enable-metho property to allow
>> "qcom,warm-boot" and then for cases like kexec we could make the
>> enable method be warm boot and our smp code could be smart enough
>> to know to skip the whole cold boot sequence.
>
> I think this should be more specific than just 'qcom,mmio' or 'qcom,warm-boot'.  It should be 'qcom,kpss-acc-v1' or 'qcom-gcc-8660'.
>

Do you have any reasons why? I don't see why we need to keep adding more
and more enable-methods every time the subsystem surrounding the CPU
changes. The method is the same, write some registers to power up the
CPU for the first time (cold boot) or ping the CPU to wake it up
(warmboot). The only difference is where those registers live and a
slight variation in the sequence that we perform.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

