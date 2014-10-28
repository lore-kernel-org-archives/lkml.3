Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaJ1SA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:00:26 -0400
Received: from forward3l.mail.yandex.net ([84.201.143.136]:56411 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaJ1SAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:00:25 -0400
X-Yandex-Uniq: 57c83e68-c6f1-4784-ab71-f43319889694
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <544FD9B2.70108@yandex.ru>
Date: Tue, 28 Oct 2014 21:00:18 +0300
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
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com> <1414475091.8574.6.camel@tkhai> <20141028150102.GP3219@twins.programming.kicks-ass.net> <544FD8C6.5020606@yandex.ru>
In-Reply-To: <544FD8C6.5020606@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2014 20:56, Kirill Tkhai wrote:
> On 28.10.2014 18:01, Peter Zijlstra wrote:
>> On Tue, Oct 28, 2014 at 08:44:51AM +0300, Kirill Tkhai wrote:
>>> В Пн, 27/10/2014 в 20:54 +0100, Oleg Nesterov пишет:
>>
>>>> +#define probe_slab_address(addr, retval)	\
>>>> +	probe_kernel_address(addr, retval)
>>>
>>> probe_kernel_read() was arch-dependent on tree platforms:
>>>
>>> arch/blackfin/mm/maccess.c
>>> arch/parisc/lib/memcpy.c
>>> arch/um/kernel/maccess.c
>>>
>>> But now we skip these arch-dependent implementations. Is there no a problem?
>>
>> Nope, see the first patch, it makes probe_kernel_address use
>> __probe_kernel_read().
>>
> 
> Yes, probe_kernel_read() is in [1/3], but it's not the same as
> __probe_kernel_read() for blackfin, for example.

Vise versa, I mean __probe_kernel_read() is in [1/3].

> It's defined as
> 
> long __weak probe_kernel_read(void *dst, const void *src, size_t size)
>     __attribute__((alias("__probe_kernel_read")));
> 
> But blackfin's probe_kernel_read() redefines this __weak function,
> isn't it? Didn't get_freepointer_safe() use to call architecture's
> probe_kernel_read() before?
> 
> I don't see how it is called now...
> 
