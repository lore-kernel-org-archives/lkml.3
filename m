Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3HOQyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:54:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3HOQyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:54:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org>
	<520A1D56.2050507@roeck-us.net> <20130813175858.GC7336@kroah.com>
	<20130813201936.GA18358@roeck-us.net>
	<CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
	<20130813223622.GA12790@roeck-us.net>
Date: Thu, 15 Aug 2013 17:54:02 +0100
In-Reply-To: <20130813223622.GA12790@roeck-us.net> (Guenter Roeck's message of
	"Tue, 13 Aug 2013 15:36:22 -0700")
Message-ID: <87haeqnbdh.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:

> On Tue, Aug 13, 2013 at 10:49:42PM +0200, Geert Uytterhoeven wrote:
>> On Tue, Aug 13, 2013 at 10:19 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > powerpc/chroma_defconfig:
>> > arch/powerpc/mm/numa.c: In function 'do_init_bootmem':
>> > arch/powerpc/mm/numa.c:529:19: error: 'aa.arrays' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> > arch/powerpc/mm/numa.c:642:22: note: 'aa.arrays' was declared here
>> > cc1: all warnings being treated as errors
>> >
>> > No idea. Code looks all different in 3.10.
>> 
>> Never seen in my log collection from kissb, which doesn't build
>> chroma_defconfig.
>> 
>> > m68k/allmodconfig:
>> > drivers/hid/hid-microsoft.c: In function 'ms_report_fixup':
>> > drivers/hid/hid-microsoft.c:52:18: error: macro "memcmp" passed 6 arguments, but takes just 3
>> > drivers/hid/hid-microsoft.c:51:5: error: 'memcmp' undeclared (first use in this function)
>> > drivers/hid/hid-microsoft.c:51:5: note: each undeclared identifier is reported only once for each function it appears in
>> 
>> Fixed in v3.7-rc6:
>> 
>> commit 6b90466cfec2a2fe027187d675d8d14217c12d82
>> Author: Jiri Slaby <jslaby@suse.cz>
>> Date:   Mon Nov 12 10:16:09 2012 +0100
>> 
>>     HID: microsoft: do not use compound literal - fix build
>> 
> Confirmed. Patching this commit into 3.4 fixes the build for m68k/allmodconfig.
>
>> > blackfin/defconfig:
>> > ERROR: "vm_iomap_memory" [drivers/video/fb.ko] undefined!
>> > make[1]: *** [__modpost] Error 1
>> >
>> > sh/defconfig:
>> > drivers/built-in.o: In function `fb_mmap':
>> > fbmem.c:(.text+0x5e8): undefined reference to `vm_iomap_memory'
>> >
>> > Both look similar and might be easy to fix if someone knows what is wrong.
>> 
>> Fixed in v3.9:
>> 
>> commit 3c0b9de6d37a481673e81001c57ca0e410c72346
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sat Apr 27 13:25:38 2013 -0700
>> 
>>     vm: add no-mmu vm_iomap_memory() stub
>> 
> Confirmed. Patching this commit into 3.4 fixes the build for
> both blackbuid/defconfig and sh/defconfig.
>

It looks like this one could be applied to the 3.5 kernel as well (all
the others are already there).  Thanks, I'll queue it for the next
release.

Cheers,
-- 
Luis


>> > cris/...: In file included from include/linux/page-flags.h:8:0,
>> > from kernel/bounds.c:9: include/linux/types.h:25:1: error:
>> > unknown type name '__kernel_ino_t' include/linux/types.h:29:1:
>> > error: unknown type name '__kernel_off_t'
>> > include/linux/types.h:30:1: error: unknown type name
>> > '__kernel_pid_t' include/linux/types.h:31:1: error: unknown type
>> > name '__kernel_daddr_t' include/linux/types.h:33:1: error:
>> > unknown type name '__kernel_suseconds_t'
>> >
>> > That one might be tricky (or simple if someone knows what is wrong).
>> 
>> Fixed in v3.5-rc1:
>> 
>> commit 74f077d2a7651409c44bb323471f219a4b0d2aab
>> Author: Jiri Slaby <jslaby@suse.cz>
>> Date:   Mon Apr 2 13:40:17 2012 +0200
>> 
>>     cris: posix_types.h, include asm-generic/posix_types.h
>> 
> It does fix above error, but then there is another error:
>
>   AS      arch/cris/arch-v10/lib/checksum.o
> In file included from <command-line>:4:0:
> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> make[1]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
>   AS      arch/cris/arch-v10/lib/checksumcopy.o
> In file included from <command-line>:4:0:
> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> make[1]: *** [arch/cris/arch-v10/lib/checksumcopy.o] Error 1
>
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
