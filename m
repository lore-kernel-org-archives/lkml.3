Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaA2Iqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:46:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:56707 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaA2Iqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:46:51 -0500
Message-ID: <1390985190.8524.54.camel@pasglop>
Subject: Re: compile error on linus git with ppc64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 19:46:30 +1100
In-Reply-To: <alpine.DEB.2.02.1401281953040.32278@chino.kir.corp.google.com>
References: <20140128194311.00004303@unknown>
	 <alpine.DEB.2.02.1401281953040.32278@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 19:59 -0800, David Rientjes wrote:
> On Tue, 28 Jan 2014, Jesse Brandeburg wrote:


I have a fix queued up in next, I'll ask Linus to pull tomorrow.

Ben.

> > fresh pull, commit d891ea23d5203e5c47439b2a174f86a00b356a6c - merge
> > ceph-client.
> > 
> > I get a compile error:
> > jbrandeb@jbrandeb-pseries:~/git/linux> make -j12
> > scripts/kconfig/conf --silentoldconfig Kconfig
> >   CHK     include/config/kernel.release
> >   WRAP    arch/powerpc/include/generated/asm/clkdev.h
> >   WRAP    arch/powerpc/include/generated/asm/rwsem.h
> >   WRAP    arch/powerpc/include/generated/asm/trace_clock.h
> >   WRAP    arch/powerpc/include/generated/asm/preempt.h
> >   WRAP    arch/powerpc/include/generated/asm/hash.h
> >   WRAP    arch/powerpc/include/generated/asm/vtime.h
> >   CHK     include/generated/uapi/linux/version.h
> >   UPD     include/generated/uapi/linux/version.h
> >   HOSTCC  scripts/dtc/checks.o
> >   HOSTCC  scripts/dtc/data.o
> >   SHIPPED scripts/dtc/dtc-lexer.lex.c
> >   SHIPPED scripts/dtc/dtc-parser.tab.h
> >   HOSTCC  scripts/kallsyms
> >   HOSTCC  scripts/genksyms/genksyms.o
> >   CC      scripts/mod/empty.o
> >   HOSTCC  scripts/mod/mk_elfconfig
> >   CC      scripts/mod/devicetable-offsets.s
> >   SHIPPED scripts/dtc/dtc-parser.tab.c
> >   HOSTCC  scripts/dtc/dtc.o
> >   SHIPPED scripts/genksyms/lex.lex.c
> >   SHIPPED scripts/genksyms/keywords.hash.c
> >   HOSTCC  scripts/pnmtologo
> >   SHIPPED scripts/genksyms/parse.tab.h
> >   SHIPPED scripts/genksyms/parse.tab.c
> >   HOSTCC  scripts/dtc/flattree.o
> >   HOSTCC  scripts/dtc/fstree.o
> >   HOSTCC  scripts/genksyms/lex.lex.o
> >   HOSTCC  scripts/genksyms/parse.tab.o
> >   HOSTCC  scripts/dtc/livetree.o
> >   HOSTCC  scripts/dtc/srcpos.o
> >   HOSTCC  scripts/dtc/treesource.o
> >   HOSTCC  scripts/conmakehash
> >   HOSTCC  scripts/bin2c
> >   MKELF   scripts/mod/elfconfig.h
> >   HOSTCC  scripts/dtc/util.o
> >   HOSTCC  scripts/mod/modpost.o
> >   HOSTCC  scripts/mod/sumversion.o
> >   HOSTCC  scripts/dtc/dtc-lexer.lex.o
> >   HOSTLD  scripts/genksyms/genksyms
> >   HOSTCC  scripts/dtc/dtc-parser.tab.o
> >   GEN     scripts/mod/devicetable-offsets.h
> >   HOSTCC  scripts/mod/file2alias.o
> >   HOSTLD  scripts/dtc/dtc
> >   HOSTLD  scripts/mod/modpost
> >   UPD     include/config/kernel.release
> >   CHK     include/generated/utsrelease.h
> >   UPD     include/generated/utsrelease.h
> >   CC      kernel/bounds.s
> >   GEN     include/generated/bounds.h
> >   CC      arch/powerpc/kernel/asm-offsets.s
> > In file included from include/linux/spinlock.h:81,
> >                  from include/linux/seqlock.h:35,
> >                  from include/linux/time.h:5,
> >                  from include/uapi/linux/timex.h:56,
> >                  from include/linux/timex.h:56,
> >                  from include/linux/sched.h:17,
> >                  from arch/powerpc/kernel/asm-offsets.c:17:
> > include/linux/spinlock_types.h:76: error: redefinition of typedef
> > ‘spinlock_t’ /home/jbrandeb/git/linux/arch/powerpc/include/asm/pgtable-ppc64.h:563:
> > error: previous declaration of ‘spinlock_t’ was here
> 
> Confirmed, I saw this with ppc64_defconfig.  It's due to b3084f4db3ae 
> ("powerpc/thp: Fix crash on mremap").
> 
> 
> powerpc, spinlock: fix build error
> 
> Build fails with
> 
> include/linux/spinlock_types.h:76: error: redefinition of typedef ‘spinlock_t’ 
> arch/powerpc/include/asm/pgtable-ppc64.h:563: error: previous declaration of ‘spinlock_t’ was here
> 
> due to commit b3084f4db3ae ("powerpc/thp: Fix crash on mremap").  Remove 
> the bogus typedef and include spinlock_types.h.
> 
> Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/powerpc/include/asm/pgtable-ppc64.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
> --- a/arch/powerpc/include/asm/pgtable-ppc64.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc64.h
> @@ -365,6 +365,8 @@ void pgtable_cache_init(void);
>  			 _PAGE_THP_HUGE)
>  
>  #ifndef __ASSEMBLY__
> +#include <linux/spinlock_types.h>
> +
>  /*
>   * The linux hugepage PMD now include the pmd entries followed by the address
>   * to the stashed pgtable_t. The stashed pgtable_t contains the hpte bits.
> @@ -560,7 +562,6 @@ extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>  			    pmd_t *pmdp);
>  
>  #define pmd_move_must_withdraw pmd_move_must_withdraw
> -typedef struct spinlock spinlock_t;
>  static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
>  					 spinlock_t *old_pmd_ptl)
>  {


