Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaLUN5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 08:57:42 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34310 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaLUN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 08:57:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141221205604.5a280c9d@canb.auug.org.au>
References: <1419094041-14536-1-git-send-email-bobby.prani@gmail.com> <20141221205604.5a280c9d@canb.auug.org.au>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 21 Dec 2014 08:57:10 -0500
Message-ID: <CAJhHMCCnS6cEuATp-jScDpAjv7fgMm_v=gu650gE=UNK7GupQA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Wire up sys_execveat() syscall
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 4:56 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Pranith,
>
> On Sat, 20 Dec 2014 11:47:18 -0500 Pranith Kumar <bobby.prani@gmail.com> wrote:
>>
>> Wire up sys_execveat(). This passes the selftests for the system call.
>
> Thanks for this, but ...
>
>> diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
>> index ce9577d..778844a 100644
>> --- a/arch/powerpc/include/asm/systbl.h
>> +++ b/arch/powerpc/include/asm/systbl.h
>> @@ -366,3 +366,4 @@ SYSCALL_SPU(seccomp)
>>  SYSCALL_SPU(getrandom)
>>  SYSCALL_SPU(memfd_create)
>>  SYSCALL_SPU(bpf)
>> +SYSCALL_SPU(execveat)
>
> Given that it passes pointers into the kernel and looking at the execve
> system call, I assume that it should be COMPAT_SYS().
>

Yes, you are right. I will send in an updated patch. Thanks!
-- 
Pranith
