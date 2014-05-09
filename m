Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaEIGVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:21:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58766 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaEIGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:21:42 -0400
Message-ID: <536C73EF.7010907@hitachi.com>
Date: Fri, 09 May 2014 15:21:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <20140506121211.GA4125@treble.redhat.com> <20140506140516.GF2099@localhost.localdomain> <20140506145010.GA6702@treble.redhat.com> <20140507122444.GB12234@gmail.com> <20140507154114.GA31555@treble.redhat.com> <20140507155754.GA15221@gmail.com> <alpine.DEB.2.02.1405071552520.5876@nftneq.ynat.uz> <20140508061220.GB31184@gmail.com> <alpine.DEB.2.02.1405072348580.17457@nftneq.ynat.uz> <20140508070814.GA31856@gmail.com> <20140508124816.GA23565@treble.redhat.com>
In-Reply-To: <20140508124816.GA23565@treble.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/08 21:48), Josh Poimboeuf wrote:
>> No, I was not demanding that at all, my suggestion was:
>>
>>    > My claim is that if a patch is correct/safe in the old fashioned 
>>    > way, then a fundamental principle is that a live patching 
>>    > subsystem must either safely apply, or safely reject the live 
>>    > patching attempt, independently from any user input.
>>
>> Note the 'if'. It could start simple and stupid, and only allow cases 
>> where we know the patch must be trivially safe (because it does not do 
>> much in terms of disturbing globally visible state). That needs some 
>> tooling help, but apparently tooling help is in place already.
>>
>> And then we can complicate it from there - but have a reasonably 
>> robust starting point that we _know_ works (as long as the 
>> implementation is correct).
> 
> I really wonder if detecting a "trivially safe" patch is even possible.
> 
> Where do you draw the line with the following patches?
> 
> - add a call to another function which modifies global data

This depends on what global data and how. For example, the global data
is used only from the replaced functions, it's a kind of local data.
And also, the global data modification is as designed (e.g. acquiring/
releasing a spinlock), that is also safe.

I think, the bad case is modifying shared global data to new state which
unexpected by other data holders.

> - add an early return or a goto which changes the way the function
>   modifies (or no longer modifies) global data

Ditto, if it is unexpected at other parts, that will be unacceptable.

> - touch a local stack variable which results in global data being
>   modified later in the function
> 
> - return a different value which causes the function's caller to modify
>   data

I think if the local variable or return value change is correctly handled
by the caller (as expected), that is good too.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


