Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaKJQKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:10:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19388 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaKJQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:10:03 -0500
Message-ID: <5460E339.5020308@oracle.com>
Date: Mon, 10 Nov 2014 11:09:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com> <20141110160320.GA10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141110160320.GA10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 11:03 AM, Peter Zijlstra wrote:
> On Fri, Nov 07, 2014 at 10:48:27PM -0500, Sasha Levin wrote:
>> [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
>> [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
> 
> Ooh, look at that. CPU#10 vs .owner_cpu: 13 on the _same_ task.
> 
> One of those again :/

Hum. I missed that one.

Hold on, but the magic here is fine and the owner pointer is fine, why would just the owner cpu
be wrong?


Thanks,
Sasha

