Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaJHUuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:50:24 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34170 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbaJHUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <20141008154659.31f46436@as>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
 <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com> <20141008154659.31f46436@as>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Oct 2014 13:50:01 -0700
Message-ID: <CALCETrW6C+Hnx964uBQgD_JNCjGJAq3v=oeMc7vZB0E4_EDeXQ@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 1:46 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Wed, 8 Oct 2014 12:16:11 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Wed, Oct 8, 2014 at 11:52 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> > I'm seeing the following build failure on a 32-bit x86 build in Fedora
>> > based on Linux v3.17-2860-gef0625b70dac:
>> >
>> > Documentation/vDSO/vdso_standalone_test_x86.o: In function `to_base10':
>> > vdso_standalone_test_x86.c:(.text+0xcc): undefined reference to `__umoddi3'
>> > vdso_standalone_test_x86.c:(.text+0xea): undefined reference to `__udivdi3'
>> > collect2: error: ld returned 1 exit status
>> > scripts/Makefile.host:100: recipe for target
>> > 'Documentation/vDSO/vdso_standalone_test_x86' failed
>> > make[2]: *** [Documentation/vDSO/vdso_standalone_test_x86] Error 1
>> > scripts/Makefile.build:404: recipe for target 'Documentation/vDSO' failed
>> > make[1]: *** [Documentation/vDSO] Error 2
>> > make[1]: *** Waiting for unfinished jobs....
>> > Makefile:922: recipe for target 'vmlinux' failed
>> > make: *** [vmlinux] Error 2
>> >
>> It should build and work on 32-bit.
>>
>> Except that the makefile is totally bogus.  vdso_standalone_test isn't
>> a hostprog at all.  It's a target prog.  But kbuild doesn't understand
>> that, so I have no idea what, if anything, that makefile is supposed
>> to do.
>
> Heh, I was wondering why I got a 64-bit program with ARCH=i386

Once kselftest takes off, we'll have lots of fun.  In principle,
x86_64 kernels should pass the 32-bit tests, too :)

>
>> I would argue that the whole documentation build system should be
>> fixed to cross-compile or should just be disabled for cross-builds if
>> glibc isn't available.
>>
>
> Fedora doesn't cross-compile i686 builds because of problems like
> this. It sets up an i386 chroot and runs all native tools inside of
> it.
>

In this particular case, cross-compiling would have worked around the bug.

--Andy
