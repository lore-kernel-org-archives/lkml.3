Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3BFCTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:19:44 -0500
Received: from mail.candelatech.com ([208.74.158.172]:47075 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BFCTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:19:42 -0500
Message-ID: <5111BD28.50407@candelatech.com>
Date: Tue, 05 Feb 2013 18:17:12 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com> <20130206015430.GA9161@home.goodmis.org>
In-Reply-To: <20130206015430.GA9161@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:54 PM, Steven Rostedt wrote:

> I'm not sure the swapper task is part of the 'do_each_thread()' loop.
>
> Perhaps what you want to do is add a:
>
> 	lockdep_print_held_locks(current);

I'll add that and test...

> I'm curious. Does your code grab a read lock? If you grab the same read
> lock multiple times it adds to the list each time. Thus if you have
> anything like:
>
> 	for (i = 0; i < 100; i++ ) {
> 		read_lock(&lock);
> 	}
>
> 	for (i = 0; i < 100; i++) {
> 		read_unlock(&lock);
> 	}
>
> That will fill up the held locks quite a bit.
>
> The above code I showed is ridiculous and I doubt you have it, but if
> you have something that does lots of recursive reads for some reason,
> that could be an issue.

I have only one read/write lock in my module, and it looks like
I always lock it as a writer (will fix that soon for performance
reasons, but it should be valid locking I think).

I have no rcu locks at all in my module currently.

I've seen similar lockups on another machine that does not use
this module, but it uses a hacked up pktgen.  I haven't found
a test case that reproduces this on a clean upstream build,
but I am still fairly suspicious that it isn't my code.
Famous last words I'm sure :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

