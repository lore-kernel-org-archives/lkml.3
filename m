Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JWLLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:11:53 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58038 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3JWLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:11:52 -0400
Date: Wed, 23 Oct 2013 12:11:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead of
 static inline function for user_enter/exit()
Message-ID: <20131023111147.GB2502@localhost.localdomain>
References: <5267A72B.7060808@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267A72B.7060808@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 06:38:35PM +0800, Chen Gang wrote:
> The related assemble code can not find the static inline function. The
> related commit "ad65782 context_tracking: Optimize main APIs off case
> with static key" causes this issue.
> 
> The related error (for arm, with allmodconfig):
> 
>     LD      init/built-in.o
>   arch/arm/kernel/built-in.o: In function `ret_fast_syscall':
>   arch/arm/kernel/entry-common.S:42: undefined reference to `user_enter'
>   arch/arm/kernel/built-in.o: In function `no_work_pending':
>   arch/arm/kernel/entry-common.S:77: undefined reference to `user_enter'
>   arch/arm/kernel/built-in.o: In function `vector_swi':
>   arch/arm/kernel/entry-common.S:376: undefined reference to `user_exit'
>   arch/arm/kernel/built-in.o: In function `__dabt_usr':
>   arch/arm/kernel/entry-armv.S:365: undefined reference to `user_exit'
>   arch/arm/kernel/built-in.o: In function `__irq_usr':
>   arch/arm/kernel/entry-armv.S:375: undefined reference to `user_exit'
>   arch/arm/kernel/built-in.o: In function `__und_usr':
>   arch/arm/kernel/entry-armv.S:388: undefined reference to `user_exit'
>   arch/arm/kernel/built-in.o: In function `__pabt_usr':
>   arch/arm/kernel/entry-armv.S:662: undefined reference to `user_exit'
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Doesn't 0c06a5d4b13cd66c833805a0d1db76b977944aac
("arm: Fix build error with context tracking calls") fix the issue for you?
Or may be it's another problem I missed?

Thanks.
