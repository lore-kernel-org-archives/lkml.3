Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaHUHKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:10:54 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:40695 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaHUHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <53F5878D.3030700@samsung.com>
References: <2048653519.580921408598869113.JavaMail.weblogic@epmlwas01c>
	<53F5878D.3030700@samsung.com>
Date: Thu, 21 Aug 2014 09:10:50 +0200
X-Google-Sender-Auth: BiRDEZELqVfQ0o1z_7mEbtNlqQM
Message-ID: <CAMuHMdVK67_d8OqSH10urTYi7EG=VaZnH9EZBiNDVACZkBRENw@mail.gmail.com>
Subject: Re: [PATCH 2/2] extcon: sm5502: EXTCON_SM5502 should depend on I2C
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 7:45 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 08/21/2014 02:27 PM, MyungJoo Ham wrote:
>>> Thanks for your report. I already sent a patch[1] to fix this build break
>>> and I'll send pull request to includec this patch in 3.17-rc2.
>>>
>>> [1] https://lkml.org/lkml/2014/8/13/761
>>>
>>> Best Regards,
>>> Chanwoo Choi
>>
>> I do not object to this patch or your patch[1].
>>
>> However, wouldn't it be better to add depends on I2C at REGMAP_I2C?
>> When you use REGMAP_I2C, you assume that I2C is already there, don't you?

REGMAP_I2C is meant to be "select"ed by its users. So these users
should depend on I2C, as "select" does not check dependencies.

> The previous REGMAP_I2C has not the dependency on I2C.
> So, Greert posted following patch[1] to fix it.
> [1] https://lkml.org/lkml/2014/8/17/27
>
> Also, if I2C is 'm' (module) and some driver has not dependency on I2C,
> build break happen.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
