Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaGPMoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:44:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19890 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaGPMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:44:30 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-05-53c673ab262f
Message-id: <53C67386.5070401@samsung.com>
Date: Wed, 16 Jul 2014 14:43:50 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 04/19] serial: samsung: Remove support for legacy clock code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
 <1405502840.4408.2.camel@x220>
In-reply-to: <1405502840.4408.2.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xy7qri48FG8z4K2Xxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFoltnmC1W7frD6MDt8fvX
	JEaPnbPusntsWtXJ5rF5Sb3HlRNNrB59W1Yxemy/No/ZY+P2J0wenzfJBXBGcdmkpOZklqUW
	6dslcGWsOHqbsWAKd8Xv9la2BsYFnF2MnBwSAiYSu9ums0LYYhIX7q1nA7GFBJYySlzfltzF
	yAVkf2aUmHBxHViCV0BL4t3qj8wgNouAqkRT4zawZjYBNYnPDY/AaviBatY0XWfpYuTgEBWI
	kHh8QQiiVVDix+R7LCC2iICyROvme+wg85kF/jFJNC3bDTZHWCBA4u2L2cwQi+cwSiyd+ZUd
	JMEpoC0x9d8FsAXMAuoSk+YtYoaw5SU2r3nLPIFRcBaSJbOQlM1CUraAkXkVo2hqaXJBcVJ6
	rpFecWJucWleul5yfu4mRkg0fd3BuPSY1SFGAQ5GJR5ehtlHg4VYE8uKK3MPMUpwMCuJ8Dr4
	HwsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNjl0Xpd4Vl+ouuZowEbxRXvrhOckKqwSpQvXrm+
	SUNkT/W7zoUWPV0btqlLVJ/OKjYM7Hx0tkLb76mDWdztK/s2rva+nxRxZaNC9/Od5RHeDxgc
	cncy/H9nwnQueMaTSwE7eoPeT/usoiCT2ap/3V5i1lxhK+4cNbeOgwyev7V8769aEbflpRJL
	cUaioRZzUXEiAOmarReEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 11:27, Paul Bolle wrote:
> On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
>> All Samsung platforms are now using the Common Clock Framework and the
>> legacy clock code is being removed, so remove related dead code from
>> samsung-serial driver as well.
>>
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:SERIAL DRIVERS)
>> Cc: Jiri Slaby <jslaby@suse.cz> (supporter:TTY LAYER)
>> Cc: linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
>> ---
>>  drivers/tty/serial/samsung.c | 4 ----
>>  1 file changed, 4 deletions(-)
> 
> This just entered linux-next (see next-20140716).
> 
>> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
>> index 36c7747..cae8ebd 100644
>> --- a/drivers/tty/serial/samsung.c
>> +++ b/drivers/tty/serial/samsung.c
>> @@ -47,10 +47,6 @@
>>  
>>  #include <asm/irq.h>
>>  
>> -#ifdef CONFIG_SAMSUNG_CLOCK
>> -#include <plat/clock.h>
>> -#endif
>> -
>>  #include "samsung.h"
>>  
>>  #if	defined(CONFIG_SERIAL_SAMSUNG_DEBUG) &&	\
> 
> There are three further references to CONFIG_SAMSUNG_CLOCK in this file.
> Those should be removed too, shouldn't they?

That's right. Apparently I missed them. I guess that's not critical,
though, and could be done in separate patch, right?

Best regards,
Tomasz
