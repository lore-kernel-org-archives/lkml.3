Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaEMTOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:14:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:37584 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEMTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:14:04 -0400
Date: Tue, 13 May 2014 21:14:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <20140513174640.GA20961@infradead.org>
Message-ID: <alpine.DEB.2.02.1405132111120.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <20140513152429.GA15679@infradead.org> <alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de> <20140513174640.GA20961@infradead.org>
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

> On Tue, May 13, 2014 at 05:33:01PM +0200, Thomas Gleixner wrote:
> > Err, we CANNOT do that. We cannot move ANY 32 bit architecture to
> > 64bit time_t without breaking the world and some more.
> 
> Of course we can, we just need to still provide the existing 32-bit
> time_t ABIs for backwards compatiblity.  That's how we handled
> extensions of other types like off_t in the past.

Sorry, misunderstood you there.

Sure, I agree that we need to fix it anyway plus all timespec/timeval
usage sites. It's on my and John Stultz radar as well. Just the sheer
amount of syscalls, ioctls etc. makes one shudder.

Thanks,

	tglx
