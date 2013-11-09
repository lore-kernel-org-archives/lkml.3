Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3KITdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 14:33:54 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756302Ab3KITdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 14:33:50 -0500
Message-ID: <527E8E19.9030802@nod.at>
Date: Sat, 09 Nov 2013 20:33:45 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs in
 radix_tree_next_chunk()
References: <526696BF.6050909@gmx.de>	<CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com>	<5266A698.10400@gmx.de>	<5266B60A.1000005@nod.at>	<52715AD1.7000703@gmx.de> <CALYGNiPvJF1u8gXNcX1AZR5-VkGqJnaose84KBbdaoBAq8aoGQ@mail.gmail.com> <527AB23D.2060305@gmx.de> <527AB51B.1020005@nod.at> <527E87EA.8080700@gmx.de>
In-Reply-To: <527E87EA.8080700@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.11.2013 20:07, schrieb Toralf Förster:
> On 11/06/2013 10:31 PM, Richard Weinberger wrote:
>> Am 06.11.2013 22:18, schrieb Toralf Förster:
>>> On 11/06/2013 05:06 PM, Konstantin Khlebnikov wrote:
>>>> In this case it must stop after scanning whole tree in line:
>>>> /* Overflow after ~0UL */
>>>> if (!index)
>>>>   return NULL;
>>>>
>>>
>>> A fresh current example with latest git tree shows that lines 769 and 770 do alternate :
>>
>> Can you please ask gdb for the value of offset?
>>
>> Thanks,
>> //richard
>>
> 
> Still trying to get those values. One attempt to do that was to replace -O2 with -O0 in the Makefile,
> but that resulted into this error :
> 
>   LD      kernel/built-in.o
>   CC      mm/memory.o
> In function ‘zap_pmd_range’,
>     inlined from ‘zap_pud_range’ at mm/memory.c:1265:8,
>     inlined from ‘unmap_page_range’ at mm/memory.c:1290:8:
> mm/memory.c:1220:23: error: call to ‘__compiletime_assert_1220’ declared with attribute error: BUILD_BUG failed
> mm/memory.c: In function ‘follow_page_mask’:
> mm/memory.c:1530:18: error: call to ‘__compiletime_assert_1530’ declared with attribute error: BUILD_BUG failed
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
> 
> 
> With -O1 it compiled at least.

You cannot build Linux with -O1/O0.
Try printing the value using printk...

Thanks,
//richard
