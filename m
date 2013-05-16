Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3EPMt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:49:58 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18123
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647Ab3EPMty convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:49:54 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Ic89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMW6AX-02-0Y7-02
X-M-MSG: 
Message-ID: <5194D5E6.2070605@amd.com>
Date: Thu, 16 May 2013 14:49:42 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Gloger <wg@malloc.de>
Subject: Re: 3.9 breaks EFI boot on E350
References: <51935981.3010808@amd.com> <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com> <5193A7C3.4010503@amd.com> <CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com> <5194A9CF.3080509@amd.com>
In-Reply-To: <5194A9CF.3080509@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.05.2013 11:41, schrieb Christian König:
> Am 15.05.2013 22:57, schrieb Yinghai Lu:
>> On Wed, May 15, 2013 at 8:20 AM, Christian König
>> <christian.koenig@amd.com> wrote:
>>> Am 15.05.2013 16:46, schrieb Yinghai Lu:
>>>
>>>> On Wed, May 15, 2013 at 2:46 AM, Christian König
>>>> <christian.koenig@amd.com> wrote:
>>>>> Hi guys,
>>>>>
>>>>> the following commit breaks booting my E350 based test system in EFI
>>>>> mode:
>>>>>
>>>>>> commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>>>> Date:   Fri Nov 16 19:38:58 2012 -0800
>>>>>>
>>>>>>       x86, mm: setup page table in top-down
>>>>>
>>>>> This commit was supposed to fix it but obviously there still seem 
>>>>> to be
>>>>> some
>>>>> bugs left in 3.9
>>>>>
>>>>>> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
>>>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>>>> Date:   Wed Mar 6 20:18:21 2013 -0800
>>>>>>
>>>>>>       x86, mm: Make sure to find a 2M free block for the first 
>>>>>> mapped
>>>>>> area
>>>>>>
>>>>>>       Henrik reported that his MacAir 3.1 would not boot with
>>>>>>
>>>>>>       | commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>>>>>       | Date:   Fri Nov 16 19:38:58 2012 -0800
>>>>>>       |
>>>>>>       |    x86, mm: setup page table in top-down
>>>>>>
>>>> can you send out working boot log with memory map?
>>>>
>>>> you need to boot system with "debug ignore_loglevel"
>>>
>>> Sure, dmesg output it attached. Let me know if you need anything else.
>>>
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] 
>> usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006ea07fff] 
>> usable
>> [    0.000000] BIOS-e820: [mem 0x000000006ea08000-0x000000006ea55fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x000000006ea56000-0x000000006f47efff] 
>> ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000006f47f000-0x000000006f87bfff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x000000006f87c000-0x000000006f87cfff] 
>> usable
>> [    0.000000] BIOS-e820: [mem 0x000000006f87d000-0x000000006f883fff] 
>> ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000006f884000-0x000000006fc97fff] 
>> usable
>> [    0.000000] BIOS-e820: [mem 0x000000006fc98000-0x000000006fef2fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x000000006fef3000-0x000000006fefffff] 
>> usable
>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] 
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] 
>> reserved
>>
>> the kernel code should handle the memmap properly. and I use user
>> memmap to simulate the
>> that memmap, kernel could boot well.
>>
>> so your system does not have serial port?
>
> Unfortunately not, this board doesn't even have an PCI slot otherwise 
> I could install a card there.
>
> Anything else I could do?
>

Ups, the board DOES have a serial port, and I've got a log now that 
shows the mentioned patch above isn't the root cause.

After commit 8d57470d8f859635deffe3919d7d4867b488b85a it indeed crashes 
very early in the boot sequence, but commit 
98e7a989979b185f49e86ddaed2ad6890299d9f0 fixes that and now it crashes 
while trying to unpack the initrd with a completely different backtrace.

Sorry for the noise, one black screen while bisecting is as good as 
another, but obviously not the same root cause.

Cheers,
Christian.

> Christian.
>
>>
>> Can you boot failed kernel on your system with "earlyprintk=ttyS0,115200
>> memblock=debug" to see
>> where is crash or hang?
>>
>


