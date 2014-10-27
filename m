Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaJ0Par (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:30:47 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37480 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaJ0Pao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <87wq7lpx55.fsf@tassilo.jf.intel.com>
References: <d2466423e1d88f24a52e746d4f5c6a7abce982ae.1413844952.git.luto@amacapital.net>
 <87wq7lpx55.fsf@tassilo.jf.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Oct 2014 08:30:22 -0700
Message-ID: <CALCETrUT=ZKNn=i0yzsVfkbY8jKrKwH-PqTYyc_wC7HdRa1Ubw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8 only] x86,vdso: Use LSL unconditionally for vgetcpu
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 4:31 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> LSL is faster than RDTSCP and works everywhere; there's no need to
>> switch between them depending on CPU.
>
> Yes it should have been done like this from day 1.
>
>> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
>> index 9793322751e0..d14bb8faad16 100644
>> --- a/arch/x86/vdso/vclock_gettime.c
>> +++ b/arch/x86/vdso/vclock_gettime.c
>> @@ -11,6 +11,9 @@
>>   * Check with readelf after changing.
>>   */
>>
>> +/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
>> +#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS
>> +
>>  #include <uapi/linux/time.h>
>>  #include <asm/vgtod.h>
>>  #include <asm/hpet.h>
>> diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
>> index add1d98d2477..fd8470c98ab5 100644
>> --- a/arch/x86/vdso/vgetcpu.c
>> +++ b/arch/x86/vdso/vgetcpu.c
>> @@ -5,10 +5,12 @@
>>   * Fast user context implementation of getcpu()
>>   */
>>
>> +/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
>> +#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS
>
>
> These two hunks are unrelated?
>

They're related, but they're no longer necessary.  v1 of this patch
added a static_cpu_has call to vgtod.h, breaking compilation if this
hunk wasn't there.

I can send a v3 with these deleted, but I prefer keeping them, since
they may save whomever modifies these files next a compiler error.

--Andy

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only



-- 
Andy Lutomirski
AMA Capital Management, LLC
