Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab3EXDUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:20:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30259 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3EXDUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:20:04 -0400
Message-ID: <519EDBD1.1020508@huawei.com>
Date: Fri, 24 May 2013 11:17:37 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ktap 0.1 released
References: <519AF05E.1050808@huawei.com> <y0m8v38jj62.fsf@fche.csb>
In-Reply-To: <y0m8v38jj62.fsf@fche.csb>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 2:13, Frank Ch. Eigler wrote:
> "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> writes:
> 
>> I'm pleased to announce that ktap release v0.1, this is the first official
>> release of ktap project [...]
> 
> Congrats.
> 
> 
>> = what's ktap?
>>
>>    Because this is the first release, so there wouldn't include too
>>    much features, just contain several basic features about tracing,
>>    [...]
> 
> Nice progress.  Reviewing the safety/security items from
> https://lkml.org/lkml/2013/1/17/623, I see improvement in most.
Thanks, frank, you give me a lot of helpful technical comments in that RFC mail,
also as this one :) really thanks.
> 
> For example, you seem to be using GFP_ATOMIC for run-time memory
> allocation, which is safer than before (though still could exhaust
> resources).  OTOH your code doesn't handle *failure* of such
> allocation attempts (see call sites to kp_*alloc).
Yes, memory allocation would be change to be more safer.
> 
> There still doesn't seem to be safety constraints on the incoming
> byte code (like jump ranges, or loop counts).
> 
> It's nice to see some arithmetic OP_* checks, and the user_string
> function is probably safe enough now.  You'll need something analogous
> for kernel space (and possibly as verification for the various %s
> kp_printfs).  The hash tables might be susceptible to the deliberate
> hash collision attacks from last year.
Current hashtable implementation is efficient, but need have more
security concern as you pointed.
> 
> It's nice to see the *_STACK_SIZE constraints in the bytecode
> interpreter; is there any C-level recursion remaining to consume
> excessive kernel stack?
library C functions should not be a problem, like other kernel functions,
author should take care on stack overflow in own risk.
> 
> Exposing os.sleep/os.wait (or general kernel functions) to become
> callable from the scripts is fraught with danger.  You just can't call
> the underlying functions from random kernel context (imagine from the
> most pessimal possible kprobe or tracepoint, somewhere within an
> atomic section), and you'll get crashes.
Right, so those functions only can be called from mainthread,
I will add these checking later.

> 
> You should write several time/space/invasivity stress-tests to help
> see how future progress improves the code's performance/safety on
> these and other problem areas.
Yes, there already have a test/ directory for basic functionality testing,
obviously it's not enough, I will add more benchmark and safety checking testcases.
> 
> 
>> = Planned Changes
>>
>>    we are planning to enable more kernel ineroperability into ktap [...]
> 
> As per the above, you'll want to be extremely careful about the idea
> to export FFI to let the lua scripts call into arbitrary kernel
> functions.  Perhaps wrap it into a 'guru' mode flag?
Definitely, there must need a mode flag to separate safety and not-safety.
> 
> 
> - FChE
> 
> .
> 


