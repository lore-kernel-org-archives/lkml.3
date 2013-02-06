Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3BFP4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:56:19 -0500
Received: from mail.candelatech.com ([208.74.158.172]:54468 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3BFP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:56:18 -0500
Message-ID: <51127D15.7080503@candelatech.com>
Date: Wed, 06 Feb 2013 07:56:05 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com>    <20130206015430.GA9161@home.goodmis.org>   <5111BF51.5010607@candelatech.com>   <1360119124.2621.37.camel@gandalf.local.home>   <5111CE60.4080403@candelatech.com>  <1360125419.2621.39.camel@gandalf.local.home>  <5111F6F6.7010402@candelatech.com> <1360156888.2621.42.camel@gandalf.local.home>
In-Reply-To: <1360156888.2621.42.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 05:21 AM, Steven Rostedt wrote:
> On Tue, 2013-02-05 at 22:23 -0800, Ben Greear wrote:
>> On 02/05/2013 08:36 PM, Steven Rostedt wrote:
>>> On Tue, 2013-02-05 at 19:30 -0800, Ben Greear wrote:
>>>
>>>> It's huge, so here's a link:
>>>>
>>>> http://www.candelatech.com/~greearb/debug.tgz
>>>>
>>>
>>> The trace shows that __netif_receive_skb() is grabbing an
>>> rcu_read_lock() but never releasing it. But I don't see any possible way
>>> that can be true in the code.
>>>
>>> Can you apply the following patch and run the trace again. I'd like to
>>> see if the code is going in the path I expect it is.
>>
>> I'll look at this in detail tomorrow.  I have a few patches in dev.c code, maybe
>> I merged something badly....
>
> I wish you told me that in the beginning. That you modified the core
> code. In that case I would have asked to see your modifications before
> anything else.
>
> I'm 99% sure that the bug is in your modifications.

I'm sorry, I tried to make that clear.

My tree is here, minus a few debugging patches related to this bug:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary

It's rebased on top of 3.7.6.

The wanlink module I'm using is outside the tree.  I recently decided to
release this as GPL, so ignore any conflicting copyright notices to
the contrary in the code:

http://www.candelatech.com/~greearb/wanlink.tgz

The wanlink module is a network impairment tool that acts like a 2-port
bridge.  In my current test case, I'm bridging about 300Mbps of traffic
across two ethernet ports.  It blows up immediately after starting the
emulation.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

