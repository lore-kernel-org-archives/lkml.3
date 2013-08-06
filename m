Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3HFXpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:45:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47036 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3HFXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:45:19 -0400
Message-ID: <52018A8D.70608@codeaurora.org>
Date: Tue, 06 Aug 2013 16:45:17 -0700
From: Hanumant Singh <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        ext Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com> <51F82BCC.1080409@codeaurora.org> <51F82E9F.9010309@wwwdotorg.org> <51F853BF.9040007@codeaurora.org> <51F8556A.1010300@wwwdotorg.org> <51F85690.9060701@codeaurora.org> <51F88BAC.2020001@wwwdotorg.org> <51F969A5.5020405@codeaurora.org> <51F97C47.5020202@wwwdotorg.org> <51F9A934.404@codeaurora.org>
In-Reply-To: <51F9A934.404@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/2013 5:17 PM, Hanumant Singh wrote:
> On 7/31/2013 2:06 PM, Stephen Warren wrote:
>> On 07/31/2013 01:46 PM, Hanumant Singh wrote:
>>> On 7/30/2013 8:59 PM, Stephen Warren wrote:
>>>> On 07/30/2013 06:13 PM, Hanumant Singh wrote:
>>>>> On 7/30/2013 5:08 PM, Stephen Warren wrote:
>>>>>> On 07/30/2013 06:01 PM, Hanumant Singh wrote:
>>>>>>> On 7/30/2013 2:22 PM, Stephen Warren wrote:
>>>>>>>> On 07/30/2013 03:10 PM, hanumant wrote:
>>>>>>>> ...
>>>>>>>>> We actually have the same TLMM pinmux used by several socs of a
>>>>>>>>> family.
>>>>>>>>> The number of pins on each soc may vary.
>>>>>>>>> Also a given soc gets used in a number of boards.
>>>>>>>>> The device tree for a given soc is split into the different boards
>>>>>>>>> that
>>>>>>>>> its in ie the boards inherit a common soc.dtsi but have separate
>>>>>>>>> dts.
>>>>>>>>> The boards for the same soc may use different pin groups for
>>>>>>>>> accomplishing a function, since we have multiple i2c, spi uart etc
>>>>>>>>> peripheral instances on a soc. A different instance of each of the
>>>>>>>>> above
>>>>>>>>> peripherals, can be used in different boards, utilizing different
>>>>>>>>> or subset of same pin groups.
>>>>>>>>> Thus I would need to have multiple C files for one soc, based
>>>>>>>>> on the
>>>>>>>>> boards that it goes into.
>>>>>>>>
>>>>>>>> The pinctrl driver should be exposing the raw capabilities of
>>>>>>>> the HW.
>>>>>>>> All the board-specific configuration should be expressed in DT.
>>>>>>>> So, the
>>>>>>>> driver shouldn't have to know anything about different boards at
>>>>>>>> compile-time.
>>>>>>>>
>>>>>>> I agree, so I wanted to keep the pin grouping information in DT, we
>>>>>>> already have a board based differentiation of dts files in DT,
>>>>>>> for the
>>>>>>> same soc.
>>>>>>
>>>>>> That's the opposite of what I was saying. Pin groups are a feature of
>>>>>> the SoC design, not the board.
>>>>>>
>>>>> Sorry I guess I wasn't clear.
>>>>> Right now I have a soc-pinctrl.dtsi containing pin groupings.
>>>>> This will be "inherited" by soc-boardtype.dts.
>>>>> The pinctrl client device nodes in soc-boardtype.dts will point to pin
>>>>> groupings in soc-pinctrl.dtsi that are valid for that particular
>>>>> boardtype.
>>>>> Is this a valid design?
>>>>
>>>> OK, so you have two types of child node inside the pinctrl DT node;
>>>> some
>>>> define the pin groups the SoC has (in soc.dtsi) and some define pinctrl
>>>> states that reference the pin group nodes and are referenced by the
>>>> client nodes.
>>>>
>>>> That's probably fine. However, I'd still question putting the pin group
>>>> nodes in DT at all; I'm not convinced it's better than just putting
>>>> those into the driver itself. You end up with the same data tables
>>>> after
>>>> parsing the DT anyway.
>>>>
>>>
>>> Any feedback for the rest of the patch?
>>
>> I'm certainly waiting for this aspect of the patch to be resolved; I
>> think it will impact the rest of the patch so much that it's not worth
>> reviewing until we decide on where to represent the pin groups (some DT
>> parsing could would be removed if we put the pin group definitions into
>> the driver, hence wouldn't need to be reviewed, and likewise there's be
>> some new tables to review).
>>
>
> I am trying to look at examples of what you are suggesting.
> I was looking at the exynos implementation, and just from a brief glance
> it seems like there too the pin grouping is being specified in the
> device tree, using what looks like labels of the pins.
> The labels are matched to group structures in soc specific files?
>
> By having the pin groupings in DT I am able to reuse the driver without
> any SOC based code bloat.
> As I mentioned earlier, we have entire families of SOCs using the same
> TLMM hardware.
> Its not a guarantee that for a given TLMM version,
> the pin groupings on that hardware are the same for every SOC that its
> in. Its infact most likely that I wont be able to use the pin groupings
> from one SOC to the next even if they both use the same TLMM.
> It will very quickly lead to a bloat of
> pinctrl-<msm_soc>.c (containing the pin groupings replicated for each soc)
> which use TLMM version specific register programming implementation
> pinctrl-tlmm-<version>.c
> and the DT parsing and interface to framework (which remains unchanged).
> pinctrl-msm.c.
>
> Thanks
> Hanumant
>

Any comments on this?

Thanks
Hanumant


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
