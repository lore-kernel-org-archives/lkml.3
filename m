Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3LSMmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:42:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62509 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3LSMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:42:09 -0500
MIME-Version: 1.0
In-Reply-To: <52B2E7D9.4030908@gmail.com>
References: <1387451598-14490-1-git-send-email-vgupta@synopsys.com>
	<52B2E7D9.4030908@gmail.com>
Date: Thu, 19 Dec 2013 13:42:08 +0100
X-Google-Sender-Auth: C0s2dzM1nYp4Ejs4q2kxD6fVHGU
Message-ID: <CAMuHMdUYuf8+d+ahiHW4g-wfmjXOuR1T_g9LQ3_L3zy3ON=URw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 1:34 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> On 12/19/2013 07:13 PM, Vineet Gupta wrote:
>> This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.
>>
>> Generic syscall table generator relies on ARCH unistd.h as follows:
>>
>>       void *sys_call_table[NR_syscalls] = {
>>               [0 ... NR_syscalls-1] = sys_ni_syscall,
>>       #include <asm/unistd.h>
>>       };
>>
>> And turns out that prior dependencies already include that header by
>> the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
>> able to included twice.
>
> OK, thanks, it sounds reasonable to me.
>
> But why many other architectures contents these guard macros? (arm, sh,
> blackfin, cris, frv, ia64, m32r, m68k, mips, s390, microblaze, mn10300,
> parisc, powerpc, sparc, x86). Do they need improvement too?

Those architectures don't use the generic syscall table generator.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
