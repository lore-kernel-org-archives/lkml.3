Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3LSNll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:41:41 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45747 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3LSNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:41:39 -0500
Message-ID: <52B2F78A.5060404@gmail.com>
Date: Thu, 19 Dec 2013 21:41:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
References: <1387451598-14490-1-git-send-email-vgupta@synopsys.com> <52B2E7D9.4030908@gmail.com> <CAMuHMdUYuf8+d+ahiHW4g-wfmjXOuR1T_g9LQ3_L3zy3ON=URw@mail.gmail.com>
In-Reply-To: <CAMuHMdUYuf8+d+ahiHW4g-wfmjXOuR1T_g9LQ3_L3zy3ON=URw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 08:42 PM, Geert Uytterhoeven wrote:
> On Thu, Dec 19, 2013 at 1:34 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> On 12/19/2013 07:13 PM, Vineet Gupta wrote:
>>> This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.
>>>
>>> Generic syscall table generator relies on ARCH unistd.h as follows:
>>>
>>>       void *sys_call_table[NR_syscalls] = {
>>>               [0 ... NR_syscalls-1] = sys_ni_syscall,
>>>       #include <asm/unistd.h>
>>>       };
>>>
>>> And turns out that prior dependencies already include that header by
>>> the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
>>> able to included twice.
>>
>> OK, thanks, it sounds reasonable to me.
>>
>> But why many other architectures contents these guard macros? (arm, sh,
>> blackfin, cris, frv, ia64, m32r, m68k, mips, s390, microblaze, mn10300,
>> parisc, powerpc, sparc, x86). Do they need improvement too?
> 
> Those architectures don't use the generic syscall table generator.
> 

OK, thanks. :-)


> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
