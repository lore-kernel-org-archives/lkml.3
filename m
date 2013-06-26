Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3FZQqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:46:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49978 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab3FZQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:46:44 -0400
Message-ID: <51CB1AE9.5090709@gmail.com>
Date: Wed, 26 Jun 2013 10:46:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
References: <51CA0622.8010105@gmail.com> <20130625211713.GA18796@laptop.programming.kicks-ass.net> <51CA0980.8010409@gmail.com> <20130626070533.GA3601@dyad.programming.kicks-ass.net>
In-Reply-To: <20130626070533.GA3601@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 1:05 AM, Peter Zijlstra wrote:
>> What is the expectation that the feature provides? not a whole lot of
>> documentation on it. I walked down the path wondering if it solved an odd
>> problem we are seeing with the CFS in 2.6.27 kernel.
>
> Its supposed to use hrtimers for slice expiry instead of the regular tick.

So theoretically CPU bound tasks would get preempted sooner? That was my 
guess/hope anyways.

>
> IIRC it did work at some point but bitrotted a bit since. The good news is that
> the deadline scheduler wants to use it and I'll probably have to fix it up
> then.

Hmmm.... meaning I should not be expecting anything in the next couple 
of months? Any gut opinions on how to approach the nested problem - at 
least a quick hack for me to see if this option has any impact on our 
problem? eg., a CPU variable noting we already have the runqueue lock 
and no need to grab it a second time.

David
