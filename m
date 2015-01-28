Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbbA1UVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:21:35 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55076 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbbA1UVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:21:32 -0500
MIME-Version: 1.0
In-Reply-To: <54C905CA.80908@i2se.com>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
	<CAHrpEqQ-eoqM3W1hYcS6EPTmur1FSfm8TeEjYrtZ+PquavL86w@mail.gmail.com>
	<201501220039.02073.marex@denx.de>
	<20150128015131.22722.22882@quantum>
	<CAHrpEqSFfdWsCif_wZO2ToRpwOuC2yt45+HwOpGgv+B=EwKTCw@mail.gmail.com>
	<54C905CA.80908@i2se.com>
Date: Wed, 28 Jan 2015 10:10:17 -0600
Message-ID: <CAHrpEqQ=7EZNzpt1tmjBUrH8oDzjQmCCOrZaH8MBdmvV1+uFZg@mail.gmail.com>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
From: Zhi Li <lznuaa@gmail.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Mike Turquette <mturquette@linaro.org>, Marek Vasut <marex@denx.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, harald@ccbib.org,
        Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 9:52 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi,
>
> Am 28.01.2015 um 04:36 schrieb Zhi Li:
>> On Tue, Jan 27, 2015 at 7:51 PM, Mike Turquette <mturquette@linaro.org> wrote:
>>> Quoting Marek Vasut (2015-01-21 15:39:01)
>>>> On Wednesday, January 21, 2015 at 05:16:03 PM, Zhi Li wrote:
>>>>> On Sun, Dec 28, 2014 at 4:26 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>>>>>> According to i.MX23 and i.MX28 reference manual the fractional
>>>>>> clock control registers must be addressed by byte instructions.
>>>>> I don't think mx23 and mx28 have such limitation. I will double check
>>>>> with IC team about this.
>>>>> RTL is generated from a xml file. All registers implement is unified.
>>>>> I don't think only clock control register have such limitation and
>>>>> other registers not.
>>>> Hi,
>>>>
>>>> Section 10.8.24 in the MX28 datasheet (Fractional Clock Control Register 0)
>>>> states otherwise, but maybe the documentation is simply not matching the
>>>> silicon.
>>>>
>>>> Here's a quote:
>>>> "
>>>> This register controls the 9-phase fractional clock dividers. The fractional
>>>> clock frequencies are a product of the values in these registers. NOTE: This
>>>> register can only be addressed by byte instructions. Addressing word or half-
>>>> word are not allowed.
>>>> "
>>>>
>>>> I also recall seeing weird behavior when these registers were accessed by word
>>>> access in U-Boot, so I believe the datasheet is correct.
>>> Hi Frank,
>>>
>>> Are you satisfied with this patch?
>> I asked IC designer about this.
>> They will check RTL code.
>> I will check their status again.
>> Our released BSP code used 32bit WORD access.
>
> i want to point out that the 32bit WORD is divided in 4 parts (IO0FRAC,
> IO1FRAC, EMIFRAC, CPUFRAC). Yes, it's true that BSP code access the
> register as 32bit, but it's never modify the complete 32bit at once just
> only 1 part (8bit) at a time.
>
> So here is my theory about Fractional Clock Control Register:
>
> Reading as 32bit WORD => safe
> Modify only 1 part (8bit) of the 32bit WORD => safe
> Modify more than 1 part of the 32bit WORD => unsafe !!!

Yes, it is align with what I get from IC designer.

best regards
Frank Li

>
> Best regards
> Stefan
>
>>
>> best regards
>> Frank Li
>>> Regards,
>>> Mike
>>>
>>>> Best regards,
>>>> Marek Vasut
>
>
