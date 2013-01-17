Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3AQAbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:31:39 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40560 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3AQAbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:31:38 -0500
MIME-Version: 1.0
In-Reply-To: <50F744A1.1080806@palosanto.com>
References: <50F606A8.2080804@palosanto.com>
	<CAE9FiQXg29gdrC8RK0Z8vLexju3yNpu9MvJcYHUoPnCNceSWkw@mail.gmail.com>
	<50F744A1.1080806@palosanto.com>
Date: Wed, 16 Jan 2013 16:31:36 -0800
X-Google-Sender-Auth: N96FXWxLB6I3XSDIEz-xCzk-Z_A
Message-ID: <CAE9FiQVOYk8GLhPU2z2AiTk6qFKcf0WTii+1ckbmyDY79436vg@mail.gmail.com>
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range - is
 this safe?
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 4:24 PM, Alex Villacís Lasso
<a_villacis@palosanto.com> wrote:
> El 16/01/13 02:11, Yinghai Lu escribió:
>
>> On Tue, Jan 15, 2013 at 5:47 PM, Alex Villacís Lasso
>> <a_villacis@palosanto.com> wrote:
>>>
>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff]
>>> usable
>>> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff]
>>> reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
>>> reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff]
>>> usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff]
>>> ACPI
>>> NVS
>>> [    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff]
>>> ACPI
>>> data
>>> [    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff]
>>> reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
>>> reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
>>> reserved
>>> [    0.000000] NX (Execute Disable) protection: active
>>
>> ..
>>>
>>> [    0.000000] original variable MTRRs
>>> [    0.000000] reg 0, base: 4GB, range: 512MB, type WB
>>> [    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
>>> [    0.000000] reg 2, base: 0GB, range: 2GB, type WB
>>> [    0.000000] reg 3, base: 2GB, range: 1GB, type WB
>>> [    0.000000] reg 4, base: 3GB, range: 256MB, type WB
>>> [    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
>>> [    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
>>> [    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
>>> [    0.000000] total RAM covered: 4086M
>>
>> Can you apply attached debug patch to see if the raw e820 is right from
>> BIOS ?

> Done. The output is attached. I see no difference between raw and sanitized
> maps.

yeah, it is BIOS problem.

you may either live with memmap= or try to get one BIOS update.

Yinghai
