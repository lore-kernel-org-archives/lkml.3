Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab3JKP5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:57:01 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64322 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab3JKP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131011154352.GO29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
	<5256AA7F.8030005@ti.com>
	<20131010160018.GA29913@atomide.com>
	<CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com>
	<20131010162015.GC29913@atomide.com>
	<CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com>
	<5257BD3E.5000707@ti.com>
	<CACRpkdYJNaiAAHhYatd6g5_wVt0QEUxOvsk6nQn9o=_i5zfWrA@mail.gmail.com>
	<20131011154352.GO29913@atomide.com>
Date: Fri, 11 Oct 2013 17:56:58 +0200
Message-ID: <CACRpkdZhbadd5d4P+2B0_DktqK4CHzZPVJC8kPHZYUnp8TaxsA@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 5:43 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Linus Walleij <linus.walleij@linaro.org> [131011 03:40]:
>> On Fri, Oct 11, 2013 at 10:56 AM, Roger Quadros <rogerq@ti.com> wrote:
>>
>> > The register handling is fine. But how do we deal with resource handling?
>> > e.g. the block that has the deep-core registers might need to be clocked or powered
>> > before the registers can be accessed.
>>
>> Yeah I saw this in the code there.
>>
>> In this case it seems syscon-type regmap access can be used to
>> read/write the registers, so maybe the pin controller also need to
>>  get a handle on some clock etc?
>
> Uhh, let's not go there.. The resource availability needs to be
> handled transparently in regmap code and the reg provider hardware
> module driver using runtime PM.

OK we can surely discuss this with broonie, it makes sense to
have regmap be able to do its deed transparently.

Yours,
Linus Walleij
