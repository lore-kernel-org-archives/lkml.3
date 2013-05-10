Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3EJTqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:46:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:47237 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3EJTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:46:12 -0400
Message-ID: <518D4E5B.10804@infradead.org>
Date: Fri, 10 May 2013 12:45:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: SyS symbol munging.
References: <20130510192417.GA4915@redhat.com> <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
In-Reply-To: <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/13 12:35, Andrew Morton wrote:
> On Fri, 10 May 2013 15:24:17 -0400 Dave Jones <davej@redhat.com> wrote:
> 
>> On Fri, May 10, 2013 at 12:14:54PM -0700, Andrew Morton wrote:
>>
>>  > [  163.953629] Call Trace:
>>  > [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
>>  > [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
>>  > [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
>>  > [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
>>  > [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
>>  > [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
>>  > [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
>>  
>> This has been bugging me for a while.
>> What's changing sys_shmget to SyS_shmget in that trace ? And why ?
>>
> 
> nm vmlinux | grep SyS
> 
> That's the actual name of the function definition which the C compiler
> sees.  It's emitted by SYSCALL_DEFINE, cooked up by all the macro goop
> in include/linux/syscalls.h.
> 
> I forget who did this initially and peeling back those layers with git
> is tiresome.
> --

$ git blame include/linux/syscalls.h | grep SyS | more
07fe6e00 (Al Viro                  2013-01-21 15:03:44 -0500 189) 	asmlinka
ge long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
6c597963 (Heiko Carstens           2009-02-11 13:04:38 -0800 196) 	SYSCALL_
ALIAS(sys##name, SyS##name);


Those 2 commits explain (to some degree) what the patches do, but not why "SyS".


-- 
~Randy
