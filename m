Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaGQLUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:20:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36748 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaGQLUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:20:21 -0400
Message-ID: <53C7B16B.7020000@gmail.com>
Date: Thu, 17 Jul 2014 19:20:11 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <20140717095657.GC17877@ulmo> <6350114.L77bTv76Ul@wuerfel> <20140717105549.GH17877@ulmo>
In-Reply-To: <20140717105549.GH17877@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2014 06:55 PM, Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 12:33:32PM +0200, Arnd Bergmann wrote:
>> On Thursday 17 July 2014 11:56:58 Thierry Reding wrote:
>>> On Thu, Jul 17, 2014 at 11:20:36AM +0200, Arnd Bergmann wrote:
>>> [...]
>>>>                       score should set HAS_IOMEM and doesn't
>>>> even have public compilers
>>>
>>> This begs an interesting question. Should it be made a requirement to
>>> have publicly available compilers for new architectures so that they can
>>> at least be compile-tested? Preferably this would of course be in source
>>> form so that there aren't any dependencies on the distribution.
>>
>> The question has come up a few times. I wouldn't mandate that the port
>> has an upstream gcc (you've got to start mainlining one of them first
>> after all), but having compilers available for download should probably be
>> required. It's hard to ask for a particular quality of that gcc port
>> though, or to expect it to stay available online.
>>
>> Where did you find the gcc port for score?
> 
> It's upstream, though marked obsolete and to be removed in the next
> release... =)
> 

For me, I get the latest gcc version and binutils source code, and fix 2
bugs (one for gas, which always generate core dump, the other for gcc
c-decl, fix it together with the other gcc members).

And I only finish compiling raw cross-compiler (--without-headers),
after make some patches, can let score pass allmodconfig.

At present, it seems the score cross-compiler still contents some issue
which I shall try to analyse (it is about link symbols), and maybe need
communicate with gcc/binutils members.


At present, the related score maintainers are still active in upstream
kernel, so we also need the related maintainers' ideas and suggestions.


Thanks
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
