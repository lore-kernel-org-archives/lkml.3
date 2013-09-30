Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3I3LMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:12:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50304 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3I3LMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:12:46 -0400
Date: Mon, 30 Sep 2013 13:12:42 +0200
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
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 0/8] softirq: Consolidation and stack overrun fix v3
Message-ID: <20130930111239.GA21494@localhost.localdomain>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFxwAJLBoZtxwRr=S2GJLvBhcvu7zV3f1TJ+Amasx7bPZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwAJLBoZtxwRr=S2GJLvBhcvu7zV3f1TJ+Amasx7bPZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 09:43:38AM -0700, Linus Torvalds wrote:
> On Thu, Sep 26, 2013 at 9:24 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > * Turn __ARCH_IRQ_EXIT_ON_IRQ_STACK old ad-hoc style symbol to proper Kconfig
> > (CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK)
> >
> > * Activates it to powerpc as well.
> >
> > * Fix a bit the changelog of patch 6/8
> 
> 
> Ack on the whole series.
> 
> I guess x86-64 and powerpc no longer care, but for other architectures
> the stack usage issue can be a regression even if I think it's only
> been reported on Power. So I'm assuming we should pull this into 3.12.
> Yes?
> 
> And what about earlier stable kernels? Afaik this was originally
> introduced by commit facd8b80c67a, merged into 3.9. Or was there some
> other trigger? Do we want to just do the "__do_softirq" ->
> "do_softirq()" change for stable?
> 
> "Help us, Obi-wan Weisbecker. You are our only hope"

Ok, I'm going to split that in two pull requests for Ingo and Thomas.
One for the 1st patch as a regression fix to be applied for 3.12 and backported.
Another one for the rest of the series to be applied on the next merge window.

If anybody oppose, please tell.

Thanks.
