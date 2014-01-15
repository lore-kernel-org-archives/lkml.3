Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaAOT7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:59:34 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60223 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaAOT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXz93YsqzxR1hny2P8afMWEQGMw19=o=S7cR0rT9QvRFQ@mail.gmail.com>
References: <CAMuHMdXz93YsqzxR1hny2P8afMWEQGMw19=o=S7cR0rT9QvRFQ@mail.gmail.com>
Date: Wed, 15 Jan 2014 20:59:31 +0100
X-Google-Sender-Auth: qpMkwURSnO3p58k2ks2t-6yihXI
Message-ID: <CAMuHMdUJhjtogAPKzN6cua1KdtMbhZ1U0MBt6QaD6t3e_BMCMQ@mail.gmail.com>
Subject: Re: futex: Switch to USER_DS for futex test (was: Re: linux-next:
 manual merge of the akpm-current tree with the tip tree)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 5:32 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> https://lkml.org/lkml/2013/12/11/141
>
> On Tue, Jan 14, 2014 at 5:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/14/2014 05:17 AM, Geert Uytterhoeven wrote:
>>>>
>>>> This seems terribly broken, the *futex_value*() ops should not need
>>>> that; they are supposed to access userspace without any of that.
>>>
>>> Why don't they need set_fs(USER_DS)?
>>
>> Because USER_DS is the normal operating state?  It would appear m68k is
>
> Is it?
>
>> the only(?) arch that calls initcalls with get_fs() == KERNEL_DS...
>
> On ARM:
>
> fs = 0x0, USER_DS = 0xbf000000, KERNEL_DS = 0x0
>
> Presumably also on s390, as the fix for m68k broke s390. That's why it's still
> in -mm and not yet in mainline.

On uml/amd64:

fs = 0xffffffff, USER_DS = 0x7fc0000000, KERNEL_DS = 0xffffffff

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
