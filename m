Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaKQVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:02:32 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58043 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaKQVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141117135854.GA15076@gmail.com>
References: <20141116090743.GA19172@gmail.com>
	<20141117074247.GB340@x4>
	<20141117082724.GA344@x4>
	<20141117135854.GA15076@gmail.com>
Date: Mon, 17 Nov 2014 13:02:30 -0800
X-Google-Sender-Auth: YxjPzP7oxscNBqJ22iVUaJjVK0g
Message-ID: <CAGXu5j+mHoKpb2aNyxZWEWCOLRS=QeJXZxjU7YHDVcM3uuXZUQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Junjie Mao <eternal.n08@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 5:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
>
>> On 2014.11.17 at 08:42 +0100, Markus Trippelsdorf wrote:
>> > On 2014.11.16 at 10:07 +0100, Ingo Molnar wrote:
>> > >
>> > > Junjie Mao (1):
>> > >       x86, kaslr: Prevent .bss from overlaping initrd
>> >
>> > This breaks the build for me:
>> > ...
>> >   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>> >   HOSTCC  arch/x86/boot/compressed/mkpiggy
>> >   CC      arch/x86/boot/compressed/cpuflags.o
>> >   CC      arch/x86/boot/version.o
>> >   CC      arch/x86/boot/video-vga.o
>> >   CC      arch/x86/boot/video-vesa.o
>> >   CC      arch/x86/boot/video-bios.o
>> >   LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
>> >   HOSTCC  arch/x86/boot/tools/build
>> >   CPUSTR  arch/x86/boot/cpustr.h
>> >   CC      arch/x86/boot/cpu.o
>> > .bss and .brk lack common file offset
>> > .bss and .brk lack common file offset
>> > .bss and .brk lack common file offset
>> > .bss and .brk lack common file offset
>> >   MKPIGGY arch/x86/boot/compressed/piggy.S
>> > Usage: arch/x86/boot/compressed/mkpiggy compressed_file run_size
>> > arch/x86/boot/compressed/Makefile:86: recipe for target 'arch/x86/boot/compressed/piggy.S' failed
>
> Oops ...
>
>> from my config:
>> # CONFIG_BLK_DEV_INITRD is not set
>>
>> So only running calc_run_size.pl when CONFIG_BLK_DEV_INITRD is set would
>> probably fix the issue.
>
> I've Cc:-ed Junjie Mao and Kees Cook as well.

Eek, well, the warning worked, at least (".bss and .brk lack common
file offset") since that was kind of an assumption in the script I
wanted to make sure we'd catch if it wasn't true.

Can you send your full .config? I built without CONFIG_BLK_DEV_INITRD,
and it didn't fail, so something else must be tickling this...

Sorry for the glitch!

-Kees

>
> Thanks,
>
>         Ingo



-- 
Kees Cook
Chrome OS Security
