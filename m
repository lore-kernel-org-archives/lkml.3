Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3JWLcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:32:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28375 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3JWLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:32:09 -0400
X-Spam-Score: -100.8
Message-ID: <5267B378.4090502@asianux.com>
Date: Wed, 23 Oct 2013 19:31:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead
 of static inline function for user_enter/exit()
References: <5267A72B.7060808@asianux.com>  <1382525244.5283.3.camel@pippen.local.home> <5267AC7C.2040803@asianux.com> <1382526910.5283.5.camel@pippen.local.home>
In-Reply-To: <1382526910.5283.5.camel@pippen.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 07:15 PM, Steven Rostedt wrote:
> On Wed, 2013-10-23 at 19:01 +0800, Chen Gang wrote:
> 
>>> void arch_user_enter(void)
>>> {
>>> 	user_enter();
>>> }
>>>
>>
>> OK, thanks. That sounds reasonable to me. I will send related patch to
>> arm guys. :-)
> 
> If you do so, don't call it "arch_user_enter()", maybe call it
> "asm_user_enter()", as "arch_*" is something used to be called by the
> generic code.  My mistake in using that as an example.
> 

Oh, yes, what you said is an example, I need reference it, but should
not depend on it.

Hmm... for me "asm_user_enter" seems still a little 'generic' (e.g.
"asm-generic", "arch/*/include/asm/"), maybe just use common extern
functions' name is enough (e.g. "wrap_user_enter").

But all together, I feel your original fix patch is well enough to me,
it seems don't need additional trying.  :-)

> -- Steve
> 
> 
> 
> 

Thanks.
-- 
Chen Gang
