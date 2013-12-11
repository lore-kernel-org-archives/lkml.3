Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3LKBtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:49:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47193 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3LKBtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:49:49 -0500
Message-ID: <52A7C4BB.6000701@codeaurora.org>
Date: Tue, 10 Dec 2013 17:49:47 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com> <1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com> <52A24E08.706@codeaurora.org> <20131210084140.GF11990@sonymobile.com>
In-Reply-To: <20131210084140.GF11990@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 00:41, Bjorn Andersson wrote:
> On Fri 06 Dec 14:22 PST 2013, Stephen Boyd wrote:
>
>>> +config PINCTRL_MSM8X74
>>> +	bool "Qualcomm 8x74 pin controller driver"
>>> +	select PINCTRL_MSM
>> No help?
>>
> I could write something up, although I guess someone will add a
> select PINCTRL_MSM8X74 in the mach-msm Kconfig and then we're done
> with it.

I hope nobody selects the PINCTRL_MSM8X74 config. It's certainly not
necessary to boot into a ramdisk. I thought checkpatch complained about
missing help for visible options.

>
>> Also, do we ever plan to have anything more than the gpio pins and the
>> sdc pins? It seems like we spend a lot of space describing exactly the
>> same thing in these structs for each of the 146 gpio pins when we could
>> just know that range 0 to 146 is gpio pins and have different code for
>> that part vs the 6 or something sd pins.
>>
> We have to have a pingroup list, so I did look at having that list
> referencing a common object with the gpio/sdc specific data.
>
> But just having it in one large blob is the way that other pinctrl
> drivers does it and hence a common problem to pinctrl and multi-platform
> arm support.

I don't follow what Linus is recommending. How could
.gpio_request_enable()/.gpio_disable_free() help us here?

>
> I have not seen any code in the open referencing the other pins, so I
> left them out for now.
>
>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

