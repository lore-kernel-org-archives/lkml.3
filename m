Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaJVUYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbaJVUYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:24:08 -0400
Date: Wed, 22 Oct 2014 22:20:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, cl@linux.com, tkhai@yandex.ru, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, vdavydov@parallels.com
Subject: Re: introduce probe_slab_address?
Message-ID: <20141022202027.GA13781@redhat.com>
References: <20141022181412.GA8159@redhat.com> <20141022.145950.1585224138048242923.davem@davemloft.net> <20141022194228.GA10995@redhat.com> <20141022.160845.1338578429923954456.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022.160845.1338578429923954456.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, David Miller wrote:
>
> From: Oleg Nesterov <oleg@redhat.com>
> Date: Wed, 22 Oct 2014 21:42:28 +0200
>
> > Now the question: is this LOAD is safe in case when this (freed) page
> > already has another mapping? This is black magic to me, I do not know.
> > And Peter has some concerns.
>
> It is immatieral, because you can read garbage and it's "don't care"
> in this context.
>
> And later if it is used again at this virtual address, it will be
> initialized with stores at that virtual address first.
>
> So no problem.

Great, thanks.

> > And, say, copy_from_user_page() on sparc does
> >
> > 	flush_cache_page();
> > 	memcpy();
> > 	flush_ptrace_access();
>
> In this case, as I tried to explain, it matters because the physical
> address is being accessed from two virtual address at the same time
> "for the same usage".
>
> That's what distinguishes this from the SLAB and RCU cases you cite.

Yes, this was my (vague) understanding, but thanks for another
explanation anyway.

Oleg.

