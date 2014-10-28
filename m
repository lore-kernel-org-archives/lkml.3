Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaJ1PBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:01:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaJ1PBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:09 -0400
Date: Tue, 28 Oct 2014 16:01:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
Message-ID: <20141028150102.GP3219@twins.programming.kicks-ass.net>
References: <1413962231.19914.130.camel@tkhai>
 <20141027195339.GA11736@redhat.com>
 <20141027195425.GC11736@redhat.com>
 <1414475091.8574.6.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414475091.8574.6.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 08:44:51AM +0300, Kirill Tkhai wrote:
> В Пн, 27/10/2014 в 20:54 +0100, Oleg Nesterov пишет:

> > +#define probe_slab_address(addr, retval)	\
> > +	probe_kernel_address(addr, retval)
> 
> probe_kernel_read() was arch-dependent on tree platforms:
> 
> arch/blackfin/mm/maccess.c
> arch/parisc/lib/memcpy.c
> arch/um/kernel/maccess.c
> 
> But now we skip these arch-dependent implementations. Is there no a problem?

Nope, see the first patch, it makes probe_kernel_address use
__probe_kernel_read().
