Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaGQLrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:47:07 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48543 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaGQLrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:47:04 -0400
Message-ID: <53C7B7AF.3070103@gmail.com>
Date: Thu, 17 Jul 2014 19:46:55 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        jic23@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <53C7977B.9090903@gmail.com> <7018119.hVYUML2rzD@wuerfel>
In-Reply-To: <7018119.hVYUML2rzD@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2014 06:38 PM, Arnd Bergmann wrote:
> On Thursday 17 July 2014 17:29:31 Chen Gang wrote:
>>>
>>> COMPILE_TEST is a great tool in general, but it has its limits.
>>> In particular, the case for !CONFIG_IOMEM is completely obscure
>>> and we won't find any bugs by allowing more drivers to be built
>>> in those configurations, but attempting to do it would cause
>>> endless churn by changing each instance of 'depends on HAS_IOMEM'
>>> to 'depends on HAS_IOMEM || COMPILE_TEST'.
>>>
>>
>> Architecture members and driver members really have different tastes,
>> they are different roles. It really need additional discussion.
>>
>> For me, I only want to change devm_io*map*, not touch so much.
> 
> But what do you gain from that? All drivers that need these
> functions should already 'depends on HAS_IOMEM' and if they don't,
> we should fix /that/ instead. I don't see this dependency as any
> different from a lot of others (PCI, DMAENGINE, HAVE_CLK, ...)
> that we use to intentionally annotate drivers that need a particular
> feature to be present for compilation. Do you want to do the
> same hack to those?
> 
>> Welcome any other members' idea or suggestions.
> 
>>> Note that s390 no has gained support for IOMEM, tile has it most
>>> of the time (when PCI is enabled, so you get it in half the
>>> test builds already), score should set HAS_IOMEM and doesn't
>>> even have public compilers, and uml doesn't even compile in
>>> latest mainline. Nothing else ever sets NO_IOMEM.
>>>
>>

I guess, we are just discussing about them in another threads, so I skip
them. If it is still necessary to reply (e.g. I misunderstand), please
let me know, thanks.

>> In latest gcc and binutils, can compile score cross compiler
>> successfully for building kernel (but I am not quite sure whether the
>> compiling result are really OK, but I guess so).
> 
> Ok. Would you mind sending a patch that enables HAS_IOMEM on
> score?
>  

For me, welcome the score related maintainers' idea and suggestions.

>> And next (maybe after finish allmodconfig for microblaze), I shall try
>> to let uml pass allmodconfig for linux-next tree.
> 
> That is a fair goal, but it seems better to do that by ensuring
> we don't build any code that tries to call the MMIO functions
> rather than trying to make them build.
> 

When I am performing uml, I will try and also communicate with the
related maintainers for it (their suggestions and ideas are valuable).

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
