Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3EOU5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:57:20 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:35016 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3EOU5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <5193A7C3.4010503@amd.com>
References: <51935981.3010808@amd.com>
	<CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
	<5193A7C3.4010503@amd.com>
Date: Wed, 15 May 2013 13:57:18 -0700
X-Google-Sender-Auth: lOVRjQGzhKQOj0wHkKLHjpJMUm8
Message-ID: <CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com>
Subject: Re: 3.9 breaks EFI boot on E350
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 8:20 AM, Christian König
<christian.koenig@amd.com> wrote:
> Am 15.05.2013 16:46, schrieb Yinghai Lu:
>
>> On Wed, May 15, 2013 at 2:46 AM, Christian König
>> <christian.koenig@amd.com> wrote:
>>>
>>> Hi guys,
>>>
>>> the following commit breaks booting my E350 based test system in EFI
>>> mode:
>>>
>>>> commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>> Date:   Fri Nov 16 19:38:58 2012 -0800
>>>>
>>>>      x86, mm: setup page table in top-down
>>>
>>>
>>> This commit was supposed to fix it but obviously there still seem to be
>>> some
>>> bugs left in 3.9
>>>
>>>> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>> Date:   Wed Mar 6 20:18:21 2013 -0800
>>>>
>>>>      x86, mm: Make sure to find a 2M free block for the first mapped
>>>> area
>>>>
>>>>      Henrik reported that his MacAir 3.1 would not boot with
>>>>
>>>>      | commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>>>      | Date:   Fri Nov 16 19:38:58 2012 -0800
>>>>      |
>>>>      |    x86, mm: setup page table in top-down
>>>>
>> can you send out working boot log with memory map?
>>
>> you need to boot system with "debug ignore_loglevel"
>
>
> Sure, dmesg output it attached. Let me know if you need anything else.
>

[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006ea07fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006ea08000-0x000000006ea55fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006ea56000-0x000000006f47efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f47f000-0x000000006f87bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006f87c000-0x000000006f87cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000006f87d000-0x000000006f883fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f884000-0x000000006fc97fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006fc98000-0x000000006fef2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006fef3000-0x000000006fefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved

the kernel code should handle the memmap properly. and I use user
memmap to simulate the
that memmap, kernel could boot well.

so your system does not have serial port?

Can you boot failed kernel on your system with "earlyprintk=ttyS0,115200
memblock=debug" to see
where is crash or hang?
