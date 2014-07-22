Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaGVL3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:29:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35821 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaGVL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:29:47 -0400
Message-ID: <53CE4B1F.9080701@gmail.com>
Date: Tue, 22 Jul 2014 19:29:35 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lennox Wu <lennox.wu@gmail.com>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tom Gundersen <teg@jklm.no>, Thierry Reding <thierry.reding@gmail.com>,
        Marek Vasut <marex@denx.de>, Liqin Chen <liqin.linux@gmail.com>,
        msalter@redhat.com, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        jic23@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        cmetcalf@tilera.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <53CB801D.1030603@gmail.com> <53CB8FC4.4050009@gmail.com> <179292068.QXZf3Zcqzf@wuerfel>
In-Reply-To: <179292068.QXZf3Zcqzf@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/22/2014 06:32 PM, Arnd Bergmann wrote:
> On Sunday 20 July 2014 17:45:40 Chen Gang wrote:
>>>
>>> Next, I shall:
>>>
>>>  - Remove HAS_IOMEM and NO_IOMEM from kernel, firstly.
>>>
>>>  - Try to make dummy IOMEM functions for score architecture.
>>>
>>>  - Continue discussing with UML for it.
>>>
>>  
>> Oh, sorry, I forgot, after remove IOMEM from kernel, also s390 and tile
>> need implement dummy IOMEM if !PCI.
>>
>> If possible, I shall try to implement the dummy IOMEM in 'asm-generic',
>> and let uml, score, s390 and tile use them when they need.
> 
> Sorry for going round in circles, but looking back at the original patches,
> adding the extra 'depends on HAS_IOMEM' does seem much better than the
> other suggestions that came afterwards.
> 
> In particular, removing HAS_IOMEM and NO_IOMEM sounds like an awful idea
> to me. I'd rather add a HAS_IOPORT in addition to also catch architectures
> that have no support for PC-style PIO.
> 

Welcome any other members (especially driver members) ideas and
suggestions -- driver members and architecture members have different
tastes and different roles.

For me, if no additional reply, I prefer to keep current status, and
still add 'depends on HAS_IOMEM' for each driver which need it, but I am
not sure whether driver members can bear it.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
