Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaDMK0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 06:26:40 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48643 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaDMK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 06:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
	<87eh12hr1t.fsf@tassilo.jf.intel.com>
	<trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>
Date: Sun, 13 Apr 2014 12:26:38 +0200
Message-ID: <CAFLxGvyiVaONh61j7z1s6u15f0Uz-Yb3Js0Vk9C2WiB6OR4yKA@mail.gmail.com>
Subject: Re: Re: new module to check constant memory for corruption
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Alexander.Kleinsorge@gmx.de
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 12:14 PM,  <Alexander.Kleinsorge@gmx.de> wrote:
> Hi Andi,
>
> the module considers only the adress range between: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata").
> this range has a typical size of 10..20 mb (depending on kernel-version and arch).
> see files: linux-3.*\arch\x86\mm\init_32.c + init_64.c
> function: void mark_rodata_ro(void)
> "Write protecting the kernel text: %luk\n"
> "Write protecting the kernel read-only data: %luk\n"
> dmesg | grep protecting
>
> your question: there are no writes in this write protected adress range (e.g. kernel code).

And what happens if one enables dynamic ftrace or other kernel
features which modify kernel code?

> my idea is to calculate a checksum (xor is fastest) over this range and check later (periodically) if its unchanged.
> see source code download (5 KB): http://tauruz.homeip.net/ramcheck.tgz
> the code is working fine and the checksum is (as expected) constant (at least for many hours).
>
> regards, Alexander
>
>
> Gesendet: Sonntag, 13. April 2014 um 05:00 Uhr
> Von: "Andi Kleen" <andi@firstfloor.org>
> An: Alexander.Kleinsorge@gmx.de
> Cc: linux-kernel@vger.kernel.org
> Betreff: Re: new module to check constant memory for corruption
> Alexander.Kleinsorge@gmx.de writes:
>
>> ramcheck kernel module
>> new module to check constant memory for corruption
>>
>> detect corruption of constant kernel memory (text and data) periodically.
>> runtime costs about 1..2 ms per sec (about 10 mb with 5 mb/ms),
>> which is distributed over 8 (BLOCKS) time partitions (less than half
>> ms per sec).
>> in case of checksum (xor) error, an kernel log is posted.
>> manual trigger via /proc/ramcheck is possible.
>> range: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata")
>
>
> Can you explain how this works? How does it handle legal writes?
>
> If it just checks its own memory it could be done in user space.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
