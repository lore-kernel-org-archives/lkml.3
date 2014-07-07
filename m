Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaGGWs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:48:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19536 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:48:25 -0400
Message-ID: <53BB2392.20404@oracle.com>
Date: Mon, 07 Jul 2014 18:47:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net> <53BAA6DF.5060409@oracle.com> <20140707200550.GA6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140707200550.GA6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 04:05 PM, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>> I've also had this one, which looks similar:
>> 
>> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965 [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15 [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
> 
> Something's fucked; so we have:
> 
> debug_spin_lock_before() SPIN_BUG_ON(lock->owner == current, "recursion");
> 
> Causing that, _HOWEVER_ look at .owner_cpu and the reporting cpu!! How can the lock owner, own the lock on cpu 15 and again contend with it on CPU 0. That's impossible.
> 
> About when-ish did you start seeing things like this? Lemme go stare hard at recent changes.
> 

~next-20140704 I guess, about when I reported the original issue.


Thanks,
Sasha
