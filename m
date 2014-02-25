Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBYCpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:45:40 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39266 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBYCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:45:39 -0500
Message-ID: <530C03C6.9080405@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 10:45:26 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@redhat.com>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
References: <5302EBA3.10909@linux.vnet.ibm.com> <20140225003048.GJ8264@linux.vnet.ibm.com>
In-Reply-To: <20140225003048.GJ8264@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022502-3864-0000-0000-00000C9AA40C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

On 02/25/2014 08:30 AM, Paul E. McKenney wrote:
[snip]
> 
> I don't see an opportunity for load_balance() to loop with interrupts
> disabled, but maybe I am looking at the wrong code.  The NMI handler
> looks to me like it is diagnosing rather than being the problem.

Thanks for the comment :)

It was a stuck inside pick_next_task_fair(), and we already got one
solution now ;-)

Regards,
Michael Wang

> 
> 							Thanx, Paul
> 
>>  [<ffffffff8108a88f>] idle_balance+0x10f/0x1c0
>>  [<ffffffff8108aa5e>] pick_next_task_fair+0x11e/0x2a0
>>  [<ffffffff8107bbf3>] ? dequeue_task+0x73/0x90
>>  [<ffffffff815717fa>] __schedule+0x12a/0x670
>>  [<ffffffff81571e19>] schedule+0x29/0x70
>>  [<ffffffff81067daf>] worker_thread+0x1bf/0x370
>>  [<ffffffff81067bf0>] ? manage_workers+0x160/0x160
>>  [<ffffffff8106e799>] kthread+0xc9/0xe0
>>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
>>  [<ffffffff8157d62c>] ret_from_fork+0x7c/0xb0
>>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
>> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

