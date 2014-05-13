Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaEMRqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:46:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaEMRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:46:42 -0400
Date: Tue, 13 May 2014 10:46:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Message-ID: <20140513174640.GA20961@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <20140513152429.GA15679@infradead.org>
 <alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:33:01PM +0200, Thomas Gleixner wrote:
> Err, we CANNOT do that. We cannot move ANY 32 bit architecture to
> 64bit time_t without breaking the world and some more.

Of course we can, we just need to still provide the existing 32-bit
time_t ABIs for backwards compatiblity.  That's how we handled
extensions of other types like off_t in the past.

> All 64bit architectures use 64bit time_t already plus the x32 ABI of x86.

64-bit is not relevant for the pain as there time_t is simply a long,
while for 32-bit types we move to a longer than pointer sized type,
in direct contradiction to older standards the explicitly prohibit this.

> So why would user space explode? It did not explode with x32

Who knows?  It's not like x32 actually has any significant user base.
In fact just weeks ago we fixed fundamental type system bugs for it.

> and it
> would be dumb as hell to have new archs use time_t 32bit when we are
> currently twisting our brain around how to solve the y2038
> problem. Simply because we can not do the BSD flag day approach and
> change it.

I don't think it's a good idea to have minor new architectures
pointlessly different than the major ones.  Especially given that we'll
absolutely have to fir the y2038 problem for 32-bit arm and probably
x86 anyway.

