Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbaGRKvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:51:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65277 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761164AbaGRKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:51:17 -0400
Message-ID: <53C8FC1E.9090003@nod.at>
Date: Fri, 18 Jul 2014 12:51:10 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Guenter Roeck <linux@roeck-us.net>,
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
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <53C7A819.40403@metafoo.de> <6485666.LVFO2YCEQx@wuerfel> <53C8114D.30601@nod.at> <53C86C10.2000608@gmail.com> <53C8CE59.3060103@nod.at> <53C8FA78.1020501@gmail.com>
In-Reply-To: <53C8FA78.1020501@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.07.2014 12:44, schrieb Chen Gang:
> On 07/18/2014 03:35 PM, Richard Weinberger wrote:
>> Am 18.07.2014 02:36, schrieb Chen Gang:
>>>
>>> On 07/18/2014 02:09 AM, Richard Weinberger wrote:
>>>> Am 17.07.2014 12:48, schrieb Arnd Bergmann:
>>>>> AFAICT, NO_IOMEM only has a real purpose on UML these days. Could we take
>>>>> a shortcut here and make COMPILE_TEST depend on !UML? Getting random stuff
>>>>> to build on UML seems pointless to me and we special-case it in a number of
>>>>> places already.
>>>>
>>>> If UML is the only arch without io memory the dependency on !UML seems
>>>> reasonable to me. :-)
>>>>
>>>
>>> For me, if only uml left, I suggest to implement dummy functions within
>>> uml instead of let CONFIG_UML appear in generic include directory. And
>>> then remove all HAS_IOMEM and NO_IOMEM from kernel.
>>
>> Erm, this is something completely different.
>> I thought we're focusing on COMPILE_TEST?
>>
> 
> COMPILE_TEST is none-architecture specific, but UML is. So in generic
> include folder, if we're focusing on choosing whether COMPILE_TEST or
> UML, for me, I will choose COMPILE_TEST.
> 
> If we're not only focusing on COMPILE_TEST, for me, if something only
> depend on one architecture, I'd like to put them under "arch/*/" folder.
> 
> Especially, after that, we can remove all HAS_IOMEM and NO_IOMEM, nobody
> has to think of them again. :-)

And then we end up with a solution that on UML a lot of completely useless
drivers are build which fail in various interesting manners because you'll
add stubs for all kinds of io memory related functions to arch/um/?
We had this kind of discussion already. You'll need more than ioremap...

I like Arnd's idea *much* more to make COMPILE_TEST depend on !UML.

Thanks,
//richard
