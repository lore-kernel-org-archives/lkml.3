Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaHEW06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:26:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44543 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaHEW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:26:57 -0400
Message-ID: <53E159F6.7080603@oracle.com>
Date: Tue, 05 Aug 2014 18:25:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <53DFFD28.2030502@oracle.com> <alpine.DEB.2.11.1408050950390.16902@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1408050950390.16902@gentwo.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 10:51 AM, Christoph Lameter wrote:
> On Mon, 4 Aug 2014, Sasha Levin wrote:
> 
>> On 07/25/2014 10:22 PM, Sasha Levin wrote:
>>> On 07/10/2014 10:04 AM, Christoph Lameter wrote:
>>>>> This patch creates a vmstat shepherd worker that monitors the
>>>>> per cpu differentials on all processors. If there are differentials
>>>>> on a processor then a vmstat worker local to the processors
>>>>> with the differentials is created. That worker will then start
>>>>> folding the diffs in regular intervals. Should the worker
>>>>> find that there is no work to be done then it will make the shepherd
>>>>> worker monitor the differentials again.
>>> Hi Christoph, all,
>>>
>>> This patch doesn't interact well with my fuzzing setup. I'm seeing
>>> the following:
>>
>> I think we got sidetracked here a bit, I've noticed that this issue
>> is still happening in -next and discussions here died out.
> 
> Ok I saw in another thread that this issue has gone away. Is there an
> easy way to reproduce this on my system?
> 

I don't see the VM_BUG_ON anymore, but the cpu warnings are still there.

I can easily trigger it by cranking up the cpu hotplug code. Just try to
frequently offline and online cpus, it should reproduce quickly.


Thanks,
Sasha
