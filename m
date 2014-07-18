Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbaGRA1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:27:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59372 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGRA1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:27:30 -0400
Message-ID: <53C869D3.6030908@gmail.com>
Date: Fri, 18 Jul 2014 08:26:59 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@tilera.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
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
References: <201407130545.23004.marex@denx.de> <53C7B365.4080000@gmail.com> <53C834EA.5030605@tilera.com> <5190668.jExaFa8pKn@wuerfel>
In-Reply-To: <5190668.jExaFa8pKn@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 05:05 AM, Arnd Bergmann wrote:
> On Thursday 17 July 2014 16:41:14 Chris Metcalf wrote:
>> On 7/17/2014 7:28 AM, Chen Gang wrote:
>>> On 07/17/2014 06:48 PM, Arnd Bergmann wrote:
>>>> AFAICT, NO_IOMEM only has a real purpose on UML these days. Could we take
>>>> a shortcut here and make COMPILE_TEST depend on !UML? Getting random stuff
>>>> to build on UML seems pointless to me and we special-case it in a number of
>>>> places already.
>>>>
>>> According to current source code, tile still has chance to choose
>>> NO_IOMEM, for me, welcome the tile's maintainer's ideas or suggestions.
>>
>> I'm not really sure.  It's true that on tile, if you don't enable PCI
>> support there's no other I/O memory (or I/O port) space you can use.
>> We pretty much always enable PCI support in our kernel, though.  I'm
>> kind of surprised that other architectures don't also have the model
>> that IOMEM requires PCI, but perhaps most architectures just don't
>> encode that in the Kconfig file?
> 
> Only s390 as far as I know. Most architectures have integrated
> peripherals that use MMIO without PCI.
> 
>> My observation is just that if I remove the "NO_IOMEM if !PCI" from
>> arch/tile/Kconfig, my build fails with ioremap() undefined.  No doubt I
>> could work around that, but my assumption was that NO_IOMEM was exactly the
>> right thing to express the fact that without PCI there is no I/O memory 
> 
> Your assumption is correct.
> 
> For tile by itself it would certainly be best to leave this
> dependency, it makes no sense to enable IOMEM without PCI.
> 
> That doesn't solve the problem of COMPILE_TEST enabling drivers
> that require IOMEM though. An easy hack for that would be to
> make COMPILE_TEST depend on HAS_IOMEM, but it gets into hacky territory
> there, and it's not clear if this is any better than the original patch
> to provide fallbacks for ioremap and friends. Definitely simpler
> though.
> 

OK, thank all of you, tile just likes most of architectures to support
IOMEM, and at present, we can focus score and uml only.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
