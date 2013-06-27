Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3F0W3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:29:02 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60563 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3F0W3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:29:01 -0400
Message-ID: <51CCBCA9.1000200@gmail.com>
Date: Thu, 27 Jun 2013 16:28:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
References: <51CA0622.8010105@gmail.com> <20130625211713.GA18796@laptop.programming.kicks-ass.net> <51CA0980.8010409@gmail.com> <20130626070533.GA3601@dyad.programming.kicks-ass.net> <51CB1AE9.5090709@gmail.com> <20130627104309.GQ28407@twins.programming.kicks-ass.net>
In-Reply-To: <20130627104309.GQ28407@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/13 4:43 AM, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
>> On 6/26/13 1:05 AM, Peter Zijlstra wrote:
>>>> What is the expectation that the feature provides? not a whole lot of
>>>> documentation on it. I walked down the path wondering if it solved an odd
>>>> problem we are seeing with the CFS in 2.6.27 kernel.
>>>
>>> Its supposed to use hrtimers for slice expiry instead of the regular tick.
>>
>> So theoretically CPU bound tasks would get preempted sooner? That was my
>> guess/hope anyways.
>
> Doth the below worketh?

It doth.

Usually make -j 8 for a kernel build in a VM would lock it up pretty 
quickly. With the patch I was able to run full builds multiple times.

As for the solution you are avoiding the nesting by not waking up the 
softirq daemon.

I'll backport to 2.6.27 and see what happens. Thanks for the patch.

David

