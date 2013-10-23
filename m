Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3JWLUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:20:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:27569 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3JWLUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:20:47 -0400
X-Spam-Score: -100.8
Message-ID: <5267B0C9.3000402@asianux.com>
Date: Wed, 23 Oct 2013 19:19:37 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead
 of static inline function for user_enter/exit()
References: <5267A72B.7060808@asianux.com> <20131023111147.GB2502@localhost.localdomain>
In-Reply-To: <20131023111147.GB2502@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 07:11 PM, Frederic Weisbecker wrote:
> On Wed, Oct 23, 2013 at 06:38:35PM +0800, Chen Gang wrote:
>> The related assemble code can not find the static inline function. The
>> related commit "ad65782 context_tracking: Optimize main APIs off case
>> with static key" causes this issue.
>>
>> The related error (for arm, with allmodconfig):
>>
>>     LD      init/built-in.o
>>   arch/arm/kernel/built-in.o: In function `ret_fast_syscall':
>>   arch/arm/kernel/entry-common.S:42: undefined reference to `user_enter'
>>   arch/arm/kernel/built-in.o: In function `no_work_pending':
>>   arch/arm/kernel/entry-common.S:77: undefined reference to `user_enter'
>>   arch/arm/kernel/built-in.o: In function `vector_swi':
>>   arch/arm/kernel/entry-common.S:376: undefined reference to `user_exit'
>>   arch/arm/kernel/built-in.o: In function `__dabt_usr':
>>   arch/arm/kernel/entry-armv.S:365: undefined reference to `user_exit'
>>   arch/arm/kernel/built-in.o: In function `__irq_usr':
>>   arch/arm/kernel/entry-armv.S:375: undefined reference to `user_exit'
>>   arch/arm/kernel/built-in.o: In function `__und_usr':
>>   arch/arm/kernel/entry-armv.S:388: undefined reference to `user_exit'
>>   arch/arm/kernel/built-in.o: In function `__pabt_usr':
>>   arch/arm/kernel/entry-armv.S:662: undefined reference to `user_exit'
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Doesn't 0c06a5d4b13cd66c833805a0d1db76b977944aac
> ("arm: Fix build error with context tracking calls") fix the issue for you?
> Or may be it's another problem I missed?
> 

Oh, yes it is, it is my fault, I still use original next-20130927 tree
(I really need reference another next tree or torvalds tree).  :-)

Next, I will/should reference another next tree, at least.

Thanks again.

> Thanks.
> 
> 

-- 
Chen Gang
