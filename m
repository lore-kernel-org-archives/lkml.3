Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaIXMm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:42:58 -0400
Received: from blu004-omc2s38.hotmail.com ([65.55.111.113]:49813 "EHLO
	BLU004-OMC2S38.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbaIXMm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:42:57 -0400
X-TMN: [yfLf55Z+fGGSodFZJhIvjlLUJJOroNZR]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU437-SMTP36FDD8606D9D645C6428697B10@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: nick <yocto6@gmail.com>
In-Reply-To: <5422AE20.3050702@gmail.com>
Subject: Re: [PATCH] parisc:Remove unnecessary FIXMES in init.c
References: <1411523383-9820-1-git-send-email-yocto6@gmail.com> <20140924053036.GA30405@roeck-us.net> <5422AE20.3050702@gmail.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Wed, 24 Sep 2014 08:42:37 -0400
CC: Guenter Roeck <linux@roeck-us.net>, jejb@parisc-linux.org, deller@gmx.de,
        akpm@linux-foundation.org, mgorman@suse.de, julia.lawall@lip6.fr,
        himangi774@gmail.com, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 24 Sep 2014 12:42:55.0023 (UTC) FILETIME=[0FDE73F0:01CFD7F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-Sep-14, at 7:42 AM, nick wrote:

>
>
> On 14-09-24 01:30 AM, Guenter Roeck wrote:
>> On Tue, Sep 23, 2014 at 09:49:43PM -0400, Nicholas Krause wrote:
>>> This removes the two fixmes in the file, init.c for compiler hints
>>> for comments related to compiler hints in linux_gateway_page_addr
>>> and map_hpux_gateway_page to change from FIXME to HINT in order
>>> for people reading this code to understand that these are compiler
>>> hints.
>>>
>>
>> "* const" tells the compiler that a pointer is a constant.
>> It doesn't tell the compiler that the data shall not be treated
>> as DP-relative.
>>
>> FIXME as in: We should find a better way to tell the compiler to
>> not treat this data as DP-relative.
>>
>> Can you please stop this ?
>>
>> Guenter
>>
>>> Signed-off-by: Nicholas Krause <yocto6@gmail.com>
>>> ---
>>> arch/parisc/mm/init.c | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
>>> index 0bef864..668102e 100644
>>> --- a/arch/parisc/mm/init.c
>>> +++ b/arch/parisc/mm/init.c
>>> @@ -733,7 +733,7 @@ static void __init pagetable_init(void)
>>> static void __init gateway_init(void)
>>> {
>>> 	unsigned long linux_gateway_page_addr;
>>> -	/* FIXME: This is 'const' in order to trick the compiler
>>> +	/* HINT: This is 'const' in order to trick the compiler
>>> 	   into not treating it as DP-relative data. */
>>> 	extern void * const linux_gateway_page;
>>>
>>> @@ -761,7 +761,7 @@ map_hpux_gateway_page(struct task_struct *tsk,  
>>> struct mm_struct *mm)
>>> 	unsigned long start_pte;
>>> 	unsigned long address;
>>> 	unsigned long hpux_gw_page_addr;
>>> -	/* FIXME: This is 'const' in order to trick the compiler
>>> +	/* HINT: This is 'const' in order to trick the compiler
>>> 	   into not treating it as DP-relative data. */
>>> 	extern void * const hpux_gateway_page;
>>>
>>> -- 
>>> 1.9.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux- 
>>> kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
> Guenter,
> I asked the maintainers and I got,
> On 9/23/2014 4:48 PM, Helge Deller wrote:
>> The FIXME: is misleading. It should maybe better read "HINT:" or  
>> something like that.
>> Trivially it's basically just casting the symbol so that the compiler
>> will produce the correct code later on.
>> There is nothing you could try to "fix".
> Why not just remove "FIXME: " from these comments?


The wording of the comment is not good.  You can't "trick" the  
compiler into not
treating a constant as DP-relative data.  Whether or not a constant is  
loaded as an
immediate depends on its value.

Dave
--
John David Anglin	dave.anglin@bell.net



