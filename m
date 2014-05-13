Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaEMPc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:32:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:35755 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaEMPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:32:51 -0400
Date: Tue, 13 May 2014 17:33:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <20140513152429.GA15679@infradead.org>
Message-ID: <alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <20140513152429.GA15679@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Christoph Hellwig wrote:
> On Tue, May 13, 2014 at 04:57:36PM +0800, Ley Foon Tan wrote:
> > This patchset change default time_t and clock_t to 64 bit in
> > include/uapi/asm-generic/posix_types.h. The existing 32 bit architectures override
> > these define to 32 bit in arch posix_types.h.
> > 
> > There is request to support 64 bit time_t for new architecture [1]. According to the
> 
> I think this is an utterly wrong, and very dangerous approach.  A 64-bit
> time_t is something that will need non-trivial porting effort in
> userland, and introducing it only for new fringe architectures is a
> guaranteed way to create silent breakage.
> 
> If you do care about it make sure the architectures that are heavily
> used support it and userland can properly deal with it first, and only
> then default new architectures to it.

Err, we CANNOT do that. We cannot move ANY 32 bit architecture to
64bit time_t without breaking the world and some more.

All 64bit architectures use 64bit time_t already plus the x32 ABI of x86.

So why would user space explode? It did not explode with x32 and it
would be dumb as hell to have new archs use time_t 32bit when we are
currently twisting our brain around how to solve the y2038
problem. Simply because we can not do the BSD flag day approach and
change it.

User space needs to be audited anyway so there is nothing wrong if we
have a few more architectures aside of x32 using a 64bit time_t on a
32 bit machine.

Thanks,

	tglx




