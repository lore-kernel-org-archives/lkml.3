Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3KNBQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:16:25 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:48571 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889Ab3KNBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:16:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,-10,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:1801:1981:2194:2199:2376:2393:2525:2553:2561:2564:2682:2685:2691:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3770:3865:3866:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4043:4321:4605:5007:6119:6248:7266:7652:7903:7974:9025:9121:9388:10004:10848:11026:11232:11233:11473:11657:11658:11914:12043:12295:12296:12379:12438:12517:12519:12555:12663:12740:13160:13229:13870,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none
X-HE-Tag: war89_70edf8a52ad25
X-Filterd-Recvd-Size: 5586
Message-ID: <1384391774.32748.22.camel@joe-AO722>
Subject: Re: [PATCH V3] printk/cache: Mark printk_once test variable
 __read_mostly
From: Joe Perches <joe@perches.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-metag@vger.kernel.org
Date: Wed, 13 Nov 2013 17:16:14 -0800
In-Reply-To: <CA+8MBbJKN174=ybMNE7Z+oT7KjNBzgdy9cvhb_kACvXAbTo9XA@mail.gmail.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	 <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
	 <1383244173.8740.9.camel@joe-AO722>
	 <CA+8MBb+rrAWSTTvO4cx32ju-QOAG6aHHxR9B=sLtGXR3q8DF0A@mail.gmail.com>
	 <1384302563.3665.28.camel@joe-AO722>
	 <CA+8MBbJKN174=ybMNE7Z+oT7KjNBzgdy9cvhb_kACvXAbTo9XA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-13 at 11:31 -0800, Tony Luck wrote:
> On Tue, Nov 12, 2013 at 4:29 PM, Joe Perches <joe@perches.com> wrote:
> > try this:
> >
> > https://lkml.org/lkml/2013/10/30/604
> >
> >
> 
> How is that any different from what is in linux-next?  It still
> has the same change to cache.h that reduces the nested
> #includes that currently make the build work.
> 
> -#include <linux/kernel.h>
> +#include <uapi/linux/kernel.h>
> 
> -Tony

I believe you were cc'd on this email as
a reply to a kbuild test robot report:

I don't have an ia64 cross compiler here but
my presumption is this fixes the problem.

I believe Andrew has picked it up for his mm
series which is haphazardly merged into -next.

-----------

On Thu, 2013-11-07 at 10:54 +0800, kbuild test robot wrote:
> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   7610384ab26340452f06d673c46624927c3901b6
> commit: 7231446cc53d71e126acf3d0230239a6b3ad52bf [169/450] printk/cache: Mark printk_once test variable __read_mostly
> config: make ARCH=ia64 alldefconfig
> 
> All error/warnings:

Hello Fengguang.

>    In file included from arch/ia64/kernel/patch.c:12:0:
>    arch/ia64/include/asm/processor.h: In function 'ia64_get_irr':
> >> arch/ia64/include/asm/processor.h:565:2: error: implicit declaration of function 'test_bit' [-Werror=implicit-function-declaration]

I'm a bit confused how the change I made could cause this error.

Is this an existing warning that's now an error because
bitops.h isn't explicitly #included in processor.h?

(possible fix below)

>    In file included from include/linux/bitops.h:22:0,
>                     from include/linux/kernel.h:10,
>                     from include/asm-generic/bug.h:13,
>                     from arch/ia64/include/asm/bug.h:12,
>                     from include/linux/bug.h:4,
>                     from include/linux/thread_info.h:11,
>                     from include/linux/preempt.h:9,
>                     from include/linux/uaccess.h:4,
>                     from arch/ia64/include/asm/sections.h:10,
>                     from arch/ia64/kernel/patch.c:13:
>    arch/ia64/include/asm/bitops.h: At top level:
> >> arch/ia64/include/asm/bitops.h:339:1: error: static declaration of 'test_bit' follows non-static declaration
>    arch/ia64/include/asm/processor.h:565:9: note: previous implicit declaration of 'test_bit' was here
>    cc1: some warnings being treated as errors
> 
> vim +/test_bit +565 arch/ia64/include/asm/processor.h
> 
>    549        #define cpu_relax()     ia64_hint(ia64_hint_pause)
>    550        
>    551        static inline int
>    552        ia64_get_irr(unsigned int vector)
>    553        {
>    554                unsigned int reg = vector / 64;
>    555                unsigned int bit = vector % 64;
>    556                u64 irr;
>    557        
>    558                switch (reg) {
>    559                case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;
>    560                case 1: irr = ia64_getreg(_IA64_REG_CR_IRR1); break;
>    561                case 2: irr = ia64_getreg(_IA64_REG_CR_IRR2); break;
>    562                case 3: irr = ia64_getreg(_IA64_REG_CR_IRR3); break;
>    563                }
>    564        
>  > 565                return test_bit(bit, &irr);
>    566        }
>    567        
>    568        static inline void
>    569        ia64_set_lrr0 (unsigned long val)
>    570        {
>    571                ia64_setreg(_IA64_REG_CR_LRR0, val);
>    572                ia64_srlz_d();
>    573        }
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

Maybe this fixes it?
---
 arch/ia64/include/asm/processor.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 5a84b3a..efd1b92 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -71,6 +71,7 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>


