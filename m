Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3F0PRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:17:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42025 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3F0PRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:17:22 -0400
Message-ID: <51CC577D.9020909@codeaurora.org>
Date: Thu, 27 Jun 2013 08:17:17 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1371851554-4492-1-git-send-email-hanumant@codeaurora.org> <CACRpkdbcscJYRgTQv_4SdR3i3PJwWfYQu=OonABz3xyLO+3Ubg@mail.gmail.com> <51C9D645.6030609@codeaurora.org> <CACRpkdZjwLdUE2=Wu1ySU5mFf7Kt7_LS88-bJM6zv5=p_OMYHA@mail.gmail.com>
In-Reply-To: <CACRpkdZjwLdUE2=Wu1ySU5mFf7Kt7_LS88-bJM6zv5=p_OMYHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 01:26 AM, Linus Walleij wrote:
> On Tue, Jun 25, 2013 at 7:41 PM, hanumant <hanumant@codeaurora.org> wrote:
>> On 06/24/2013 05:18 AM, Linus Walleij wrote:
> 
>>>> +  The following pin configurations are properties are supported by SDC pins
>>>> +  - qcom,sdc1-clk-pull: Pull up/down configuration SDC1 clock pin.
>>>> +  - qcom,sdc1-clk-drv: Drive strength configuration for SDC1 clock pin.
>>>> +  - qcom,sdc1-cmd-pull: Pull up/down configuration for SDC1 command pin.
>>>> +  - qcom,sdc1-cmd-drv: Drive strength configuration for SDC1 command pin.
>>>> +  - qcom,sdc1-data-pull: Pull up/down configuration for SDC1 data pin.
>>>> +  - qcom,sdc1-data-drv: Drive strength configuration for SDC1 data pin.
>>>> +  - qcom,sdc2-clk-pull: Pull up/down configuration SDC2 clock pin.
>>>> +  - qcom,sdc2-clk-drv: Drive strength configuration for SDC2 clock pin.
>>>> +  - qcom,sdc2-cmd-pull: Pull up/down configuration for SDC2 command pin.
>>>> +  - qcom,sdc2-cmd-drv: Drive strength configuration for SDC2 command pin.
>>>> +  - qcom,sdc2-data-pull: Pull up/down configuration for SDC2 data pin.
>>>> +  - qcom,sdc2-data-drv: Drive strength configuration for SDC2 data pin.
>>>
>>> I don't understand why each sdc thing needs its own definition
>>> for everything. Please use the generic pin config bindings, call the
>>> generic parser function and then reject if someone tries to config
>>> something that is not supported.
>>
>> The register semantics of SDC1 clk, command, and data lines, pull up and
>> drive strength attributes differ from SDC2 clk, command and data lines.
> 
> The register semantics does not have anything to do with the
> representation in the device tree. The register semantics is a matter
> for the driver, the device tree tells how to configure that driver,
> the idea is not to name all species of config registers in the device
> tree but to configure them, logically.

Fair enough. I think this is possible to do.
> 
>> In general the TLMM v3 has more pin types then just the general/multi
>> purpose(gp) and SDC pin types above.
>> There are some pin types on the TLMM, whose config attributes do not
>> fall under the cattegories supported by generic pin config.
> 
> One does not exclude the other. Some aspect of a pin
> may be configured using the generic bindings, some aspect
> need vendor-specific extensions.
> 
>> These attributes in some cases happen to be protocol specific.
>> Hence I would prefer to go with a custom config pack and unpack
>> implementation rather then the generic one.
> 
> I disagree, but I'm open to negotiations :-)

How does this sound?. If the attributes of a pin type can be defined
using the generic configs, I will use the generic configs and parser.
If the attributes are entirely protocol/MSM specific, I will use custom
configs and parsers. In terms of attributes of pins, all the pin types
on the TLMM fall into either one of those categories, but never in both.

Thanks
Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, hosted by The Linux Foundation
-- 
