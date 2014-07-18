Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbaGRAgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:36:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53051 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaGRAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:36:43 -0400
Message-ID: <53C86C10.2000608@gmail.com>
Date: Fri, 18 Jul 2014 08:36:32 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>,
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
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <53C7A819.40403@metafoo.de> <6485666.LVFO2YCEQx@wuerfel> <53C8114D.30601@nod.at>
In-Reply-To: <53C8114D.30601@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/18/2014 02:09 AM, Richard Weinberger wrote:
> Am 17.07.2014 12:48, schrieb Arnd Bergmann:
>> AFAICT, NO_IOMEM only has a real purpose on UML these days. Could we take
>> a shortcut here and make COMPILE_TEST depend on !UML? Getting random stuff
>> to build on UML seems pointless to me and we special-case it in a number of
>> places already.
> 
> If UML is the only arch without io memory the dependency on !UML seems
> reasonable to me. :-)
> 

For me, if only uml left, I suggest to implement dummy functions within
uml instead of let CONFIG_UML appear in generic include directory. And
then remove all HAS_IOMEM and NO_IOMEM from kernel.

If score sticks to NO_IOMEM, and can not remove score from kernel only
because of this reason. I also suggest implement dummy functions within
score itself.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
