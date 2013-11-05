Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3KERMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:12:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58513 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3KERM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:12:29 -0500
Subject: Re: [PATCH 02/11] devicetree: bindings: Document Qualcomm cpus and enable-method
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131104173606.GL21983@codeaurora.org>
Date: Tue, 5 Nov 2013 11:12:27 -0600
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <378446F7-DC51-448D-AF99-93F98CEAFB03@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-3-git-send-email-sboyd@codeaurora.org> <CAL_JsqLObXEWJJ=SuifTjpPz9qTW0n43fyQNA-vjLNeLy-7-XA@mail.gmail.com> <20131104173606.GL21983@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 4, 2013, at 11:36 AM, Stephen Boyd wrote:

> On 11/01, Rob Herring wrote:
>> On Fri, Nov 1, 2013 at 5:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> From: Rohit Vaswani <rvaswani@codeaurora.org>
>>> 
>>> Scorpion and Krait are Qualcomm cpus. These cpus don't use the
>>> spin-table enable-method. Instead they rely on mmio register
>>> accesses to enable power and clocks to bring CPUs out of reset.
>>> 
>>> Cc: <devicetree@vger.kernel.org>
>>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>>> [sboyd: Split off into separate patch, renamed method to
>>> qcom,mmio]
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>> 
>>> This slightly conflicts with my krait EDAC series.
>>> 
>>> Documentation/devicetree/bindings/arm/cpus.txt | 3 +++
>>> 1 file changed, 3 insertions(+)
>>> 
>>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
>>> index 37258f9..e2969fa2 100644
>>> --- a/Documentation/devicetree/bindings/arm/cpus.txt
>>> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
>>> @@ -44,6 +44,8 @@ For the ARM architecture every CPU node must contain the following properties:
>>>                "marvell,mohawk"
>>>                "marvell,xsc3"
>>>                "marvell,xscale"
>>> +               "qcom,scorpion"
>>> +               "qcom,krait"
>>> 
>>> And the following optional properties:
>>> 
>>> @@ -52,6 +54,7 @@ And the following optional properties:
>>>                 different types of cpus.
>>>                 This should be one of:
>>>                 "spin-table"
>>> +                "qcom,mmio"
>> 
>> Not exactly specific. How would you handle variations in the enable
>> method? The mmio method to enable is tied to the core type or SOC
>> type?
> 
> Variations in the enable method are handled by searching for
> another node with different compatible strings. Later on in this
> series you'll see that we search for gcc-8660, kpss-acc-v1, or
> kpps-acc-v2. Once we find one of these nodes we perform the
> correct cold boot routine.
> 
> I'm actually considering renaming this to "qcom,cold-boot". We
> could further extend the enable-metho property to allow
> "qcom,warm-boot" and then for cases like kexec we could make the
> enable method be warm boot and our smp code could be smart enough
> to know to skip the whole cold boot sequence.


I think this should be more specific than just 'qcom,mmio' or 'qcom,warm-boot'.  It should be 'qcom,kpss-acc-v1' or 'qcom-gcc-8660'.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

