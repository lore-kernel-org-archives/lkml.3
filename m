Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaJYBkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:40:00 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35119 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaJYBj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:39:58 -0400
Message-ID: <544AFF25.2030806@huawei.com>
Date: Sat, 25 Oct 2014 09:38:45 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Fwd: [RFD]:Is there any method to snapshot all information from both
 tasks on cpus and cpus when kernel crash occurs
References: <544AFDF7.2070309@huawei.com>
In-Reply-To: <544AFDF7.2070309@huawei.com>
X-Forwarded-Message-Id: <544AFDF7.2070309@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.180]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.544AFF36.00CF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: fc04cc001f5aba960fd23c323150f29d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For arm32 platform. I want to know whether or not a mechanism in kernel can snapshot tasks and cpus
information as the follow. If not, such a mechanism can be accepted by kernel.



...

</module list>

<task info>

TASK: [pid 1], [tgid 1], [linuxrc] [state S] [policy 0] [cpu 3]

 EIP address: [<401945a4>] 0x401945a4

       r0 = ffffffff;   r1 = 00000000

       r2 = 00000000;      r3 = 00000000

       r4 = 00000000;      r5 = 00000000

       r6 = ffffffff;   r7 = 00000072

       r8 = 00000050;      r9 = 00000000

       r10 = beec1e34;     fp = 00000000

       ip = 00095414;      sp = beec1bc8

       lr = 00069f2c;pc = 401945a4

       cpsr = 60000210;

[<c0cd9338>] (schedule+0x4fc/0x61c)

[<c0a56418>] (do_wait+0x1c0/0x22c)

[<c0a57670>] (sys_wait4+0xa0/0xc0)

[<c0a295c0>] (ret_fast_syscall+0x0/0x3c)

TASK: [pid 2], [tgid 2], [kthreadd] [state S] [policy 0] [cpu 1]

 EIP address: [<c0a6ea94>] kthreadd+0x8c/0x14c

[<c0cd9338>] (schedule+0x4fc/0x61c)

[<c0a6ea94>] (kthreadd+0x8c/0x14c)

[<c0a2a7d8>] (kernel_thread_exit+0x0/0x8)

...

</task info>

<cpu info cpu_id = 0>

TASK: [pid 29666], [tgid 29666], [kstop/1] [state R] [policy 1] [cpu 1]

[<c0a31310>] (ksnapshot_unwind_backtrace.part.2+0x50/0x154)

[<bf068144>] (us_dump_stack+0x38/0x44 [rtos_snapshot])

[<bf068f34>] (snapshot_cpu_info+0x60/0x4a8 [rtos_snapshot])

[<bf068b84>] (ksnapshot_taskinfo_buffer+0x320/0x4a8 [rtos_snapshot])

[<bf071018>] (fiq_callcack_handler+0x18/0x30 [test_ks])

[<c0a2eddc>] (fiq_real_handle+0x24/0x30)

[<c0a2836c>] (do_IPI+0x64/0x1c0)

[<c0cdb8e4>] (__irq_svc+0x44/0xe0)

[<c0a90088>] (stop_cpu+0x104/0x124)

[<c0a6a670>] (worker_thread+0x1a4/0x248)

[<c0a6e7a4>] (kthread+0x78/0x84)

[<c0a2a7d8>] (kernel_thread_exit+0x0/0x8)

</cpu info>

...

<cpu info cpu_id = n>

...

</cpu info>

Thanks
Yan











