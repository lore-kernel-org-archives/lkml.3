Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaEIDWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:22:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbaEIDWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:22:21 -0400
Message-ID: <536C49E6.9000503@oracle.com>
Date: Thu, 08 May 2014 23:22:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: blk-mq: WARN at block/blk-mq.c:585 __blk_mq_run_hw_queue
References: <536A532C.4050001@oracle.com> <536A5532.1060008@fb.com> <536A56E4.5020909@oracle.com> <536A5764.4020606@fb.com>
In-Reply-To: <536A5764.4020606@fb.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 11:55 AM, Jens Axboe wrote:
> On 05/07/2014 09:53 AM, Sasha Levin wrote:
>> On 05/07/2014 11:45 AM, Jens Axboe wrote:
>>> On 05/07/2014 09:37 AM, Sasha Levin wrote:
>>>> Hi all,
>>>>
>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>>> kernel I've stumbled on the following spew:
>>>>
>>>> [  986.962569] WARNING: CPU: 41 PID: 41607 at block/blk-mq.c:585 __blk_mq_run_hw_queue+0x90/0x500()
>>>
>>> I'm going to need more info than this. What were you running? How as kvm
>>> invoked (nr cpus)?
>>
>> Sure!
>>
>> It's running in a KVM tools guest (not qemu), with the following options:
>>
>> '--rng --balloon -m 28000 -c 48 -p "numa=fake=32 init=/virt/init zcache ftrace_dump_on_oops debugpat kvm.mmu_audit=1 slub_debug=FZPU rcutorture.rcutorture_runnable=0 loop.max_loop=64 zram.num_devices=4 rcutorture.nreaders=8 oops=panic nr_hugepages=1000 numa_balancing=enable'.
>>
>> So basically 48 vcpus (the host has 128 physical ones), and ~28G of RAM.
>>
>> I've been running trinity as a fuzzer, which doesn't handle logging too well,
>> so I can't reproduce it's actions easily.
>>
>> There was an additional stress of hotplugging CPUs and memory during this recent
>> fuzzing run, so it's fair to suspect that this happened as a result of that.
> 
> Aha!
> 
>> Anything else that might be helpful?
> 
> No, not too surprising given the info that cpu hotplug was being
> stressed at the same time. blk-mq doesn't quiesce when this happens, so
> it's very unlikely that there are races between updating the cpu masks
> and flushing out the previously queued work.

So this warning is something you'd expect when CPUs go up/down?


Thanks,
Sasha

