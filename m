Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3FMJAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:18 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:60794 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3FMJAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:16 -0400
Date: Thu, 13 Jun 2013 11:00:02 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, sanjayl@kymasys.com, kvm@vger.kernel.org,
        linux-mips@linux-mips.org,
        Markos Chandras <markos.chandras@imgtec.com>
Subject: Re: Commit f9afbd45b0d0 broke mips r4k.
Message-ID: <20130613090002.GD7422@linux-mips.org>
References: <1371090916.2776.104@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371090916.2776.104@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:35:16PM -0500, Rob Landley wrote:

> My aboriginal linux project builds tiny linux systems to run under
> qemu, producing as close to the same system as possible across a
> bunch of different architectures. The above change broke the mips
> r4k build I've been running under qemu.
> 
> Here's a toolchain and reproduction sequence:
> 
>   wget http://landley.net/aboriginal/bin/cross-compiler-mips.tar.bz2
>   tar xvjf cross-compiler-mips.tar.bz2
>   export PATH=$PWD/cross-compiler-mips/bin:$PATH
>   make ARCH=mips allnoconfig KCONFIG_ALLCONFIG=miniconfig.mips
>   make CROSS_COMPILE=mips- ARCH=mips
> 
> (The file miniconfig.mips is attached.)
> 
> It ends:
> 
>   CC      init/version.o
>   LD      init/built-in.o
> arch/mips/built-in.o: In function `local_r4k_flush_cache_page':
> c-r4k.c:(.text+0xe278): undefined reference to `kvm_local_flush_tlb_all'
> c-r4k.c:(.text+0xe278): relocation truncated to fit: R_MIPS_26
> against `kvm_local_flush_tlb_all'
> arch/mips/built-in.o: In function `local_flush_tlb_range':
> (.text+0xe938): undefined reference to `kvm_local_flush_tlb_all'
> arch/mips/built-in.o: In function `local_flush_tlb_range':
> (.text+0xe938): relocation truncated to fit: R_MIPS_26 against
> `kvm_local_flush_tlb_all'
> arch/mips/built-in.o: In function `local_flush_tlb_mm':
> (.text+0xed38): undefined reference to `kvm_local_flush_tlb_all'
> arch/mips/built-in.o: In function `local_flush_tlb_mm':
> (.text+0xed38): relocation truncated to fit: R_MIPS_26 against
> `kvm_local_flush_tlb_all'
> kernel/built-in.o: In function `__schedule':
> core.c:(.sched.text+0x16a0): undefined reference to
> `kvm_local_flush_tlb_all'
> core.c:(.sched.text+0x16a0): relocation truncated to fit: R_MIPS_26
> against `kvm_local_flush_tlb_all'
> mm/built-in.o: In function `use_mm':
> (.text+0x182c8): undefined reference to `kvm_local_flush_tlb_all'
> mm/built-in.o: In function `use_mm':
> (.text+0x182c8): relocation truncated to fit: R_MIPS_26 against
> `kvm_local_flush_tlb_all'
> fs/built-in.o:(.text+0x7b50): more undefined references to
> `kvm_local_flush_tlb_all' follow
> fs/built-in.o: In function `flush_old_exec':
> (.text+0x7b50): relocation truncated to fit: R_MIPS_26 against
> `kvm_local_flush_tlb_all'
> 
> Revert the above commit and it builds to the end.

Commit d414976d1ca721456f7b7c603a8699d117c2ec07 [MIPS: include:
mmu_context.h: Replace VIRTUALIZATION with KVM] fixes the issue and
was pulled by Linus only yesterday.  I cannot reproduce the error
following your receipe using the latest Linux/MIPS tree.

  Ralf
