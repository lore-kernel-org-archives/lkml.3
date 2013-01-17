Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3AQPDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:03:22 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:51332 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753594Ab3AQPDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:03:20 -0500
Message-ID: <50F812B5.5050507@fold.natur.cuni.cz>
Date: Thu, 17 Jan 2013 16:03:17 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: =?UTF-8?B?QWxleCBWaWxsYWPDrXMgTGFzc28=?= <a_villacis@palosanto.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range -
 is this safe?
References: <50F606A8.2080804@palosanto.com> <CAE9FiQXg29gdrC8RK0Z8vLexju3yNpu9MvJcYHUoPnCNceSWkw@mail.gmail.com> <50F744A1.1080806@palosanto.com> <CAE9FiQVOYk8GLhPU2z2AiTk6qFKcf0WTii+1ckbmyDY79436vg@mail.gmail.com>
In-Reply-To: <CAE9FiQVOYk8GLhPU2z2AiTk6qFKcf0WTii+1ckbmyDY79436vg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jan 16, 2013 at 4:24 PM, Alex Villacís Lasso
> <a_villacis@palosanto.com> wrote:
>> El 16/01/13 02:11, Yinghai Lu escribió:
>>
>>> On Tue, Jan 15, 2013 at 5:47 PM, Alex Villacís Lasso
>>> <a_villacis@palosanto.com> wrote:
>>>>
>>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff]
>>>> usable
>>>> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff]
>>>> reserved
>>>> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
>>>> reserved
>>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff]
>>>> usable
>>>> [    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff]
>>>> ACPI
>>>> NVS
>>>> [    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff]
>>>> ACPI
>>>> data
>>>> [    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff]
>>>> reserved
>>>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
>>>> reserved
>>>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
>>>> reserved
>>>> [    0.000000] NX (Execute Disable) protection: active
>>>
>>> ..
>>>>
>>>> [    0.000000] original variable MTRRs
>>>> [    0.000000] reg 0, base: 4GB, range: 512MB, type WB
>>>> [    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
>>>> [    0.000000] reg 2, base: 0GB, range: 2GB, type WB
>>>> [    0.000000] reg 3, base: 2GB, range: 1GB, type WB
>>>> [    0.000000] reg 4, base: 3GB, range: 256MB, type WB
>>>> [    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
>>>> [    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
>>>> [    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
>>>> [    0.000000] total RAM covered: 4086M
>>>
>>> Can you apply attached debug patch to see if the raw e820 is right from
>>> BIOS ?
> 
>> Done. The output is attached. I see no difference between raw and sanitized
>> maps.
> 
> yeah, it is BIOS problem.
> 
> you may either live with memmap= or try to get one BIOS update.

Hi Yinghai,
  wouldn't it be useful for other to include this patch into the kernel? It might help
someone else. Provided it is printed only when extra debug is enabled in the kernel
I don't think it hurts. Right?
  Actually, if it could do the check for differences automatically and print a warning
it would be even better.
Martin
