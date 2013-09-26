Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3IZHMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:12:17 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49035 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3IZHMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:12:15 -0400
Date: Thu, 26 Sep 2013 09:12:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/7] irq: Optimize softirq stack selection in irq exit
Message-ID: <20130926071204.GA18570@localhost.localdomain>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
 <1380125886-10341-7-git-send-email-fweisbec@gmail.com>
 <CA+55aFxDk9_cmo4SPYMgG_WQ+_g5e_v6O-HEtQ_nTs-q1zjykg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxDk9_cmo4SPYMgG_WQ+_g5e_v6O-HEtQ_nTs-q1zjykg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:04:28PM -0700, Linus Torvalds wrote:
> On Wed, Sep 25, 2013 at 9:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > +#ifdef __ARCH_IRQ_EXIT_ON_IRQ_STACK
> 
> Please don't introduce anymore of these insane ad-hoc crazy architecture macros.
> 
> Just make it a regular config option, which makes it much easier for
> architectures to just select it at config time.
> 
> So make it something like CONFIG_IRQ_EXIT_ON_IRQ_STACK, and then
> x86-64 (and now Power) can just do
> 
>     select IRQ_EXIT_ON_IRQ_STACK
> 
> in their arch/*/Kconfig files.
> 
> Basically, we really should strive to get rid of all those insane
> [__]ARCH_xyzzy flags. We have too many of them, and they are insane.

Ok, I'll convert that and x86,powerpc along.

Thanks.

> 
>               Linus
