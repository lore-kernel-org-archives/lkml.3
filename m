Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaE1Jle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:41:34 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36312 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaE1Jlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:41:32 -0400
Message-ID: <5385AF47.8030909@linaro.org>
Date: Wed, 28 May 2014 10:41:27 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 10/13] mmc: mmci: add Qcom specifics of clk and datactrl
 registers.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849556-7501-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFpyZU207A515T9xd153DBWGpjP8cqiAZfwvkx7Drefc5A@mail.gmail.com> <5383B44F.30608@linaro.org>
In-Reply-To: <5383B44F.30608@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 26/05/14 22:38, Srinivas Kandagatla wrote:
>>>   2 files changed, 28 insertions(+)
>>>
>>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>>> index 17e7f6a..6434f5b1 100644
>>> --- a/drivers/mmc/host/mmci.c
>>> +++ b/drivers/mmc/host/mmci.c
>>> @@ -185,6 +185,10 @@ static struct variant_data variant_qcom = {
>>>          .fifosize               = 16 * 4,
>>>          .fifohalfsize           = 8 * 4,
>>>          .clkreg                 = MCI_CLK_ENABLE,
>>> +       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
>>> +                                 MCI_QCOM_CLK_FEEDBACK_CLK,
>>
>> Obviously I don't have the in-depth knowledge about the Qcom variant,
>> but comparing the ST variant here made me think.
>>
>> Using the feeback clock internal logic in the ST variant, requires the
>> corresponding feedback clock pin signal on the board, to be
>> routed/connected. Typically we used this for SD cards, which involved
>> using an external level shifter circuit.
>>
>> Is it correct to enable this bit for all cases, including eMMC?
>>
> You are correct, FBCLK should specific to the board, and I will try to
> do something on the same lines as ST variant in next version.
I get lot of I/O errors when I remove this flag for test.

I rechecked schematics and datasheet, the feedback clk that we refer 
here is the the feedback clk from CLK pad, there is no separate input 
pad for fbclk. So I think this is internally feedbacked clk.

This selection is configuring bits to latch data and command coming in 
using feedback clock from CLK pad.

I will make sure that the macro is named more appropriately to reflect 
the same.

thanks,
srini
