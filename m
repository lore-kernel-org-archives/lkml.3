Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3KVRpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:45:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:46484 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3KVRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:44:59 -0500
Message-ID: <528F9815.3030208@linutronix.de>
Date: Fri, 22 Nov 2013 18:44:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
References: <1383798668.5441.25.camel@marge.simpson.net> <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de> <20131107125923.GB24644@localhost.localdomain> <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de> <1384243595.15180.63.camel@marge.simpson.net> <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de> <20131115163008.GB12164@linutronix.de> <20131115201436.GC12164@linutronix.de> <20131118141021.GA10022@twins.programming.kicks-ass.net> <20131122135931.GA8698@linutronix.de> <20131122160841.GS3866@twins.programming.kicks-ass.net> <528F846E.4000703@linutronix.de>
In-Reply-To: <528F846E.4000703@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:21 PM, Sebastian Andrzej Siewior wrote:
> On 11/22/2013 05:08 PM, Peter Zijlstra wrote:
>> On Fri, Nov 22, 2013 at 02:59:31PM +0100, Sebastian Andrzej Siewior wrote:
>>> +extern void __lockfunc rt_spin_try_unlock(spinlock_t *lock);
>>
>> I know what you mean, but.. try_unlock() just sounds wrong, how can we
>> attempt but fail to unlock a lock we hold ;-)

kernel BUG at kernel/rtmutex.c:850!
[<ffffffff815ee9d5>] rt_spin_try_unlock+0x25/0x30
[<ffffffff81091ccd>] get_next_timer_interrupt+0xdd/0x270

It depends how hard you try :P Bah.

Sebastian
