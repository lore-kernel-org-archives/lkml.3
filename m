Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaJ1S71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaJ1S7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:59:25 -0400
Date: Tue, 28 Oct 2014 20:55:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
Message-ID: <20141028195542.GA1352@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com> <1414475091.8574.6.camel@tkhai> <20141028150102.GP3219@twins.programming.kicks-ass.net> <544FD8C6.5020606@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FD8C6.5020606@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Kirill Tkhai wrote:
>
> Yes, probe_kernel_read() is in [1/3], but it's not the same as
> __probe_kernel_read() for blackfin, for example.
>
> It's defined as
>
> long __weak probe_kernel_read(void *dst, const void *src, size_t size)
>     __attribute__((alias("__probe_kernel_read")));
>
> But blackfin's probe_kernel_read() redefines this __weak function,
> isn't it? Didn't get_freepointer_safe() use to call architecture's
> probe_kernel_read() before?

I _think_ that __probe_kernel_read(slab_ddr) should be fine.

Yes, an architecture may want to reimplement probe_kernel_read() to
allow to safely access the special areas, or special addresses.

But again, in this case we know that this address points to the
"normal" kernel memory, __copy_from_user_inatomic() should work fine.

Oleg.

