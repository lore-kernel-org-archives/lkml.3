Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3C0R6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:58:40 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34500 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3C0R6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WRJhr1+OS5Be2Vz6J=Rgk3UQAzwjY3FuNSjvMbeR3uUg@mail.gmail.com>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
	<CAD=FV=WRJhr1+OS5Be2Vz6J=Rgk3UQAzwjY3FuNSjvMbeR3uUg@mail.gmail.com>
Date: Wed, 27 Mar 2013 10:58:37 -0700
X-Google-Sender-Auth: 6n8IxMKNeuUNnaKn9qqRNHZMW6A
Message-ID: <CANEJEGtyAbiW4C3NT0AyOzvs3prj_ZxjDFOP6VdyHZs_cSPOhw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Grant Grundler <grundler@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 8:07 AM, Doug Anderson <dianders@chromium.org> wrote:
> Grant,
>
> Thanks for posting!  See below...

thanks for reviewing/feedback! :)

> On Tue, Mar 26, 2013 at 3:50 PM, Grant Grundler <grundler@chromium.org> wrote:
>> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
>> But when debugging a related issue (http://crbug.com/221828) I found
>> the code unreadable.  This rewrite simplifies the computation and
>> explains each step.
>
> The fact that you mention a bug here is confusing.  I think this patch
> has nothing to do with fixing that bug and is just a readability
> patch.  Is that correct?

Correct.  "related" implies "not the same". But you are right - the
reference is causing confusion.

I will move the reference to the bug out of the commit log to below
the '---' area of the patch.

>  Please add to the description if so and
> maybe remove unrelated comment about the bug.

Thanks! Will do and repost later today.

...
>> +                       /* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
>> +                        * Look for dwc_mobile_storage_db.pdf from Synopsys.
>> +                        * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
>
> You are quoting exynos5250 docs here.  This driver is used for more
> than just exynos and so this could be confusing to users on other
> platforms.

I'm quoting Synopsys docs - that's the origin of this HW's ip.
You and I looked at exynos5250 docs originally and they say exactly
the same thing. But the section numbers are different.

>
>>                          */
>> -                       div += 1;
>> -
>> -               div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
>> +                       div /= 2;
>
> It does look like you're re-implementing DIV_ROUND_UP.

Yes, it does look like that but by breaking it out into simple steps
AND explaining why we do each step, the code becomes maintainable by
normal developers. The comments are key to *quickly* understanding the
code in this case.

> Maybe replace your "if" test and division with just a DIV_ROUND_UP?

No. I'd rather just drop the patch. This code can and should be stupid
simple. DIV_ROUND_UP just makes it harder to understand and impossible
to document as clearly.

cheers,
grant
