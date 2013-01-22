Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3AVNQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:16:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3AVNQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:16:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] making HAVE_SYSCALL_WRAPPERS universal (Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit)
Date: Tue, 22 Jan 2013 13:16:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Geoff Levand <geoff.levand@linaro.org>
References: <50F3D2F2.3080200@6wind.com> <20130121023010.GR4939@ZenIV.linux.org.uk> <20130121225517.GV4939@ZenIV.linux.org.uk>
In-Reply-To: <20130121225517.GV4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221316.22096.arnd@arndb.de>
X-Provags-ID: V02:K0:Hc1CY/bOGrOlX1K+7llNhpst/S6J0SjkPiU8xNYdS4X
 Ai5s0DHSe7Za9g3nlNiOXHqL4BeUxXLkAFZHO/lMUDWKlVefZi
 X42Z7JIDHx0JGfqUohp6GZjOVXmCMA2yCFYVylMO4qDxG3Cmjw
 55KNhjVvUTMRweJH55JxdkZTvXOUO+q8hEP64LUKPFy+x4l5fR
 dgGYREF/1P/4xpdDLkX/hA66oV3OhLVj7r7ZSvmh9V6xbELWfy
 MMdHEfLUTP200kVFvOqbyrrOGNNyq4Td8NXDMJfziHE/rLw5Nj
 BnLlaMYKW06Y4tWGXcLdzMxBX4yOz0w37/gKt19WxwhEgFQFME
 Cmah2LG6bdLx+sgr9Tr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Al Viro wrote:
> Another question: what's the following comment from spu_callbacks.c about?
>  * 4. They are optional and we can't rely on them being
>  *    linked into the kernel. Unfortunately, the cond_syscall
>  *    helper does not work here as it does not add the necessary
>  *    opd symbols:
>  *      mbind, mq_open, ipc, ...
> What isn't added?  sys_ni_syscall is an OPD entry and weak aliases for it
> are created.  That comment predates the conversion of cond_syscall()
> definition to the current one; it used to be
> .weak .foo
> .set .foo .sys_ni_syscall
> and that wouldn't have created the second alias; is it simply obsolete?

Yes, I think that is correct, it was fixed years ago when the old
toolchains that couldn's support it got deprecated, in

commit 8dc86ab954d28513f75918d743c40cddbff7388a
Author: Geoff Levand <geoffrey.levand@am.sony.com>
Date:   Mon Nov 20 18:44:56 2006 +0100

    [POWERPC] Change ppc_rtas declaration to weak
    
    Change the definition of powerpc's cond_syscall() to use the standard gcc
    weak attribute specifier which provides proper support for C linkage as
    needed by spu_syscall_table[].
    
    Fixes this powerpc build error with CONFIG_SPU_FS=y, CONFIG_PPC_RTAS=n:
    
     arch/powerpc/platforms/built-in.o: undefined reference to `ppc_rtas'

but we forgot enable the remaining ones.

> Note that mbind and friends still are not available to SPU; should that
> be changed now that we can do that?

We could certainly change it, if someone is willing to go through the
list and mark the ones that should be added. It's probably not necessary,
I have never seen any SPU application that actually did any but the most
basic syscalls itself.

	Arnd
