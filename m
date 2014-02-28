Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaB1Pln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:41:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53215 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbaB1Plm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:41:42 -0500
Date: Fri, 28 Feb 2014 15:41:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkuo@codeaurora.org" <rkuo@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "paulus@samba.org" <paulus@samba.org>
Subject: Re: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only accessed
 via atomic_long_*
Message-ID: <20140228154121.GC29546@mudshark.cambridge.arm.com>
References: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
 <1393478904.3884.6.camel@buesod1.americas.hpqcorp.net>
 <20140228121314.GC674@mudshark.cambridge.arm.com>
 <531085FE.2050902@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531085FE.2050902@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:50:06PM +0000, Peter Hurley wrote:
> On 02/28/2014 07:13 AM, Will Deacon wrote:
> > diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> > index 603a0a11e592..2b6401f9e428 100644
> > --- a/include/asm-generic/rwsem.h
> > +++ b/include/asm-generic/rwsem.h
> > @@ -40,14 +40,16 @@ static inline void __down_read(struct rw_semaphore *sem)
> >   static inline int __down_read_trylock(struct rw_semaphore *sem)
> >   {
> >          long tmp;
> > +       atomic_long_t *cnt = (atomic_long_t *)&sem->count;
> 
> The shared rwsem failure paths (kernel/locking/rwsem_xadd.c) peek at
> sem->count as long type, so this isn't really necessary.

Yeah, none of this patch is necessary from a technical perspective. I was
just in the area and tried to make the file at least self-consistent wrt the
atomic API. It's a harmless cleanup.

Will
