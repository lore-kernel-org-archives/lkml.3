Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaEBS7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:59:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBS7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:59:48 -0400
Message-ID: <5363EB0E.4050202@zytor.com>
Date: Fri, 02 May 2014 11:59:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Clean up and unify the vDSO
References: <cover.1398377016.git.luto@amacapital.net>
In-Reply-To: <cover.1398377016.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:08 PM, Andy Lutomirski wrote:
> This rewrites a bunch of the vdso code.  After these patches, the vvar
> and hpet pages are mapped directly after the vdso text on all five vdso
> variants.  The fixmaps are gone on 64-bit systems.
> 
> It would be possible to build the x32 vdso the normal way on top of
> these patches.
> 
> I haven't touched the pvclock code.  I'd want to understand why it
> exists, why it isn't using rdtsc, and why it has two rdtsc_barrier calls
> before rearranging it.  In a discussion with Marcello Tosatti, I think
> we concluded that the kvmclock code could be significantly simplified
> and sped up without breaking anything, but I want to save that for
> later.
> 
> This should apply to -linus or to tip/x86/vdso.  It's also here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=vdso/cleanups
> 
> and it has survived the build bot for a day.
> 

Hello,

I get build errors building an allyesconfig on i386:

/home/hpa/kernel/distwork/arch/x86/vdso/vdso32-setup.c: In function
‘arch_vma_name’:
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32-setup.c:123:9: error:
dereferencing pointer to incomplete type
  if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
         ^
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32-setup.c:123:23: error:
dereferencing pointer to incomplete type
  if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
                       ^
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32-setup.c:123:46: error:
dereferencing pointer to incomplete type
  if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
                                              ^
  CHECK   /home/hpa/kernel/distwork/block/elevator.c
make[4]: *** [arch/x86/vdso/vdso32-setup.o] Error 1

	-hpa

