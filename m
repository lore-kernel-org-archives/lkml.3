Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3EJO5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:57:49 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49056 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3EJO5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <518CCBB2.5010308@cn.fujitsu.com>
References: <518CB758.4000101@cn.fujitsu.com>
	<CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com>
	<518CCBB2.5010308@cn.fujitsu.com>
Date: Fri, 10 May 2013 07:57:47 -0700
X-Google-Sender-Auth: _1UmiTeX27sfQl7lUfzJ6qp6FTA
Message-ID: <CAE9FiQWcKAJ0DP833urozcECkZNpbCks_vLVBf8UhaXTRSEWzA@mail.gmail.com>
Subject: Re: [PATCH] x86: mm: Remove unnecessary assignment for max_pfn_mapped:q
From: Yinghai Lu <yinghai@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 3:28 AM, Zhang Yanfei
<zhangyanfei@cn.fujitsu.com> wrote:
> 于 2013年05月10日 17:27, Yinghai Lu 写道:
>> On Fri, May 10, 2013 at 2:01 AM, Zhang Yanfei
>> <zhangyanfei@cn.fujitsu.com> wrote:
>>> init_memory_mapping will set max_pfn_mapped:
>>> int_memory_mapping
>>>   --> add_pfn_range_mapped
>>>     --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)
>>>
>>> In init_mem_mapping, before we set max_pfn_mapped to 0, we
>>> have already called init_memory_mapping to setup pagetable
>>> for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
>>> the assignment to 0 is not necessary, remove it.
>>
>> NAK.
>>
>> for 32bit or Xen, max_pfn_mapped is set way before in head_32.S and
>> xen-enlighen.
>
> Hi Yinghai
>
> I might be wrong, but just from the code in init_mem_mapping only:
>
>  410         /* the ISA range is always mapped regardless of memory holes */
>  411         init_memory_mapping(0, ISA_END_ADDRESS);
>  412
>  413         /* xen has big range in reserved near end of ram, skip it at first.*/
>  414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
>  415         real_end = addr + PMD_SIZE;
>  416
>  417         /* step_size need to be small so pgt_buf from BRK could cover it */
>  418         step_size = PMD_SIZE;
>  419         max_pfn_mapped = 0; /* will get exact value next */
>
> Line 411 set max_pfn_mapped, and then line 419 set it to zero again, so
> why keep the later assignment?

the comment says: /* will get exact value next */

For x86 32bit path, and xen set bigger max_pfn_mapped before.

Yinghai
