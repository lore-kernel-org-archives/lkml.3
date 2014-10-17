Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaJQMp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:45:27 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:47483 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaJQMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=X+q2ymbB0EZkjj_tip9_PLdFV+Tfee+MkeUDSfD3E-ig@mail.gmail.com>
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
 <CAGOxZ507j5QjnT_hW2y0KPZsw6WDJWRPLdesTBm4+C8D2EznWw@mail.gmail.com> <CAD=FV=X+q2ymbB0EZkjj_tip9_PLdFV+Tfee+MkeUDSfD3E-ig@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Fri, 17 Oct 2014 18:14:45 +0530
Message-ID: <CAGOxZ51x8cd9XmNg49aaUdZQkw-hhEA-mC=34ZSjLf0XF8Zbvw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Thu, Oct 16, 2014 at 9:40 PM, Doug Anderson <dianders@chromium.org> wrote:
> Alim,
>
> On Thu, Oct 16, 2014 at 5:57 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>> Hi Doug,
>>
>> On Tue, Oct 14, 2014 at 10:03 PM, Doug Anderson <dianders@chromium.org> wrote:
>>> The dw_mmc driver had a bunch of code that ran whenever a card was
>>> ejected and inserted.  However, this code was old and crufty and
>>> should be removed.  Some evidence that it's really not needed:
>>>
>>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>>    doesn't run any of the crufty old code but yet still works.
>>>
>>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>>    castrated the old code a little bit already and nobody noticed.
>>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>>    means that on the first card removal none of the crufty code ran.
>>>
>> Yes, right most of these codes are _almost_ never call. But I see
>> dw_mci_reset() being called on card removal (after first
>> insert/removal).
>
> Right.  The old crufty code was called on the 2nd removal, not the
> 1st.  That meant that the two were accidentally different.  My point
> was that if the old code was really required that someone would have
> noticed crashes on the 1st removal after each boot.  Since nobody is
> reporting crashes with that then it means it can't be too terrible.
>
> One thing to note: I remember in the last Chromebook project you were
> trying to track down crashes associated with constant eject / insert
> of SD Cards.  I wonder if my patch will fix these crashes?
>
Ah, yes, reproducing that and checking with this patch will be really
interesting.

>
>> I tested this on exynos5800 and this looks working fine. We need to
>> test once cross suspend/resume as well.
>
> Good idea.  Can you test that?  I know that there's been lots of flux
> with suspend/resume on exynos and I'm not sure I have all the latest
> patches, but I'll search for them if you are unable to test easily.
>
Sure, I will do that..but probably sometime next week, as I will out
of office for few days.
>
>> And as Jaehoon pointed out,probably lets look in TRM if there are some
>> recommended  steps for cd-detect.
>> Otherwise this looks good to me.
>
> If you see some other requirement than the one I addressed in my email
> to Jaehoon, please let me know.
>
Well, as most of the current CD detect code are dead code, so lets see
more test results, specially across a suspend/resume and warm reboot
test and take this forward.
>
> -Doug



-- 
Regards,
Alim
