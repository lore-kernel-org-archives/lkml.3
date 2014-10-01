Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJARyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:54:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48748 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJARyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:54:19 -0400
Message-ID: <542C3FCA.2010006@codeaurora.org>
Date: Wed, 01 Oct 2014 10:54:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp
 implementations
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org> <1411076592-6157-3-git-send-email-sboyd@codeaurora.org> <20140918224625.GF5182@n2100.arm.linux.org.uk> <541C74C1.9060504@codeaurora.org>
In-Reply-To: <541C74C1.9060504@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/14 11:24, Stephen Boyd wrote:
> On 09/18/14 15:46, Russell King - ARM Linux wrote:
>> On Thu, Sep 18, 2014 at 02:43:11PM -0700, Stephen Boyd wrote:
>>> diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
>>> index f4ab34fd4f72..76d3f6907cce 100644
>>> --- a/arch/arm/include/asm/vfp.h
>>> +++ b/arch/arm/include/asm/vfp.h
>>> @@ -21,7 +21,7 @@
>>>  #define FPSID_FORMAT_MASK	(0x3  << FPSID_FORMAT_BIT)
>>>  #define FPSID_NODOUBLE		(1<<20)
>>>  #define FPSID_ARCH_BIT		(16)
>>> -#define FPSID_ARCH_MASK		(0xF  << FPSID_ARCH_BIT)
>>> +#define FPSID_ARCH_MASK		(0x7F  << FPSID_ARCH_BIT)
>> This is incorrect.  On VFPv2, the architecture field is four bits long.
>> As you can see from the above, bit 20 indicates that there are no
>> double operations provided, and the next two bits indicate the FSTMX/
>> FLDMX format.
>>
>> I know that you're changing this to conform with the ARM ARM, but we
>> have to consider that before VFP was subsumed into the ARM ARM, this
>> register had the format described as per this file, and these other
>> bits may be set for an ARM part.  Including these bits in the mask
>> means that we will mis-identify these older parts as VFPv3.
>>
>> Welcome to the lack of standardisation!
>>
> Thank you for the warm welcome! I looked at the TRMs for ARM11 and ARM9.
> I can't find anywhere where VFPv2 is supported and these bits are set.
>
> Bits 22-16 of FPSID:
>
> ARM1136r1p5:     0x01
> ARM1136r1p3:     0x01
> ARM1176:         0x01
> ARM11MPCorer2p0: 0x01
> ARM11MPCorer1p0: 0x01
> ARM1156:         0x01
> ARM9:            0x01
>
>
> Do you, or anyone else, know of other implementations? I *hope* that
> this same exercise was done by the VFP architects before they
> re-purposed bits but who knows. If nobody is actually setting these
> higher bits then is there any problem widening the mask (besides it
> being slightly confusing)?
>

Any thoughts?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

