Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaBLHcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:32:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35237 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaBLHcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:32:20 -0500
Message-ID: <52FB2368.4060406@oracle.com>
Date: Wed, 12 Feb 2014 13:01:52 +0530
From: Allen Pais <allen.pais@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: [PATCH 3/4] sparc64: convert spinlock_t to raw_spinlock_t in
 mmu_context_t
References: <1388980510-10190-1-git-send-email-allen.pais@oracle.com> <1388980510-10190-4-git-send-email-allen.pais@oracle.com> <341392153219@web17g.yandex.ru>
In-Reply-To: <341392153219@web17g.yandex.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014 02:43 AM, Kirill Tkhai wrote:
> 
> 
> 06.01.2014, 07:56, "Allen Pais" <allen.pais@oracle.com>:
>> In the attempt of get PREEMPT_RT working on sparc64 using
>> linux-stable-rt version 3.10.22-rt19+, the kernel crash
>> with the following trace:
>>
>> [ 1487.027884] I7: <rt_mutex_setprio+0x3c/0x2c0>
>> [ 1487.027885] Call Trace:
>> [ 1487.027887]  [00000000004967dc] rt_mutex_setprio+0x3c/0x2c0
>> [ 1487.027892]  [00000000004afe20] task_blocks_on_rt_mutex+0x180/0x200
>> [ 1487.027895]  [0000000000819114] rt_spin_lock_slowlock+0x94/0x300
>> [ 1487.027897]  [0000000000817ebc] __schedule+0x39c/0x53c
>> [ 1487.027899]  [00000000008185fc] schedule+0x1c/0xc0
>> [ 1487.027908]  [000000000048fff4] smpboot_thread_fn+0x154/0x2e0
>> [ 1487.027913]  [000000000048753c] kthread+0x7c/0xa0
>> [ 1487.027920]  [00000000004060c4] ret_from_syscall+0x1c/0x2c
>> [ 1487.027922]  [0000000000000000]           (null)
>> - spin_unlock_irqrestore(&mm->context.lock, flags);
>> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
>>  }
> 
> We also should do the same in update_mmu_cache_pmd().
> 

I have already done this. I should have updated the patch. the issue still
persists though.

- Allen
