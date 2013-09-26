Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3IZQnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:43:43 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49103 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3IZQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 26 Sep 2013 09:43:38 -0700
X-Google-Sender-Auth: DPH7eTmoyRtbZ8-W4yT51vg8s68
Message-ID: <CA+55aFxwAJLBoZtxwRr=S2GJLvBhcvu7zV3f1TJ+Amasx7bPZw@mail.gmail.com>
Subject: Re: [PATCH 0/8] softirq: Consolidation and stack overrun fix v3
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
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 9:24 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> * Turn __ARCH_IRQ_EXIT_ON_IRQ_STACK old ad-hoc style symbol to proper Kconfig
> (CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK)
>
> * Activates it to powerpc as well.
>
> * Fix a bit the changelog of patch 6/8


Ack on the whole series.

I guess x86-64 and powerpc no longer care, but for other architectures
the stack usage issue can be a regression even if I think it's only
been reported on Power. So I'm assuming we should pull this into 3.12.
Yes?

And what about earlier stable kernels? Afaik this was originally
introduced by commit facd8b80c67a, merged into 3.9. Or was there some
other trigger? Do we want to just do the "__do_softirq" ->
"do_softirq()" change for stable?

"Help us, Obi-wan Weisbecker. You are our only hope"

                Linus
