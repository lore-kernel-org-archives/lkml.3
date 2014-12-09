Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaLIKSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:18:46 -0500
Received: from ozlabs.org ([103.22.144.67]:56232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbaLIKSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:18:42 -0500
In-Reply-To: <20141208141629.912861A5D5B@localhost.localdomain>
To: LEROY Christophe <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com,
        aneesh.kumar@in.ibm.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc32: missing accessors to pgprot_t objects
Message-Id: <20141209101841.7D9241400D2@ozlabs.org>
Date: Tue,  9 Dec 2014 21:18:41 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-12 at 14:16:29 UTC, LEROY Christophe wrote:
> Compilation with #define STRICT_MM_TYPECHECKS in arch/powerpc/include/asm/page.h
> fails due to missing use of pgprot_val() when using pgprot_t objects.

Hmm, looks like 64 bit doesn't build either.

Aneesh I think you added this, mind fixing it up?

In file included from ../arch/powerpc/include/asm/thread_info.h:34:0,
                 from ../include/linux/thread_info.h:54,
                 from ../include/asm-generic/preempt.h:4,
                 from arch/powerpc/include/generated/asm/preempt.h:1,
                 from ../include/linux/preempt.h:18,
                 from ../include/linux/spinlock.h:50,
                 from ../include/linux/mmzone.h:7,
                 from ../include/linux/gfp.h:5,
                 from ../include/linux/mm.h:9,
                 from ../arch/powerpc/mm/tlb_hash64.c:25:
../arch/powerpc/mm/tlb_hash64.c: In function ‘__flush_hash_table_range’:
../arch/powerpc/include/asm/page.h:286:24: error: request for member ‘pte’ in something not a structure or union
 #define pte_val(x) ((x).pte)
                        ^    
../arch/powerpc/mm/tlb_hash64.c:219:37: note: in expansion of macro ‘pte_val’
    trace_hugepage_invalidate(start, pte_val(pte));
                                     ^    
make[2]: *** [arch/powerpc/mm/tlb_hash64.o] Error 1


cheers
