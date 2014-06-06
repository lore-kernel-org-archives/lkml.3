Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaFFSMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:12:44 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:1209 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaFFSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:12:43 -0400
Message-ID: <1402078358.14433.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Fri, 06 Jun 2014 11:12:38 -0700
In-Reply-To: <1402074788.6680.50.camel@j-VirtualBox>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-2-git-send-email-davidlohr@hp.com>
	 <1402074788.6680.50.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 10:13 -0700, Jason Low wrote:
> On Fri, 2014-06-06 at 08:55 -0700, Davidlohr Bueso wrote:
> > Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
> > encapsulate the dependencies for rwsem optimistic spinning.
> > No logical changes here as it continues to depend on both
> > SMP and the XADD algorithm variant.
> > 
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  include/linux/rwsem.h  | 4 ++--
> >  kernel/Kconfig.locks   | 4 ++++
> >  kernel/locking/rwsem.c | 2 +-
> >  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> Do we also want to add an #ifdef CONFIG_RWSEM_SPIN_ON_OWNER in
> __init_rwsem() and in the optimistic spinning functions for rwsem-xadd?
> 

Not really, as we conditionally build rwsem-xadd.o based on
CONFIG_RWSEM_XCHGADD_ALGORITHM:

obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o

So leaving just SMP is ok there.

> 
> Besides that:
> 
> Acked-by: Jason Low <jason.low2@hp.com>
> 

Thanks,
Davidlohr

