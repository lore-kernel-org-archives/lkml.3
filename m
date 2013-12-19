Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3LSOCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:02:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41801 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3LSOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:02:53 -0500
Message-ID: <52B2FC66.9010309@oracle.com>
Date: Thu, 19 Dec 2013 09:02:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
References: <52B289F4.7060205@oracle.com> <20131219103401.GE30183@twins.programming.kicks-ass.net>
In-Reply-To: <20131219103401.GE30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 05:34 AM, Peter Zijlstra wrote:
> On Thu, Dec 19, 2013 at 12:53:56AM -0500, Sasha Levin wrote:
>> Hi all,
>>
>> I think that my bloated kernel managed to create way too many entries in the
>> dependency table. If that sounds right, I can send a patch to increase those.
>>
>> Attached /proc/lock_stat as requested as well.
>
> /proc/lockdep_stats not lock_stat :-)
>
> Do you still happen to have that?

Is the BUG message intentional ("Please attach the output of /proc/lock_stat to the bug report")?

Here's /proc/lockdep_stats:

  lock-classes:                         2397 [max: 8191]
  direct dependencies:                 16384 [max: 16384]
  indirect dependencies:               60481
  all direct dependencies:            308079
  dependency chains:                   21162 [max: 32768]
  dependency chain hlocks:             67298 [max: 163840]
  in-hardirq chains:                      51
  in-softirq chains:                     430
  in-process chains:                   19782
  stack-trace entries:                235133 [max: 262144]
  combined max dependencies:       443376596
  hardirq-safe locks:                     59
  hardirq-unsafe locks:                 1285
  softirq-safe locks:                    156
  softirq-unsafe locks:                 1136
  irq-safe locks:                        168
  irq-unsafe locks:                     1285
  hardirq-read-safe locks:                 4
  hardirq-read-unsafe locks:             357
  softirq-read-safe locks:                 7
  softirq-read-unsafe locks:             337
  irq-read-safe locks:                     8
  irq-read-unsafe locks:                 357
  uncategorized locks:                   281
  unused locks:                            0
  max locking depth:                      12
  max bfs queue depth:                   663
  chain lookup misses:                 21432
  chain lookup hits:               490237032
  cyclic checks:                       20219
  find-mask forwards checks:           12353
  find-mask backwards checks:         128734
  hardirq on events:               372837372
  hardirq off events:              372837362
  redundant hardirq ons:                3467
  redundant hardirq offs:          361517382
  softirq on events:                 3688513
  softirq off events:                3688541
  redundant softirq ons:                   0
  redundant softirq offs:                  0
  debug_locks:                             0


Thanks,
Sasha
