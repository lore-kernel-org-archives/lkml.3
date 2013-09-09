Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3IIVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:25:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49277 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3IIVZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:25:16 -0400
Subject: Re: [PATCHv3 1/2] ARM: msm: Add support for APQ8074 Dragonboard
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <522E3BC9.1030105@wwwdotorg.org>
Date: Mon, 9 Sep 2013 16:25:15 -0500
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <CA05A23E-41CF-4EC6-BB2D-36105048700B@codeaurora.org>
References: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org> <20130906215051.GA29253@quad.lixom.net> <522E09E6.8040300@codeaurora.org> <FFE100A7-8AD6-4E0D-9F64-120DA3564F89@codeaurora.org> <522E21A8.4060408@wwwdotorg.org> <FA33E8F4-3F85-4D8B-83E1-96F5A8F76CE6@codeaurora.org> <522E3BC9.1030105@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 9, 2013, at 4:21 PM, Stephen Warren wrote:

> On 09/09/2013 01:48 PM, Kumar Gala wrote:
>> 
>> On Sep 9, 2013, at 2:29 PM, Stephen Warren wrote:
>> 
>>> On 09/09/2013 01:17 PM, Kumar Gala wrote:
>>>> 
>>>> On Sep 9, 2013, at 12:48 PM, Rohit Vaswani wrote:
>>>> 
>>>>> On 9/6/2013 2:50 PM, Olof Johansson wrote:
>>>>>> Hi,
>>>>>> 
>>>>>> Some comments below.
>>>>>> 
>>>>>> On Fri, Sep 06, 2013 at 12:32:22PM -0700, Rohit Vaswani wrote:
>>>>>>> This patch adds basic board support for APQ8074 Dragonboard
>>>>>>> <snip>
>>>>>>> dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
>>>>>>> -	msm8960-cdp.dtb
>>>>>>> +	msm8960-cdp.dtb \
>>>>>>> +	apq8074-dragonboard.dtb
>>>>>> Please add boards alphabetically.
>>>>> Will do.
>>>>>> 
>>>>>>> dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>>>>>> 	armada-370-mirabox.dtb \
>>>>>>> 	armada-370-rd.dtb \
>>>>>>> diff --git a/arch/arm/boot/dts/apq8074-dragonboard.dts b/arch/arm/boot/dts/apq8074-dragonboard.dts
>>>>>>> new file mode 100644
>>>>>>> index 0000000..5b7b6a0
>>>>>>> --- /dev/null
>>>>>>> +++ b/arch/arm/boot/dts/apq8074-dragonboard.dts
>>>>>> arch/arm/boot/dts/ is getting really crowded. It's been working best if the SoC
>>>>>> family or vendor is used as a prefix to keep things a bit more organized. In
>>>>>> that spirit, prefixing these with msm-<foo> makes sense. Can you please do so?
>>>>> 
>>>>> Sure. But the board is called an APQ8074 and we wanted to keep the naming consistent with that.
>>>> 
>>>> If we do this we should use qcom, not msm as the prefix.  Match the device tree vendor prefix.
>>> 
>>> Hmm. It'd be nice for the filenames to be ${soc}-${board} so that e.g.
>>> U-Boot can easily calculate the DTB filename based on its soc/board
>>> environment variables... Luckily in my case for Tegra, all the Tegra
>>> chip names start with "Tegra", so we already sort all our DTB filenames
>>> together in the directory listing:-)
>> 
>> u-boot's not supported on MSM platforms, so not sure what purpose this serves.
> 
> Presumably that's just because nobody has ported the code; it could be
> supported couldn't it?

In theory.

>> we might want to just introduce vendor dirs so its arch/arm/boot/dts/{vendor}/{soc}-{board}
> 
> That seems reasonable to me, although people will complain about the
> files moving again. Perhaps it's worth doing that as part of the move of
> *.dts out of the kernel?

Agreed, probably best since we'll probably be merging different arch dts's as well at that point

>> Not sure if we want to argue about {vendor} vs {sub-arch}.
> 
> sub-arch being the mach-xxx/plat-xxx directory? If so, I think that's a
> Linux-ism that shouldn't affect the DT directory layout.

Yeah, the mach-xxx/plat-xxx dir, and agree that it being a Linux-ism we shouldn't apply to this.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

