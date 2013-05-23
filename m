Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3EWBBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:01:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60419 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3EWBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:01:36 -0400
X-Spam-Score: -100.8
Message-ID: <519D6A3D.5050003@asianux.com>
Date: Thu, 23 May 2013 09:00:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] kernel/sched/core.c: need return NULL when BUG() is defined
 as empty.
References: <5199D565.4070307@asianux.com> <20130522091156.GC18810@twins.programming.kicks-ass.net> <20130522133317.GC18614@n2100.arm.linux.org.uk> <20130522161935.GR18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522161935.GR18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 12:19 AM, Peter Zijlstra wrote:
> On Wed, May 22, 2013 at 02:33:17PM +0100, Russell King - ARM Linux wrote:
>> > On Wed, May 22, 2013 at 11:11:56AM +0200, Peter Zijlstra wrote:
>>> > > On Mon, May 20, 2013 at 03:48:53PM +0800, Chen Gang wrote:
>>>> > > > 
>>>> > > > When neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, need let function
>>>> > > > return failure value ('NULL') instead of random value.
>>> > > 
>>> > > What will such a kernel do? Happily continue running whenever we hit a
>>> > > BUG? that seems like a particularly bad idea. Should we not have a stub
>>> > > BUG() function like:
>>> > > 
>>> > > void BUG(void) __attribute__((noreturn))
>>> > > {
>>> > > 	local_irq_disable();
>>> > > 	while (1) ;
>>> > > }
>> > 
>> > Eww.  So you've a platform where you have things like panic_on_oops
>> > enabled, and you hit this bug... do we really want to just stop?
>> > Wouldn't replacing BUG() with panic("BUG"); be better ?
>> > 
>> > But, this begs the question - what is the point of being able to turn
>> > off BUG() ?  As BUG() on any sensible architecture is implemented by
>> > placing the minimum of code at the callsite (eg, one instruction if
>> > not using verbose) anything like the above is likely to be bigger.
>> > 
>> > So, I'd actually argue that rather than trying to "fix" this, get rid
>> > of CONFIG_BUG and make it always enabled everywhere - just like what
>> > has recently been done with hotplug.
> Works for me. 
> 

Thanks all, I should send the related patch for it.

Excuse me, I have to do another things, so I will finish it within this
week (2013-05-26)

Welcome any additional suggestions and completions.


Thanks.
-- 
Chen Gang

Asianux Corporation
