Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaJTDXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:23:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13530 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJTDXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:23:18 -0400
X-AuditID: cbfee691-f79b86d000004a5a-98-544480239a26
Message-id: <54448023.1050008@samsung.com>
Date: Mon, 20 Oct 2014 12:23:15 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>, Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
 <CAGOxZ507j5QjnT_hW2y0KPZsw6WDJWRPLdesTBm4+C8D2EznWw@mail.gmail.com>
 <CAD=FV=X+q2ymbB0EZkjj_tip9_PLdFV+Tfee+MkeUDSfD3E-ig@mail.gmail.com>
 <CAGOxZ51x8cd9XmNg49aaUdZQkw-hhEA-mC=34ZSjLf0XF8Zbvw@mail.gmail.com>
In-reply-to: <CAGOxZ51x8cd9XmNg49aaUdZQkw-hhEA-mC=34ZSjLf0XF8Zbvw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkQFe5wSXEYFavhcXK938ZLZb9/85k
	sfRWtcWDedvYLCZc3s5ocXbZQTaLy7vmsFkc+d/PaPHkzExGiw/3LzJbHF8b7sDtMbvhIovH
	zll32T3uXNvD5nHj1UImj7+z9rN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV0bfgkusBZMl
	Ko6+2sLSwPhdqIuRk0NCwETi8q0FrBC2mMSFe+vZuhi5OIQEljJKtP5qZOpi5AAr2vuqACI+
	nVFiXvMrNpAGIYHXjBJXlweA2LwCWhLP22ezgNgsAqoSD04uBbPZBHQktn87zgRiiwqESRxq
	m8cEUS8o8WPyPbAaEQE/ictLboMtZhZoY5bY+PUk2AJhAXeJrXePM0Jsnskk0br5P1gHp0Cw
	xInJF8FsZgF1iUnzFjFD2PISm9e8ZQZpkBD4yS4xseMdG8RJAhLfJh9igXhHVmLTAWaIlyUl
	Dq64wTKBUWwWkqNmIRk7C8nYBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECI/b0v2cT
	dzDeP2B9iFGAg1GJh3eHmUuIEGtiWXFl7iFGU6ArJjJLiSbnA9NCXkm8obGZkYWpiamxkbml
	mZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIL//26pWeestW7vkt9FHUdM80O9
	F5aJu6zsccre9fGBlN0inr9pvpncXodvvL3ecK9Bxl08j/m7gJVj4V+fU8ZtCblCZ8MkWWKn
	MTjdumEa6qtfXrKp+UnAoqcTHYKDX3qva2Y88bvGRXmi66r6Zau+aZiatiT+Co86fjE9+Exs
	5KdZf2oOKrEUZyQaajEXFScCAIngJynTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoK5yg0uIwdEr+hYr3/9ltFj2/zuT
	xdJb1RYP5m1js5hweTujxdllB9ksLu+aw2Zx5H8/o8WTMzMZLT7cv8hscXxtuAO3x+yGiywe
	O2fdZfe4c20Pm8eNVwuZPP7O2s/i0bdlFaPH501yAexRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJaxgz+hZcYi2YLFFx9NUWlgbG70JdjBwcEgImEntfFXQxcgKZYhIX7q1n
	62Lk4hASmM4oMa/5FRtIQkjgNaPE1eUBIDavgJbE8/bZLCA2i4CqxIOTS8FsNgEdie3fjjOB
	2KICYRKH2uYxQdQLSvyYfA+sRkTAT+LykttgC5gF2pglNn49CbZAWMBdYuvd44wQm2cySbRu
	/g/WwSkQLHFi8kUwm1lAXWLSvEXMELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQITgfPpHcwrmqwOMQowMGoxMO7w8wlRIg1say4MvcQowQHs5II
	778MoBBvSmJlVWpRfnxRaU5q8SFGU2AYTGSWEk3OB6aqvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt
	1oFCAumJJanZqakFqUUwfUwcnFINjFP0Xv80Zslde5gt49p3i66faTeWnO/bH/9BPFqCIZmh
	TVrKRGQv95qLxeVPj136dUDm2pn9J9LSg2XWpkfK58o3b9/8nUtH9LabiXWa/wMlqwVZ8j8u
	mq4zbkn+9q3+Su3Zy7c+yPHcnqWsoR9amGA4J3ZDk8zDLKYW77jjMStzczhFlbO7lFiKMxIN
	tZiLihMBirDIzx0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 10/17/2014 09:44 PM, Alim Akhtar wrote:
> Hi Doug,
> 
> On Thu, Oct 16, 2014 at 9:40 PM, Doug Anderson <dianders@chromium.org> wrote:
>> Alim,
>>
>> On Thu, Oct 16, 2014 at 5:57 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>>> Hi Doug,
>>>
>>> On Tue, Oct 14, 2014 at 10:03 PM, Doug Anderson <dianders@chromium.org> wrote:
>>>> The dw_mmc driver had a bunch of code that ran whenever a card was
>>>> ejected and inserted.  However, this code was old and crufty and
>>>> should be removed.  Some evidence that it's really not needed:
>>>>
>>>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>>>    doesn't run any of the crufty old code but yet still works.
>>>>
>>>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>>>    castrated the old code a little bit already and nobody noticed.
>>>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>>>    means that on the first card removal none of the crufty code ran.
>>>>
>>> Yes, right most of these codes are _almost_ never call. But I see
>>> dw_mci_reset() being called on card removal (after first
>>> insert/removal).
>>
>> Right.  The old crufty code was called on the 2nd removal, not the
>> 1st.  That meant that the two were accidentally different.  My point
>> was that if the old code was really required that someone would have
>> noticed crashes on the 1st removal after each boot.  Since nobody is
>> reporting crashes with that then it means it can't be too terrible.
>>
>> One thing to note: I remember in the last Chromebook project you were
>> trying to track down crashes associated with constant eject / insert
>> of SD Cards.  I wonder if my patch will fix these crashes?
>>
> Ah, yes, reproducing that and checking with this patch will be really
> interesting.
> 
>>
>>> I tested this on exynos5800 and this looks working fine. We need to
>>> test once cross suspend/resume as well.
>>
>> Good idea.  Can you test that?  I know that there's been lots of flux
>> with suspend/resume on exynos and I'm not sure I have all the latest
>> patches, but I'll search for them if you are unable to test easily.
>>
> Sure, I will do that..but probably sometime next week, as I will out
> of office for few days.
>>
>>> And as Jaehoon pointed out,probably lets look in TRM if there are some
>>> recommended  steps for cd-detect.
>>> Otherwise this looks good to me.
>>
>> If you see some other requirement than the one I addressed in my email
>> to Jaehoon, please let me know.

I know there is no other requirement for detecting card. 
So this patch can be applied after testing the above case(suspend/resume).

Best Regards,
Jaehoon Chung

>>
> Well, as most of the current CD detect code are dead code, so lets see
> more test results, specially across a suspend/resume and warm reboot
> test and take this forward.
>>
>> -Doug
> 
> 
> 

