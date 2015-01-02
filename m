Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbbABJ2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:28:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60277 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbABJ2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:28:18 -0500
Message-ID: <54A664AB.1060100@gmail.com>
Date: Fri, 02 Jan 2015 18:28:11 +0900
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>, Daniel Drake <drake@endlessm.com>,
        Jon Loeliger <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>	<1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>	<54A19C17.1020909@ti.com> <CA+Ln22G3kVA_-tsjAxbe2rqSHeLtdU2X_EhNL0uW3cUCgaWLgg@mail.gmail.com> <54A2BBDC.1020900@ti.com> <54A66143.2080506@gmail.com>
In-Reply-To: <54A66143.2080506@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.01.2015 18:13, Tomasz Figa wrote:
> On 30.12.2014 23:51, Nishanth Menon wrote:
>>>> Looks like the following also need addressing:
>>>> data->save is called twice (once more after l2cof_init)
>>>> l2c310_init_fns also needs l2c310_configure
>>>> will be nice to use l2x0_data only after we kmemdup data in __l2c_init
>>>
>>> I'll check this.
>> Thanks.
>>
>
> Apparently the second save in __l2c_init() is not needed and it should
> have been removed. However it might be a good idea to actually do second
> save in l2c_enable() after l2c_configure() so that the values actually
> permitted by hardware and/or secure firmware are stored.
>
> l2c310_init_fns needs to be updated indeed.

Hmm, apparently current patch already adds this (and I missed it reading 
it at first), so I'm not sure what's your concern about it.

Best regards,
Tomasz
