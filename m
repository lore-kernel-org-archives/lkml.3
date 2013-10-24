Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3JXP3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:29:40 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:62416 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3JXP3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <5268B0B1.9050009@asianux.com>
References: <523FD9E7.3050303@asianux.com>
	<523FDBD7.4040602@asianux.com>
	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
	<523FE578.5060801@asianux.com>
	<52672DAC.1030307@asianux.com>
	<CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>
	<52673E41.6040606@asianux.com>
	<5267AF98.1010800@asianux.com>
	<5268B0B1.9050009@asianux.com>
Date: Thu, 24 Oct 2013 08:29:37 -0700
X-Google-Sender-Auth: TYCdYoHfqEa_Zr_J-KPPpY6P1F8
Message-ID: <CA+5PVA6N0c_ych96bC0nPw=hSqFtO-zhFFHzPW96yK8k=Z3fPg@mail.gmail.com>
Subject: Re: [PATCH] kernel/modsign_certificate.S: use real contents instead
 of macro GLOBAL()
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:31 PM, Chen Gang <gang.chen@asianux.com> wrote:
> For some architectures, tool chain is not smart enough to recognize the
> macro with multiple lines (e.g. arc tool chain), and for common ".S"
> file, this kind of macro is also rarely used.
>
> So expand the related contents of macro to let it pass compiling (can
> use "arc-elf32-objdump -x" to know about it).
>
> The related error (allmodconfig for arc):
>
>     LD      init/built-in.o
>   kernel/built-in.o: In function `load_module_signing_keys':
>   kernel/modsign_pubkey.c:66: undefined reference to `modsign_certificate_list'
>   kernel/modsign_pubkey.c:71: undefined reference to `modsign_certificate_list_end'
>   kernel/modsign_pubkey.c:67: undefined reference to `modsign_certificate_list_end'
>
> The related tool chain information:
>
>   [root@gchenlinux linux-next]# arc-elf32-as -v
>   GNU assembler version 2.23.2 (arc-elf32) using BFD version (GNU Binutils) 2.23.2
>   [root@gchenlinux linux-next]# arc-elf32-ld -v
>   GNU ld (GNU Binutils) 2.23.2
>   [root@gchenlinux linux-next]# arc-elf32-gcc -v
>   Using built-in specs.
>   COLLECT_GCC=arc-elf32-gcc
>   COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/arc-elf32/4.8.0/lto-wrapper
>   Target: arc-elf32
>   Configured with: ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 --disable-multilib --with-headers=../newlib/newlib/libc/include
>   Thread model: single
>   gcc version 4.8.0 (GCC)

Is this only an issue with using multi-line macro definitions in .S
files?  The practice of using multi-line macro definitions isn't rare.
 Look at e.g. include/linux/module.h, and a number of other header
files.

This seems like a toolchain bug that should be fixable if it works for
other architectures.

josh
