Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaJ1R4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:56:33 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:53277 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaJ1R4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:56:32 -0400
X-Yandex-Uniq: 74c3ac73-7b67-454e-b371-5479ddf77a1a
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <544FD8C6.5020606@yandex.ru>
Date: Tue, 28 Oct 2014 20:56:22 +0300
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Icedove/33.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com> <1414475091.8574.6.camel@tkhai> <20141028150102.GP3219@twins.programming.kicks-ass.net>
In-Reply-To: <20141028150102.GP3219@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2014 18:01, Peter Zijlstra wrote:
> On Tue, Oct 28, 2014 at 08:44:51AM +0300, Kirill Tkhai wrote:
>> В Пн, 27/10/2014 в 20:54 +0100, Oleg Nesterov пишет:
> 
>>> +#define probe_slab_address(addr, retval)	\
>>> +	probe_kernel_address(addr, retval)
>>
>> probe_kernel_read() was arch-dependent on tree platforms:
>>
>> arch/blackfin/mm/maccess.c
>> arch/parisc/lib/memcpy.c
>> arch/um/kernel/maccess.c
>>
>> But now we skip these arch-dependent implementations. Is there no a problem?
>
> Nope, see the first patch, it makes probe_kernel_address use
> __probe_kernel_read().
> 

Yes, probe_kernel_read() is in [1/3], but it's not the same as
__probe_kernel_read() for blackfin, for example.

It's defined as

long __weak probe_kernel_read(void *dst, const void *src, size_t size)
    __attribute__((alias("__probe_kernel_read")));

But blackfin's probe_kernel_read() redefines this __weak function,
isn't it? Didn't get_freepointer_safe() use to call architecture's
probe_kernel_read() before?

I don't see how it is called now...
