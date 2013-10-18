Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3JRHlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:41:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47039 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3JRHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:41:23 -0400
Message-ID: <5260E606.2030903@ti.com>
Date: Fri, 18 Oct 2013 13:10:54 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Co?= =?ISO-8859-1?Q?usson?= 
	<bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
References: <20131003054221.8941.87801.stgit@localhost> <5256AA7F.8030005@ti.com> <20131010160018.GA29913@atomide.com> <CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com> <20131010162015.GC29913@atomide.com> <CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com> <5257BD3E.5000707@ti.com> <CACRpkdYJNaiAAHhYatd6g5_wVt0QEUxOvsk6nQn9o=_i5zfWrA@mail.gmail.com> <20131011154352.GO29913@atomide.com> <CACRpkdZhbadd5d4P+2B0_DktqK4CHzZPVJC8kPHZYUnp8TaxsA@mail.gmail.com> <20131011160146.GR29913@atomide.com>
In-Reply-To: <20131011160146.GR29913@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 October 2013 09:31 PM, Tony Lindgren wrote:
> * Linus Walleij <linus.walleij@linaro.org> [131011 09:05]:
>> On Fri, Oct 11, 2013 at 5:43 PM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Linus Walleij <linus.walleij@linaro.org> [131011 03:40]:
>>>> On Fri, Oct 11, 2013 at 10:56 AM, Roger Quadros <rogerq@ti.com> wrote:
>>>>
>>>>> The register handling is fine. But how do we deal with resource handling?
>>>>> e.g. the block that has the deep-core registers might need to be clocked or powered
>>>>> before the registers can be accessed.
>>>>
>>>> Yeah I saw this in the code there.
>>>>
>>>> In this case it seems syscon-type regmap access can be used to
>>>> read/write the registers, so maybe the pin controller also need to
>>>>   get a handle on some clock etc?
>>>
>>> Uhh, let's not go there.. The resource availability needs to be
>>> handled transparently in regmap code and the reg provider hardware
>>> module driver using runtime PM.
>>
>> OK we can surely discuss this with broonie, it makes sense to
>> have regmap be able to do its deed transparently.
>
> Yes I think so too. Sounds like we need callbacks for the runtime PM
> checks to the "register provider" driver. Hwo knows, maybe those
> features are there already :)
>

Hi Tony,

Any conclusion on using regmap for omap control module non-mux registers ?

Thanks and Regards,
Balaji T K
