Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaJ2FKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:10:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:60733 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaJ2FKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:10:35 -0400
Message-ID: <1414559432.8574.15.camel@tkhai>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Vladimir Davydov" <vdavydov@parallels.com>,
        Christoph Lameter <cl@linux.com>
Date: Wed, 29 Oct 2014 08:10:32 +0300
In-Reply-To: <20141028201221.GA2106@redhat.com>
References: <1413962231.19914.130.camel@tkhai>
	 <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com>
	 <1414475091.8574.6.camel@tkhai>
	 <20141028150102.GP3219@twins.programming.kicks-ass.net>
	 <544FD8C6.5020606@yandex.ru> <20141028195542.GA1352@redhat.com>
	 <20141028201221.GA2106@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 28/10/2014 в 21:12 +0100, Oleg Nesterov пишет:
> On 10/28, Oleg Nesterov wrote:
> >
> > On 10/28, Kirill Tkhai wrote:
> > >
> > > Yes, probe_kernel_read() is in [1/3], but it's not the same as
> > > __probe_kernel_read() for blackfin, for example.
> > >
> > > It's defined as
> > >
> > > long __weak probe_kernel_read(void *dst, const void *src, size_t size)
> > >     __attribute__((alias("__probe_kernel_read")));
> > >
> > > But blackfin's probe_kernel_read() redefines this __weak function,
> > > isn't it? Didn't get_freepointer_safe() use to call architecture's
> > > probe_kernel_read() before?
> >
> > I _think_ that __probe_kernel_read(slab_ddr) should be fine.
> >
> > Yes, an architecture may want to reimplement probe_kernel_read() to
> > allow to safely access the special areas, or special addresses.
> >
> > But again, in this case we know that this address points to the
> > "normal" kernel memory, __copy_from_user_inatomic() should work fine.
> 
> OTOH, perhaps probe_kernel_address() should use probe_kernel_read(), not
> __probe_kernel_read(). But currently it just calls __copy_inatomic() so
> 1/3 follows this logic.

Ok, thanks for the explanation, Oleg.

