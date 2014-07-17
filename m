Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaGQUlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:41:21 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55097 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaGQUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:41:19 -0400
X-CheckPoint: {53C834EA-8-2100090A-C0000000}
Message-ID: <53C834EA.5030605@tilera.com>
Date: Thu, 17 Jul 2014 16:41:14 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <dmitry.torokhov@gmail.com>, <linux-iio@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, <teg@jklm.no>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, <msalter@redhat.com>,
        <linux-pwm@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-watchdog@vger.kernel.org>, <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <knaack.h@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        <Mischa.Jonker@synopsys.com>, <jic23@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <53C7A819.40403@metafoo.de> <6485666.LVFO2YCEQx@wuerfel> <53C7B365.4080000@gmail.com>
In-Reply-To: <53C7B365.4080000@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/2014 7:28 AM, Chen Gang wrote:
> On 07/17/2014 06:48 PM, Arnd Bergmann wrote:
>> AFAICT, NO_IOMEM only has a real purpose on UML these days. Could we take
>> a shortcut here and make COMPILE_TEST depend on !UML? Getting random stuff
>> to build on UML seems pointless to me and we special-case it in a number of
>> places already.
>>
> According to current source code, tile still has chance to choose
> NO_IOMEM, for me, welcome the tile's maintainer's ideas or suggestions.

I'm not really sure.  It's true that on tile, if you don't enable PCI
support there's no other I/O memory (or I/O port) space you can use.
We pretty much always enable PCI support in our kernel, though.  I'm
kind of surprised that other architectures don't also have the model
that IOMEM requires PCI, but perhaps most architectures just don't
encode that in the Kconfig file?

My observation is just that if I remove the "NO_IOMEM if !PCI" from
arch/tile/Kconfig, my build fails with ioremap() undefined.  No doubt I
could work around that, but my assumption was that NO_IOMEM was exactly the
right thing to express the fact that without PCI there is no I/O memory :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

