Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3F0TSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:18:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3F0TSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:18:08 -0400
Message-ID: <51CC8FEC.8030605@mit.edu>
Date: Thu, 27 Jun 2013 12:18:04 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: deadlock in scheduler enabling HRTICK feature
References: <51CA0622.8010105@gmail.com> <20130625211713.GA18796@laptop.programming.kicks-ass.net> <51CA0980.8010409@gmail.com> <20130626070533.GA3601@dyad.programming.kicks-ass.net> <51CB1AE9.5090709@gmail.com> <20130627104309.GQ28407@twins.programming.kicks-ass.net> <20130627105303.GD27378@dyad.programming.kicks-ass.net>
In-Reply-To: <20130627105303.GD27378@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:53 AM, Peter Zijlstra wrote:
> On Thu, Jun 27, 2013 at 12:43:09PM +0200, Peter Zijlstra wrote:
>> On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
>>> On 6/26/13 1:05 AM, Peter Zijlstra wrote:
>>>>> What is the expectation that the feature provides? not a whole lot of
>>>>> documentation on it. I walked down the path wondering if it solved an odd
>>>>> problem we are seeing with the CFS in 2.6.27 kernel.
>>>>
>>>> Its supposed to use hrtimers for slice expiry instead of the regular tick.
>>>
>>> So theoretically CPU bound tasks would get preempted sooner? That was my
>>> guess/hope anyways.
>>
>> Doth the below worketh?
>>
> 
> Related to all this; the reason its not enabled by default is that mucking
> about with hrtimers all the while is god awful expensive.
> 
> I've had ideas about making this a special purpose 'hard-coded' timer in the
> hrtimer guts that's only ever re-programmed when the new value is sooner.
> 
> By making it a 'special' timer we can avoid the whole rb-tree song and dance;
> and by taking 'spurious' short interrupts we can avoid prodding the hardware
> too often.

Supposedly, on really new x86 systems, the TSC deadline timer is so fast
to reprogram that this isn't worth it.

I wonder if the general timing code should have a way to indicate that a
given clockevent is (a) very fast and (b) is actually locked to a
clocksource as opposed to just having a vaguely accurately calibrated
frequency.

--Andy
