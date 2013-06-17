Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3FQU7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:59:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3FQU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:59:21 -0400
Date: Mon, 17 Jun 2013 13:59:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
Message-Id: <20130617135920.587959a34da85d7940a6936f@linux-foundation.org>
In-Reply-To: <51BF7610.10803@caviumnetworks.com>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
	<CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
	<CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
	<20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
	<51BF7610.10803@caviumnetworks.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 13:48:16 -0700 David Daney <ddaney@caviumnetworks.com> wrote:

> On 06/17/2013 01:30 PM, Andrew Morton wrote:
> [...]
> >
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro
> >
> > f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
> > on_each_cpu()") converted on_each_cpu() to a C function.  This required
> > inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
> > header ordering hell.
> >
> > Switch on_each_cpu() back to a macro to fix this.
> 
> FYI:  I have already sent a pair of patches that fix the include 
> dependencies:
> 
> https://lkml.org/lkml/2013/6/16/113
> https://lkml.org/lkml/2013/6/17/422

I wasn't cc'ed.

> Obviously, it is Linus' choice as to how best to handle the failure, but 
> I think it is important to know that there are two options (fixing ia64 
> and mn10300, or reverting the patch).

I certainly prefer the inline function over a crappy macro.  The
additional nested include is regrettable - more complexity.

Also, it's good to have the SMP and non-SMP versions either both using
macros or both using C.  Having them different can cause irritating
unused-variable compilation warnings when using the macro version.

I think switch-back-to-a-macro is simplest and safest for now.  Perhaps
you can queue a 3.11 patch which restores the C function and fixes up
mn10300 and ia64?

