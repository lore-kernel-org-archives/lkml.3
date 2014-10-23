Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaJWBNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:13:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25987 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaJWBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:13:13 -0400
X-AuditID: cbfee68e-f79b46d000002b74-13-5448562715f6
Message-id: <54485626.1050409@samsung.com>
Date: Thu, 23 Oct 2014 10:13:10 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Alim Akhtar <alim.akhtar@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
 <CAGOxZ507j5QjnT_hW2y0KPZsw6WDJWRPLdesTBm4+C8D2EznWw@mail.gmail.com>
 <CAD=FV=X+q2ymbB0EZkjj_tip9_PLdFV+Tfee+MkeUDSfD3E-ig@mail.gmail.com>
 <CAGOxZ51x8cd9XmNg49aaUdZQkw-hhEA-mC=34ZSjLf0XF8Zbvw@mail.gmail.com>
 <54448023.1050008@samsung.com>
 <CAD=FV=UhdHHYqaF=Nprr2Lz2b4w7guuBquBdBrB82BmYhGC0=Q@mail.gmail.com>
In-reply-to: <CAD=FV=UhdHHYqaF=Nprr2Lz2b4w7guuBquBdBrB82BmYhGC0=Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkWFc9zCPEYP9jYYuV7/8yWiz7/53J
	YumtaosH87axWUy4vJ3R4uyyg2wWR38XWFzeNYfN4sj/fkaLJ2dmMlp8uH+R2eL42nAHHo/Z
	DRdZPP4+v87isXPWXXaPO9f2sHnceLWQyePvrP0sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJXxqTmtYIF8RfvqtAbGlxJdjJwcEgImEnfnbGWBsMUkLtxbz9bFyMUhJLCUUaJz4iUmmKJj
	Nz4xg9hCAosYJY6croAoes0ocWj3fbAiXgEtiQ0HLwBN4uBgEVCV+PA4HiTMJqAjsf3bcbAS
	UYEwiUNt86DKBSV+TL4HtlhEQFPiWcNLZpCZzAIvmSWe7PoIlhAWcJfYevc4I8TiRmaJ60dM
	QGxOgWCJe4+nsIPYzALqEpPmLWKGsOUlNq95CzZIQqCVQ+Lj659gCRYBAYlvkw+BHSchICux
	6QAzxGOSEgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsY
	gdF7+t+zvh2MNw9YH2IU4GBU4uF1YHMPEWJNLCuuzD3EaAp0xURmKdHkfGCKyCuJNzQ2M7Iw
	NTE1NjK3NFMS502Q+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGwcfO821Etnzzrrt14
	pLzLcsK5C4XMZwouq+hxODJs7HSvVJtRvsxhnccLlYoD1+2a312eqX0+akXczEOhcRec+52e
	L7HNXLw9eEvoxaXSzPOEOHIC0w5Uh3HpvLPxyrp+R+yX1M2/GbxLefn5n+zN6Wrvl8qd27P+
	kkfpyp/Xp8WmrQ1WKVRiKc5INNRiLipOBABHN6cL2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAV31MI8Qg8NvuCxWvv/LaLHs/3cm
	i6W3qi0ezNvGZjHh8nZGi7PLDrJZHP1dYHF51xw2iyP/+xktnpyZyWjx4f5FZovja8MdeDxm
	N1xk8fj7/DqLx85Zd9k97lzbw+Zx49VCJo+/s/azePRtWcXo8XmTXABHVAOjTUZqYkpqkUJq
	XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QsUoKZYk5pUChgMTiYiV9
	O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjE/NaQUL5CvaV6c1ML6U6GLk5JAQMJE4duMTM4Qt
	JnHh3no2EFtIYBGjxJHTFV2MXED2a0aJQ7vvM4EkeAW0JDYcvMDSxcjBwSKgKvHhcTxImE1A
	R2L7t+NgJaICYRKH2uZBlQtK/Jh8jwXEFhHQlHjW8JIZZCazwEtmiSe7PoIlhAXcJbbePc4I
	sbiRWeL6ERMQm1MgWOLe4ynsIDazgLrEpHmLmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7F
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwankntYFzZYHGIUYCDUYmH14HNPUSINbGsuDL3
	EKMEB7OSCG+ttUeIEG9KYmVValF+fFFpTmrxIUZTYAhMZJYSTc4Hpq28knhDYxMzI0sjc0ML
	I2NzJXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2MMeUnGx1mm8msPl5dHXp3bdOLsyfTt25P
	Wv5z0+bX2UZWLBs+Xingj+J3frvEbY/pVQvN9uIX94NEHnzNavjUIyMmoCf/UOXMt9bwuB/e
	/ZZ6kvlOXTH9Rur1kaummPtNE2pMPaavu+bg8R0XeyMc9z0rXfle6X58qf/afdsk6z/+C3gx
	XV9CiaU4I9FQi7moOBEAtAbTwSMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear, Doug.

On 10/23/2014 01:36 AM, Doug Anderson wrote:
> Hi,
> 
> On Sun, Oct 19, 2014 at 8:23 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi.
>>
>> On 10/17/2014 09:44 PM, Alim Akhtar wrote:
>>> Hi Doug,
>>>
>>> On Thu, Oct 16, 2014 at 9:40 PM, Doug Anderson <dianders@chromium.org> wrote:
>>>> Alim,
>>>>
>>>> On Thu, Oct 16, 2014 at 5:57 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>>>>> Hi Doug,
>>>>>
>>>>> On Tue, Oct 14, 2014 at 10:03 PM, Doug Anderson <dianders@chromium.org> wrote:
>>>>>> The dw_mmc driver had a bunch of code that ran whenever a card was
>>>>>> ejected and inserted.  However, this code was old and crufty and
>>>>>> should be removed.  Some evidence that it's really not needed:
>>>>>>
>>>>>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>>>>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>>>>>    doesn't run any of the crufty old code but yet still works.
>>>>>>
>>>>>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>>>>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>>>>>    castrated the old code a little bit already and nobody noticed.
>>>>>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>>>>>    means that on the first card removal none of the crufty code ran.
>>>>>>
>>>>> Yes, right most of these codes are _almost_ never call. But I see
>>>>> dw_mci_reset() being called on card removal (after first
>>>>> insert/removal).
>>>>
>>>> Right.  The old crufty code was called on the 2nd removal, not the
>>>> 1st.  That meant that the two were accidentally different.  My point
>>>> was that if the old code was really required that someone would have
>>>> noticed crashes on the 1st removal after each boot.  Since nobody is
>>>> reporting crashes with that then it means it can't be too terrible.
>>>>
>>>> One thing to note: I remember in the last Chromebook project you were
>>>> trying to track down crashes associated with constant eject / insert
>>>> of SD Cards.  I wonder if my patch will fix these crashes?
>>>>
>>> Ah, yes, reproducing that and checking with this patch will be really
>>> interesting.
>>>
>>>>
>>>>> I tested this on exynos5800 and this looks working fine. We need to
>>>>> test once cross suspend/resume as well.
>>>>
>>>> Good idea.  Can you test that?  I know that there's been lots of flux
>>>> with suspend/resume on exynos and I'm not sure I have all the latest
>>>> patches, but I'll search for them if you are unable to test easily.
>>>>
>>> Sure, I will do that..but probably sometime next week, as I will out
>>> of office for few days.
>>>>
>>>>> And as Jaehoon pointed out,probably lets look in TRM if there are some
>>>>> recommended  steps for cd-detect.
>>>>> Otherwise this looks good to me.
>>>>
>>>> If you see some other requirement than the one I addressed in my email
>>>> to Jaehoon, please let me know.
>>
>> I know there is no other requirement for detecting card.
>> So this patch can be applied after testing the above case(suspend/resume).
> 
> I put a kernel based upon 3.17 on an exynos5250-snow (specifically
> git://git.collabora.co.uk/git/user/javier/linux.git branch
> max77802-op-modes-v3, git hash 98cf5a0).  Snow uses the builtin card
> detect on dw_mmc.  Resume wasn't terribly reliable to start with even
> without my patch (it often woke up right after suspend), but it worked
> well enough for testing.  I tested the following scenarios:
> 
> 1. Leave card in and mounted.  Suspend/resume.  Card is still usable
> after resume
> 
> 2. Suspend and insert card.  Resume.  Card is detected upon resume.
> 
> 3. Suspend and remove card.  Resume.  Card is removed upon resume.
> 
> How does that sound?

I think these test cases are enough, and if it's working fine, sounds good.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

> 
> -Doug
> 

