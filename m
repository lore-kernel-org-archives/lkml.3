Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaFXR5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:57:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37159 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaFXR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:57:47 -0400
Message-ID: <53A9BC18.2090106@codeaurora.org>
Date: Tue, 24 Jun 2014 10:57:44 -0700
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com> <4545972.cM7IP1qTXQ@wuerfel> <53A4C0C9.2050908@codeaurora.org> <20140624091808.GC26013@arm.com>
In-Reply-To: <20140624091808.GC26013@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2014 2:18 AM, Will Deacon wrote:
> On Sat, Jun 21, 2014 at 12:16:25AM +0100, Olav Haugan wrote:
>> On 5/30/2014 12:06 PM, Arnd Bergmann wrote:
>>> On Friday 30 May 2014 08:16:05 Rob Herring wrote:
>>>> Presumably the ID would be the streamID on ARM's SMMU. How would a
>>>> master with 8 streamIDs be described? This is what Calxeda midway has
>>>> for SATA and I would expect that to be somewhat common. Either you
>>>> need some ID masking or you'll have lots of duplication when you have
>>>> windows.
>>>
>>> I don't understand the problem. If you have stream IDs 0 through 7,
>>> you would have
>>>
>>> 	master@a {
>>> 		...
>>> 		iommus = <&smmu 0>;
>>> 	};
>>>
>>> 	master@b {
>>> 		...
>>> 		iommus = <&smmu 1;
>>> 	};
>>>
>>> 	...
>>>
>>> 	master@12 {
>>> 		...
>>> 		iommus = <&smmu 7;
>>> 	};
>>>
>>> and you don't need a window at all. Why would you need a mask of
>>> some sort?
>>
>> We have multiple-master SMMUs and each master emits a variable number of
>> StreamIDs. However, we have to apply a mask (the ARM SMMU spec allows
>> for this) to the StreamIDs due to limited number of StreamID 2 Context
>> Bank entries in the SMMU. If my understanding is correct we would
>> represent this in the DT like this:
>>
>> 	iommu {
>> 		#address-cells = <2>;
>> 		#size-cells = <0>;
>> 	};
>>
>> 	master@a {
>> 		...
>> 		iommus = <&iommu StreamID0 MASK0>,
>> 			 <&iommu StreamID1 MASK1>,
>> 			 <&iommu StreamID2 MASK2>;
>> 	};
> 
> Stupid question, but why not simply describe the masked IDs? What use does
> the `raw' ID have to Linux?

We do describe the masked StreamID (SID) but we need to specify the mask
that the SMMU should apply to the incoming SIDs, right?

We have a bus master that emits 43 unique SIDs. However, we have only 40
SMMU_SMRn registers in the SMMU. So we need to mask out some of the
incoming SID bits so that the 43 SIDs can match one of 40 entries in the
SMR.

Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
