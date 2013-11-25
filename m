Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3KYSe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:34:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:43966 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab3KYSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:34:27 -0500
Message-ID: <5293980A.4030804@windriver.com>
Date: Mon, 25 Nov 2013 13:33:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
References: <1383798668.5441.25.camel@marge.simpson.net> <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de> <20131107125923.GB24644@localhost.localdomain> <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de> <1384243595.15180.63.camel@marge.simpson.net> <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de> <20131115163008.GB12164@linutronix.de> <20131115201436.GC12164@linutronix.de> <20131118141021.GA10022@twins.programming.kicks-ass.net> <20131122135931.GA8698@linutronix.de> <20131122160841.GS3866@twins.programming.kicks-ass.net>
In-Reply-To: <20131122160841.GS3866@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-11-22 11:08 AM, Peter Zijlstra wrote:
> On Fri, Nov 22, 2013 at 02:59:31PM +0100, Sebastian Andrzej Siewior wrote:
>> +extern void __lockfunc rt_spin_try_unlock(spinlock_t *lock);
> 
> I know what you mean, but.. try_unlock() just sounds wrong, how can we
> attempt but fail to unlock a lock we hold ;-)

rt-v3.10-devel$git grep -l tryunlock
tasklet-rt-prevent-tasklets-from-going-into-infinite-spin-in-rt.patch
rt-v3.10-devel$

> 
> 
> /me crawls back under his rock ;-)

Can you take tasklets with you?   ;-)
