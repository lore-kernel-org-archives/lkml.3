Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3GSVgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:36:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:38649 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3GSVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:36:02 -0400
Message-ID: <51E9B13E.5060602@hp.com>
Date: Fri, 19 Jul 2013 17:35:58 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: JBeulich@novell.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <20130719211148.10251.qmail@science.horizon.com>
In-Reply-To: <20130719211148.10251.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 05:11 PM, George Spelvin wrote:
>> What I have in mind is to have 2 separate rwlock initializers - one for
>> fair and one for reader-bias behavior. So the lock owners can decide
>> what behavior do they want with a one line change.
> That's definitely a nicer patch, if it will work.  I was imagining that,
> even for a single (type of) lock, only a few uses require reader bias
> (because they might be recursive, or are in an interrupt), but you'd
> want most read_lock sites to be fair.

Yes, fair rwlock will be the default.

> Deciding on a per-lock basis means that one potentially recursive call
> means you can't use fair queueing anywhere.
>
> I was hoping that the number of necessary unfair calls would
> be small enough that making the read_lock default fair and
> only marking the unfair call sites would be enough.
>
> But I don't really know until doing a survey of the calls.
I think so. The queue read/write lock, if merged, will be an optional 
feature for people to try out to see if they see any problem in any of 
the existing rwlock. So far, I didn't encounter any problem in my testing.

BTW, I also tried my version of the rwlock without the waiting queue. In 
high contention case, it performs slightly better than the 
__read_lock_failed changes suggested by Ingo at least for the 
reader-bias one. It is still not as good as the full version with the 
waiting queue. I should be able to provide more performance data next week.

Regards,
Longman
