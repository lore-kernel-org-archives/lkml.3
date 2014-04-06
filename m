Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaDFNXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:23:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35731 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaDFNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwNmN+M8ncSGjUwnfXs1p-e7pCy5Y-K7uX6JV5JyWYhEg@mail.gmail.com>
References: <20140318110947.GR25478@lee--X1>
	<1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
	<CAK9yfHwNmN+M8ncSGjUwnfXs1p-e7pCy5Y-K7uX6JV5JyWYhEg@mail.gmail.com>
Date: Sun, 6 Apr 2014 15:23:09 +0200
X-Google-Sender-Auth: oU-Vf2Lvp6Fe4m-tAGoqAIkAxuc
Message-ID: <CAMuHMdX2yCCSUn=t9BZ_+bHMcV11O35b2PDj1hS=NNHmiiG0eA@mail.gmail.com>
Subject: Re: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 9:27 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 18 March 2014 18:41, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
>> Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
>> for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
>> rtc-s5m driver does not support S2MPA01.
>>
>> This fixes following error:
>> drivers/mfd/sec-core.c:342:45: warning: 'regmap_rtc' may be used uninitialized in this function [-Wuninitialized]
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>
> From the point of suppressing this warning and considering how it is
> done for S2MPS11,
> Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

This is not just about suppressing a warning. The following may crash when
passed a random pointer:

sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc, regmap_rtc);

and if regmap_rtc happens to be NULL, devm_regmap_init_i2c() will
return -EINVAL.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
