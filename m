Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3FQOse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:48:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37383 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3FQOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:48:31 -0400
Message-ID: <51BF21D7.60707@gmail.com>
Date: Mon, 17 Jun 2013 07:48:55 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: David Daney <ddaney.cavm@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/2] mn10300: Fix include dependency in irqflags.h
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com> <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com> <CAMuHMdXb5ydj-y_=3oPRLVZ4DmmrXrFQi_xxpbkg5DtzORN1gA@mail.gmail.com> <CAMuHMdW4tZCzZ-4wTxsjfhu+UMZqsb2tuTo8+Yho-ZDE2dck8A@mail.gmail.com>
In-Reply-To: <CAMuHMdW4tZCzZ-4wTxsjfhu+UMZqsb2tuTo8+Yho-ZDE2dck8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 03:12 AM, Geert Uytterhoeven wrote:
> On Mon, Jun 17, 2013 at 9:07 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sun, Jun 16, 2013 at 10:06 PM,  <ddaney.cavm@gmail.com> wrote:
>>> From: David Daney <david.daney@cavium.com>
>>>
>>> We need to pick up the definition of raw_smp_processor_id() from
>>> asm/smp.h.  For the !SMP case, we need to supply a definition of
>>> raw_smp_processor_id().
>> Thanks, this fixes the build!
>>
>>> Signed-off-by: David Daney <david.daney@cavium.com>
>> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Sorry, I acked to soon. While SMP=n is fine (asb2303_defconfig),
> there's a new regression with asb2364_defconfig, which has SMP=y:
>
>    CC      arch/mn10300/kernel/asm-offsets.s
> In file included from
> /scratch/geert/linux/linux/arch/mn10300/include/asm/irqflags.h:18:0,
>                   from /scratch/geert/linux/linux/include/linux/irqflags.h:15,
>                   from /scratch/geert/linux/linux/include/linux/spinlock.h:53,
>                   from /scratch/geert/linux/linux/include/linux/seqlock.h:29,
>                   from /scratch/geert/linux/linux/include/linux/time.h:5,
>                   from /scratch/geert/linux/linux/include/uapi/linux/timex.h:56,
>                   from /scratch/geert/linux/linux/include/linux/timex.h:56,
>                   from /scratch/geert/linux/linux/include/linux/sched.h:17,
>                   from
> /scratch/geert/linux/linux/arch/mn10300/kernel/asm-offsets.c:7:
> /scratch/geert/linux/linux/arch/mn10300/include/asm/smp.h:88:34:
> error: unknown type name 'smp_call_func_t'
> make[4]: *** [arch/mn10300/kernel/asm-offsets.s] Error 1

I am truly in Include Hell.  I will attempt a better fix...

David Daney



> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds

