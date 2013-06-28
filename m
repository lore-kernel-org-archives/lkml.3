Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3F1Uxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3F1Uxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:53:37 -0400
Message-ID: <51CDF7BB.4070604@redhat.com>
Date: Fri, 28 Jun 2013 16:53:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] mutex: do not unnecessarily deal with waiters
References: <1369353543.1770.0.camel@buesod1.americas.hpqcorp.net>  <20130627090016.GA4398@gmail.com>  <1372383138.2072.42.camel@buesod1.americas.hpqcorp.net>  <51CD24E1.2030608@canonical.com> <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 04:13 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
>
> Upon entering the slowpath, we immediately attempt to acquire the lock
> by checking if it is already unlocked. If we are lucky enough that this
> is the case, then we don't need to deal with any waiter related logic.
>
> Furthermore any checks for an empty wait_list are unnecessary as we
> already know that count is non-negative and hence no one is waiting for
> the lock.
>
> Move the count check and xchg calls to be done before any waiters are
> setup - including waiter debugging. Upon failure to acquire the lock,
> the xchg sets the counter to 0, instead of -1 as it was originally.
> This can be done here since we set it back to -1 right at the beginning
> of the loop so other waiters are woken up when the lock is released.
>
> When tested on a 8-socket (80 core) system against a vanilla 3.10-rc1
> kernel, this patch provides some small performance benefits (+2-6%).
> While it could be considered in the noise level, the average percentages
> were stable across multiple runs and no performance regressions were seen.
> Two big winners, for small amounts of users (10-100), were the short and
> compute workloads had a +19.36% and +%15.76% in jobs per minute.
>
> Also change some break statements to 'goto slowpath', which IMO makes a
> little more intuitive to read.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
