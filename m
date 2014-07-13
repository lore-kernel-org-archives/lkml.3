Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGMGDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 02:03:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55505 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaGMGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 02:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <1404789011.16156.39.camel@pasglop>
References: <1404153930-26568-1-git-send-email-linux@roeck-us.net>
	<53BB5F9A.2060105@roeck-us.net>
	<1404789011.16156.39.camel@pasglop>
Date: Sun, 13 Jul 2014 02:02:59 -0400
Message-ID: <CAPDOMVio1ha+inJRRdCebEoxSpTTg=s974FBc_B112UPFaAaMQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
From: Nick Krause <xerofoify@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 11:10 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2014-07-07 at 20:03 -0700, Guenter Roeck wrote:
>> ping ...
>>
>> Ben, I know this is not perfect, but on the other side it is simple
>> and would be easy to backport. With this in place, a complete/clean
>> fix would not be as urgent. Any chance to get it applied ?
>
> Yes, that definitely helps, I'll include it as a band aid.
>
> Cheers,
> Ben.
>
>> Nick, this doesn't fix the allyesconfig build - it still fails with
>> relocation errors. But it does fix the allmodconfig build.
>>
>> Thanks,
>> Guenter
>>
>> On 06/30/2014 11:45 AM, Guenter Roeck wrote:
>> > powerpc:allmodconfig has been failing for some time with the following
>> > error.
>> >
>> > arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> > arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
>> > make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
>> >
>> > A number of attempts to fix the problem by moving around code have been
>> > unsuccessful and resulted in failed builds for some configurations and
>> > the discovery of toolchain bugs.
>> >
>> > Fix the problem by disabling RELOCATABLE for COMPILE_TEST builds instead.
>> > While this is less than perfect, it avoids substantial code changes
>> > which would otherwise be necessary just to make COMPILE_TEST builds
>> > happy and might have undesired side effects.
>> >
>> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> > ---
>> >   arch/powerpc/Kconfig | 3 ++-
>> >   1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> > index bd6dd6e..fefe7c8 100644
>> > --- a/arch/powerpc/Kconfig
>> > +++ b/arch/powerpc/Kconfig
>> > @@ -414,7 +414,7 @@ config KEXEC
>> >   config CRASH_DUMP
>> >     bool "Build a kdump crash kernel"
>> >     depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
>> > -   select RELOCATABLE if PPC64 || 44x || FSL_BOOKE
>> > +   select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x || FSL_BOOKE
>> >     help
>> >       Build a kernel suitable for use as a kdump capture kernel.
>> >       The same kernel binary can be used as production kernel and dump
>> > @@ -1017,6 +1017,7 @@ endmenu
>> >   if PPC64
>> >   config RELOCATABLE
>> >     bool "Build a relocatable kernel"
>> > +   depends on !COMPILE_TEST
>> >     select NONSTATIC_KERNEL
>> >     help
>> >       This builds a kernel image that is capable of running anywhere
>> >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
Thanks for applying the patch. Works for me too.Sorry about the late
reply working on other build
issues and fix me messages.
Nick
