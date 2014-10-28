Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaJ1R3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:29:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:51388 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ1R3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:29:18 -0400
Date: Tue, 28 Oct 2014 18:29:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Minfei Huang <mnfhuang@gmail.com>, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid overlap the fixmap area on i386
In-Reply-To: <544FD138.3030305@zytor.com>
Message-ID: <alpine.DEB.2.11.1410281828340.5308@nanos>
References: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com> <alpine.DEB.2.11.1410281159590.5308@nanos> <544FD138.3030305@zytor.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, H. Peter Anvin wrote:
> On 10/28/2014 04:06 AM, Thomas Gleixner wrote:
> >>
> >> The available address we can use is lower than FIXADDR_BOOT_START. So
> >> We will set the kmap boundary below the FIXADDR_BOOT_START, if configure
> >> the high memory.
> >>
> >> If we configure the high memory, the vmalloc reserve area should end
> >> up to PKMAP_BASE, otherwise should end up to FIXADDR_BOOT_START.
> > 
> > Which is not really a problem, because the FIXADDR_BOOT area is only
> > used during boot for early_ioremap() and it's unused when ioremap() is
> > functional. vmalloc becomes available after early boot so the
> > FIXADDR_BOOT area is available for reuse.
> > 
> 
> Given the very limited address space available on i386, it would be
> extremely undesirable to not reuse address space when possible.

Fair enough. Then we should do that for the highmem=y case as well.

Thanks,

	tglx
