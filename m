Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaHEQas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:30:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62592 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaHEQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:30:45 -0400
Message-ID: <53E106B1.9040704@gmail.com>
Date: Wed, 06 Aug 2014 00:30:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jean Delvare <jdelvare@suse.de>
CC: Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] drivers/isdn/hisax/Kconfig: Let HISAX_NETJET skip microblaze
 architecture
References: <53DFCFC9.6060307@gmail.com>	<20140804212354.74b97cd7@endymion.delvare> <CAMuHMdVGgW11UziFieCgXT7mSNA=_QgOaGAt42kEXqU9CUgqxA@mail.gmail.com> <53E05BC9.3060500@gmail.com>
In-Reply-To: <53E05BC9.3060500@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 12:21 PM, Chen Gang wrote:
> 
> 
> On 08/05/2014 03:44 AM, Geert Uytterhoeven wrote:
>> On Mon, Aug 4, 2014 at 9:23 PM, Jean Delvare <jdelvare@suse.de> wrote:
>>>> --- a/drivers/isdn/hisax/Kconfig
>>>> +++ b/drivers/isdn/hisax/Kconfig
>>>> @@ -237,7 +237,7 @@ config HISAX_MIC
>>>>
>>>>  config HISAX_NETJET
>>>>       bool "NETjet card"
>>>> -     depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
>>>> +     depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || MICROBLAZE))
>>>>       depends on VIRT_TO_BUS
>>>>       help
>>>>         This enables HiSax support for the NetJet from Traverse
>>>> @@ -249,7 +249,7 @@ config HISAX_NETJET
>>>>
>>>>  config HISAX_NETJET_U
>>>>       bool "NETspider U card"
>>>> -     depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
>>>> +     depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || MICROBLAZE))
>>>>       depends on VIRT_TO_BUS
>>>>       help
>>>>         This enables HiSax support for the Netspider U interface ISDN card
>>>
>>> Fine with me, however the list is getting long. It would be better if
>>> we could depend on a functional symbol rather than a negated list of
>>> architectures. Would it make sense to have CONFIG_CPU_LITTLE_ENDIAN
>>> defined on all little-endian architectures, so that driver can depend
>>> on that if needed?
>>
>> Yes, that idea pops up once in a while.
>>
>> BTW, these days little endian PPC is also supported by Linux...
>>
>>> Alternatively, it might make more sense to list the architectures where
>>> these drivers are actually used in practice. I guess that's X86, maybe
>>> ARM and IA64, and that's all?
>>
>> || COMPILE_TEST ....
>>
> 

If no additional response within 3 days, I shall continue to try to send
patch for it.

Excuse me, I need additional thinking of for it, so I plan to send patch
for discussing and review within next week end (2014-08-17).

And welcome any members' ideas, suggestions and completions.

Thanks.

> OK, thanks, what all of you said sounds reasonable to me.
> 
> Hello Geert:
> 
> Could you help send the related patch for it?
> 
> 
> Thanks.
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
