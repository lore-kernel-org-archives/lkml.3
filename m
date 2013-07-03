Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3GCIwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:52:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39723 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3GCIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <51D3E464.9050707@imgtec.com>
References: <1372774074-18553-1-git-send-email-james.hogan@imgtec.com>
	<87bo6kfp32.fsf@rustcorp.com.au>
	<51D3E464.9050707@imgtec.com>
Date: Wed, 3 Jul 2013 10:50:27 +0200
X-Google-Sender-Auth: aX0vsNuTtd1gVsV5Pg8PIRdnHcM
Message-ID: <CAMuHMdV6rd=rBjeF5APzL6+tpjcGx92ZPVGEx=++i5T_aodZDw@mail.gmail.com>
Subject: Re: [PATCH] metag: move EXPORT_SYMBOLs in libs to metag_ksyms.c
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 10:44 AM, James Hogan <james.hogan@imgtec.com> wrote:
> (cc'ing linux-arch and linux-kbuild)
>
> On 03/07/13 01:45, Rusty Russell wrote:
>> James Hogan <james.hogan@imgtec.com> writes:
>>> Move all EXPORT_SYMBOLs in libs-y directories (arch/metag/{lib,tbx})
>>> into metag_ksyms.c so that they don't get omitted by the static linker
>>> if they're not used by any other statically linked code, which can
>>> result in undefined symbols when building modules.
>>>
>>> For example a randconfig caused the following error:
>>> ERROR: "csum_partial" [fs/reiserfs/reiserfs.ko] undefined!
>>>
>>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>>> ---
>>> Unless there are any objections I'll apply this patch for v3.11. I'm
>>> assuming *_ksyms.c is the way that this problem is normally worked
>>> around.
>>
>> Actually, normally those files are obj-y not lib-y.  See the top-level
>> lib/.
>>
>> Subtle, I know.
>
> Hmm, subtle indeed, I hadn't noticed that.
>
> grepping for EXPORT_SYMBOL(csum_partial) gives:
>
> ./arch/avr32/kernel/avr32_ksyms.c
> ./arch/sparc/lib/ksyms.c
> ./arch/sh/kernel/sh_ksyms_32.c
> ./arch/powerpc/kernel/ppc_ksyms.c
> ./arch/unicore32/kernel/ksyms.c
> ./arch/x86/um/ksyms.c
> ./arch/x86/kernel/x8664_ksyms_64.c
> ./arch/x86/kernel/i386_ksyms_32.c
> ./arch/cris/kernel/crisksyms.c
> ./arch/mips/kernel/mips_ksyms.c
> ./arch/xtensa/kernel/xtensa_ksyms.c
> ./arch/arm/kernel/armksyms.c
>
> ./arch/ia64/lib/checksum.c
> ./arch/alpha/lib/checksum.c
> ./arch/c6x/lib/checksum.c
> ./arch/mn10300/lib/checksum.c
> ./arch/cris/arch-v10/lib/old_checksum.c
> ./arch/h8300/lib/checksum.c
> ./arch/parisc/lib/checksum.c
> ./arch/m32r/lib/csum_partial_copy.c
> ./arch/m68k/lib/checksum.c
> ./arch/metag/lib/checksum.c
> ./arch/frv/lib/checksum.c
>
> ./lib/checksum.c
>
> All of the above arches have *c*sum.o in lib-y. Should they all be
> switched to obj-y or the remaining EXPORT_SYMBOLs moved to *ksyms.c if
> this problem is noticed?

There are more, cfr. https://lkml.org/lkml/2013/5/29/76 ("[PATCH/RFC] sh: Always
link in helper functions extracted from libgcc"), which no one replied to.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
