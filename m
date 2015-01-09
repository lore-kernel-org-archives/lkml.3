Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbbAISnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:43:07 -0500
Received: from smtp25.services.sfr.fr ([93.17.128.119]:43474 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbbAISnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:43:04 -0500
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20150109184301283.45326700009D@msfrf2512.sfr.fr
Message-ID: <54B02132.8060004@free.fr>
Date: Fri, 09 Jan 2015 19:42:58 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101
	Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: ioremap vs remap_pfn_range, VMSPLIT, etc
References: <54AFD09E.1010806@free.fr>
	<20150109131322.GO12302@n2100.arm.linux.org.uk> <54B013F0.10408@free.fr>
	<54B018B8.1080306@arm.com>
In-Reply-To: <54B018B8.1080306@arm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vladimir,

On 09/01/2015 19:06, Vladimir Murzin wrote:
> On 09/01/15 17:46, Mason wrote:
>> On 09/01/2015 14:13, Russell King - ARM Linux wrote:
>>
>>> On Fri, Jan 09, 2015 at 01:59:10PM +0100, Mason wrote:
>>>
>>>> Yesterday, I used /dev/mem to mmap 2 GB and (to my surprise) it worked.
>>>> Specifically, I opened /dev/mem O_RDWR | O_SYNC
>>>> then called
>>>>   mmap(NULL, 1U<<31, PROT_WRITE, MAP_SHARED, fd, 0x80000000);
>>>
>>> So you asked to map 2GB starting at 2GB physical.
>>>
>>>> And mmap returned a valid pointer.
>>>
>>> And that mapping would have been created to map physical addresses
>>> 0x80000000-0xffffffff inclusive.
>>>
>>>> I was expecting it to fail.
>>>>
>>>> - the kernel is configured with VMSPLIT_3G (3G/1G user/kernel)
>>>
>>> This has no bearing on the above.
>>
>> I don't understand why.
>>
>> mmap allocates virtual addresses in the user-space process, yes?
>> So if I had VMSPLIT_2G, user-space processes would be limited
>> to 2G virtual addresses, and could not create a single 2G map
>> on top of its stack and text space. Or am I missing something?
> 
> Because you are mmaping special file (dev/mem) mmap call is routed to
> the dedicated hook, responsible for all "magic" you see. Please, take a
> look at drivers/char/mem.c for details.

Errr, I thought it was clear I had read the source ;-)
("I know /dev/mem's mmap calls remap_pfn_range [...]")
http://lxr.free-electrons.com/source/drivers/char/mem.c#L307

Hence my ioremap vs remap_pfn_range subject ;-)

So are you saying I could use remap_pfn_range to map the
full 4G of PA space into a process's VA space?

Or, if I picked the VMSPLIT_2G option, are you saying
mmap'ing 2G would succeed? (I will test these two
scenarios ASAP.)

Regards.
