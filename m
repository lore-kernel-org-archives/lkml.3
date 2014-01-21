Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaAUPCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:02:14 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23826 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaAUPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:02:11 -0500
Message-ID: <52DE8BEE.4040303@hp.com>
Date: Tue, 21 Jan 2014 10:02:06 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <20140115205346.GF10038@linux.vnet.ibm.com> <20140115232134.GM31570@twins.programming.kicks-ass.net> <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com> <20140116103659.GO7572@laptop.programming.kicks-ass.net> <20140118100105.GV10038@linux.vnet.ibm.com> <20140118113406.GY30183@twins.programming.kicks-ass.net> <20140118122548.GX10038@linux.vnet.ibm.com> <20140118124136.GZ30183@twins.programming.kicks-ass.net> <20140118212227.GA10038@linux.vnet.ibm.com> <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com> <20140119080405.GB10038@linux.vnet.ibm.com>
In-Reply-To: <20140119080405.GB10038@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2014 03:04 AM, Paul E. McKenney wrote:
> On Sat, Jan 18, 2014 at 04:57:05PM -0800, Linus Torvalds wrote:
>> On Sat, Jan 18, 2014 at 1:22 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com>  wrote:
>>> Yes, this requires that -all- updates to the fields in the machine word
>>> in question use atomic rmw.  Which would not be pretty from a core-code
>>> perspective.  Hence my suggestion of ceasing Linux-kernel support for
>>> DEC Alpha CPUs that don't support byte operations.  Also need 16-bit
>>> operations as well, of course...
>> I'm not seeing this.
>>
>> Why the hell would you have byte- or halfword-sized versions of the
>> store_release or load_acquire things on alpha anyway?
>>
>> What it means is that data structures that do locking or atomics need
>> to be "int" or "long" on alpha.  That has always been true. What do
>> you claim has changed?
> OK, another approach would be to never add "select ARCH_USE_QUEUE_RWLOCK"
> on Alpha, at least if the queued rwlocks really do want to atomically
> manipulate bytes.  After all, the Alpha systems that I know about don't
> have enough CPUs to make queued rwlocks necessary anyway.
>
> Much simpler solution!
>
> Is this what you were getting at, or am I missing your point?
>
> 							Thanx, Paul
>

My latest v9 series of qrwlock patch will automatically adapt to the 
lack of atomic byte access by using an atomic integer instruction 
instead. So the new series should work for pre-EV56 Alpha, it is just a 
bit less efficient in this case.

-Longman
