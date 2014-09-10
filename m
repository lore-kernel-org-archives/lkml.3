Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaIJVhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:37:17 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56802 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaIJVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140910134411.8128acce79f2423d4448e8f4@linux-foundation.org>
References: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
	<1410311886-4579-2-git-send-email-zyw@rock-chips.com>
	<20140910134411.8128acce79f2423d4448e8f4@linux-foundation.org>
Date: Wed, 10 Sep 2014 14:37:13 -0700
X-Google-Sender-Auth: SvJFfGX5JiMjLIfO0CRe_qWseIY
Message-ID: <CAD=FV=V4-dHpKwRqewCr7ujDdRYiMiUcRuJAS7C602EyCMnPFQ@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] RTC: RK808: add RTC driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Wed, Sep 10, 2014 at 1:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 10 Sep 2014 09:18:04 +0800 Chris Zhong <zyw@rock-chips.com> wrote:
>
>> Adding RTC driver for supporting RTC device present inside RK808 PMIC.
>>
>> ...
>>
>> +     ret = rtc_valid_tm(&tm);
>> +     if (ret) {
>> +             dev_warn(&pdev->dev, "invalid date/time and init time\n");
>> +             rk808_rtc_set_time(&pdev->dev, &tm_def);
>> +     }
>
> This is somewhat unusual.  Most drivers will emit a warning and give up
> when they find the time is wrong.  Why is this driver different and is
> this desirable behaviour?

When you say "give up", what does that mean?  I assume the driver
should keep initting, right?  Then the user can go in and set a time
later...


I did test things with just removing this chunk of code.  You get some
yells at bootup if you put a bogus time in there:

[    2.987590] rk808-rtc rk808-rtc: invalid date/time and init time
[    3.013148] rk808-rtc rk808-rtc: rtc core: registered rk808-rtc as rtc0
[    4.586115] rk808-rtc rk808-rtc: hctosys: invalid date/time

...but if you later set a valid time then everything is fine.  That
seems reasonable behavior to me, so I guess we could just remove this
whole chunk?  It appears that after a normal bootup the date/time is
something valid.


-Doug
