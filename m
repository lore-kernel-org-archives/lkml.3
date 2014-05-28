Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaE1KDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:03:18 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:46037 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaE1KDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <5385AF47.8030909@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849556-7501-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CAPDyKFpyZU207A515T9xd153DBWGpjP8cqiAZfwvkx7Drefc5A@mail.gmail.com>
	<5383B44F.30608@linaro.org>
	<5385AF47.8030909@linaro.org>
Date: Wed, 28 May 2014 12:03:15 +0200
Message-ID: <CAPDyKFp5mJt7mWYEmknp=E62pM3xfmj1+B=B2dn9BLPfAJqYhQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] mmc: mmci: add Qcom specifics of clk and
 datactrl registers.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 11:41, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> Hi Ulf,
>
>
> On 26/05/14 22:38, Srinivas Kandagatla wrote:
>>>>
>>>>   2 files changed, 28 insertions(+)
>>>>
>>>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>>>> index 17e7f6a..6434f5b1 100644
>>>> --- a/drivers/mmc/host/mmci.c
>>>> +++ b/drivers/mmc/host/mmci.c
>>>> @@ -185,6 +185,10 @@ static struct variant_data variant_qcom = {
>>>>          .fifosize               = 16 * 4,
>>>>          .fifohalfsize           = 8 * 4,
>>>>          .clkreg                 = MCI_CLK_ENABLE,
>>>> +       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
>>>> +                                 MCI_QCOM_CLK_FEEDBACK_CLK,
>>>
>>>
>>> Obviously I don't have the in-depth knowledge about the Qcom variant,
>>> but comparing the ST variant here made me think.
>>>
>>> Using the feeback clock internal logic in the ST variant, requires the
>>> corresponding feedback clock pin signal on the board, to be
>>> routed/connected. Typically we used this for SD cards, which involved
>>> using an external level shifter circuit.
>>>
>>> Is it correct to enable this bit for all cases, including eMMC?
>>>
>> You are correct, FBCLK should specific to the board, and I will try to
>> do something on the same lines as ST variant in next version.
>
> I get lot of I/O errors when I remove this flag for test.

Running eMMC I suppose?

>
> I rechecked schematics and datasheet, the feedback clk that we refer here is
> the the feedback clk from CLK pad, there is no separate input pad for fbclk.
> So I think this is internally feedbacked clk.
>
> This selection is configuring bits to latch data and command coming in using
> feedback clock from CLK pad.

Seems like it's strange to have this bit configurable then. I guess it
would  be hard to tell under what circumstances you don't want this
bit set.

Anyway, it's not a big deal to me - let's keep it as is for now.

Kind regards
Ulf Hansson

>
> I will make sure that the macro is named more appropriately to reflect the
> same.
>
> thanks,
> srini
