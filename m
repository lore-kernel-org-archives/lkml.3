Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3IYXIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:08:25 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:37548 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3IYXIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <1380125886-10341-8-git-send-email-fweisbec@gmail.com>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	<1380125886-10341-8-git-send-email-fweisbec@gmail.com>
Date: Wed, 25 Sep 2013 16:08:20 -0700
X-Google-Sender-Auth: NUOzO8oSqhVVmySmnBwMeY60F9A
Message-ID: <CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
Subject: Re: [PATCH 7/7] x86: Tell about irq stack coverage
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 9:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> +#ifdef CONFIG_X86_64
> +# define __ARCH_IRQ_EXIT_ON_IRQ_STACK
> +#endif

Ok, see the previous email, this should just be a single

    select IRQ_EXIT_ON_IRQ_STACK

in under the "config X86_64" header in arch/x86/Kconfig.

And as of right now, this patch series should do it for Power too,
since I just merged Ben's branch, which contained commit 0366a1c70b89
("powerpc/irq: Run softirqs off the top of the irq stack"). Again,
just a single select in the arch/powerpc/Kconfig gile should be
sufficient.

                     Linus
