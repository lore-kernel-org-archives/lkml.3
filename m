Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab3GaANH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:13:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43785 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3GaANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:13:05 -0400
Message-ID: <51F85690.9060701@codeaurora.org>
Date: Tue, 30 Jul 2013 17:13:04 -0700
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
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com> <51F82BCC.1080409@codeaurora.org> <51F82E9F.9010309@wwwdotorg.org> <51F853BF.9040007@codeaurora.org> <51F8556A.1010300@wwwdotorg.org>
In-Reply-To: <51F8556A.1010300@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2013 5:08 PM, Stephen Warren wrote:
> On 07/30/2013 06:01 PM, Hanumant Singh wrote:
>> On 7/30/2013 2:22 PM, Stephen Warren wrote:
>>> On 07/30/2013 03:10 PM, hanumant wrote:
>>> ...
>>>> We actually have the same TLMM pinmux used by several socs of a family.
>>>> The number of pins on each soc may vary.
>>>> Also a given soc gets used in a number of boards.
>>>> The device tree for a given soc is split into the different boards that
>>>> its in ie the boards inherit a common soc.dtsi but have separate dts.
>>>> The boards for the same soc may use different pin groups for
>>>> accomplishing a function, since we have multiple i2c, spi uart etc
>>>> peripheral instances on a soc. A different instance of each of the above
>>>> peripherals, can be used in different boards, utilizing different
>>>> or subset of same pin groups.
>>>> Thus I would need to have multiple C files for one soc, based on the
>>>> boards that it goes into.
>>>
>>> The pinctrl driver should be exposing the raw capabilities of the HW.
>>> All the board-specific configuration should be expressed in DT. So, the
>>> driver shouldn't have to know anything about different boards at
>>> compile-time.
>>>
>> I agree, so I wanted to keep the pin grouping information in DT, we
>> already have a board based differentiation of dts files in DT, for the
>> same soc.
>
> That's the opposite of what I was saying. Pin groups are a feature of
> the SoC design, not the board.
>
Sorry I guess I wasn't clear.
Right now I have a soc-pinctrl.dtsi containing pin groupings.
This will be "inherited" by soc-boardtype.dts.
The pinctrl client device nodes in soc-boardtype.dts will point to pin 
groupings in soc-pinctrl.dtsi that are valid for that particular boardtype.
Is this a valid design?

Thanks
Hanumant
that are valid for that


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
