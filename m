Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab3GZUYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:24:23 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47369 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3GZUYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:24:21 -0400
Date: Fri, 26 Jul 2013 22:24:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130726202418.GD21415@gmail.com>
References: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com>
 <51F1ED8F.40703@zytor.com>
 <20130726083314.4e2e333f@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726083314.4e2e333f@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 25 Jul 2013 20:31:27 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 07/25/2013 07:14 PM, Jesse Barnes wrote:
> > > To clarify: it'll either be marked reserved or not listed at all in e820, which is why I did this early, before any other e820 stuff like the "RAM buffer" are allocated, and before we could use the iomem resource (or maybe we could even early per Linus? I'll check). 
> > > 
> > > Jesse
> > 
> > If it is marked reserved or not listed at all it is much less of an
> > issue.  Reserved is in fact the correct thing; not listed at all really
> > isn't very problematic in most cases.
> 
> Yeah the problems seem to fall into two categories:
>   1) mmio space is allocated in this range:
>      https://bugs.freedesktop.org/show_bug.cgi?id=66726
>   2) range gets partially allocated to the "RAM buffer"
>      https://bugs.freedesktop.org/show_bug.cgi?id=66844
> 
> Case (1) is the one that worries me.  I'm guessing it'll mainly be a
> problem on machines where MMIO space is limited or somehow structured
> such that PCI resources end up there when we allocate them.  Depending
> on what gets put there and the decode priority, behavior may be poor.
> 
> Case (2) isn't harmful, but ends up causing our driver to skip stolen
> memory initialization, because of the conflict.
> 
> Anyway I'll look at Linus's suggestion of reserving in the iomem
> resource really early and roll in Chris's stuff if that doesn't work
> out.

Am I being too pedantic in expecting that we still mark it 
e820-reserved?

This area really isnt an ordinary PCI resource such as a 
BAR or an MMIO region. It's truly system RAM (which cannot 
be moved/reallocated), used by graphics hardware, and the 
firmware should have marked it reserved.

(The end result should be the same in any case, so this is 
a detail.)

Thanks,

	Ingo
