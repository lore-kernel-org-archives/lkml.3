Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbaE2QpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:45:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbaE2QpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:45:06 -0400
Message-ID: <538763E7.6030902@oracle.com>
Date: Thu, 29 May 2014 12:44:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net> <53739A9A.5010703@oracle.com> <20140514163535.GS30445@twins.programming.kicks-ass.net> <538676A7.6090306@oracle.com> <20140529075723.GA30445@twins.programming.kicks-ass.net> <5387486D.20108@oracle.com> <20140529150705.GJ19143@laptop.programming.kicks-ass.net>
In-Reply-To: <20140529150705.GJ19143@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 11:07 AM, Peter Zijlstra wrote:
> On Thu, May 29, 2014 at 10:47:09AM -0400, Sasha Levin wrote:
>> It doesn't work out well because we later lock a mutex in sync_child_event().
>>
> 
> Urgh, right you are. I'll go stare at it more. It shouldn't have
> mattered, because the mutex we take just before should ensure existence,
> but.. you know.. :-)
> 

So the only caller to sync_child_event() is that loop. According to what you said
it should be safe to remove that mutex lock, but doing that triggers a list
corruption:

[ 1204.341887] WARNING: CPU: 20 PID: 12839 at lib/list_debug.c:62 __list_del_entry+0xa1/0xe0()
[ 1204.347597] list_del corruption. next->prev should be ffff8806ca68b108, but was ffff88051a67c398
[...]

I don't see how that would happen :/


Thanks,
Sasha
