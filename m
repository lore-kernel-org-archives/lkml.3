Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbaDQI2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:28:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43824 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbaDQI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:28:37 -0400
Message-ID: <534F90B0.4010803@linaro.org>
Date: Thu, 17 Apr 2014 16:28:32 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [sched] INFO: rcu_sched self-detected stall on CPU { 3}
References: <534F8FF8.4040107@intel.com>
In-Reply-To: <534F8FF8.4040107@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 04:25 PM, Jet Chen wrote:
> Hi Alex
> 
> We noticed the below kernel BUG on

Thank a lot Jet!

> 
> https://github.com/alexshi/power-scheduling.git noload
> 
> commit 6b74b2031e15ae58470fd8dde7438df35e358c62
> Author:     Alex Shi <alex.shi@linaro.org>
> AuthorDate: Fri Apr 4 17:49:30 2014 +0800
> Commit:     Alex Shi <alex.shi@linaro.org>
> CommitDate: Fri Apr 4 17:49:30 2014 +0800
> 
>     sched: let task moving destination cpu do active balance
> 
>     Now we let the task source cpu do the active balance, while the
>     destination cpu maybe idle. At that time the task will be stopped
>     on resource cpu and wait the destination cpu up. That hurt the
>     performace. Let destination cpu do active balance will give task
> 
> 
> <3>[  614.504149] INFO: rcu_sched self-detected stall on CPU { 3} 
> (t=100007 jiffies g=1455 c=1454 q=87882)
> <6>[  614.504731] sending NMI to all CPUs:
> <4>[  614.505003] NMI backtrace for cpu 0
> <4>[  614.505228] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 3.14.0-01205-g0e2d6b2 #1
> <4>[  614.505671] Hardware name:                  /DX58SO, BIOS
> SOX5810J.86A.4196.2009.0715.1958 07/15/2009
> <4>[  614.506185] task: ffffffff82011440 ti: ffffffff82000000 task.ti:
> ffffffff82000000
> <4>[  614.506637] RIP: 0010:[<ffffffff814c7599>]  [<ffffffff814c7599>]
> intel_idle+0xdc/0x132
> <4>[  614.507116] RSP: 0018:ffffffff82001e48  EFLAGS: 00000046
> <4>[  614.507401] RAX: 0000000000000020 RBX: 0000000000000008 RCX:
> 0000000000000001
> <4>[  614.507750] RDX: 0000000000000000 RSI: 0000000000000046 RDI:
> 0000000000000046
> <4>[  614.508100] RBP: ffffffff82001e70 R08: ffff8800bf213ebc R09:
> 00000000000000ca
> <4>[  614.508449] R10: 0000000000000006 R11: 000000000000049a R12:
> 0000000000000004
> <4>[  614.508799] R13: 0000000000000020 R14: 0000000000000003 R15:
> 0000000000000000
> <4>[  614.509148] FS:  0000000000000000(0000) GS:ffff8800bf200000(0000)
> knlGS:0000000000000000
> <4>[  614.509622] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>[  614.509922] CR2: 00000000025ae424 CR3: 000000000200c000 CR4:
> 00000000000007f0
> <4>[  614.510271] Stack:
> <4>[  614.510440]  0000000000000018 ffff8800bf21dd00 ffffffff820a2a18
> 0000008f0b6dd4cf
> <4>[  614.510918]  0000000008004000 ffffffff82001eb0 ffffffff81866cb1
> 0000000400000006
> <4>[  614.511396]  ffffffff820a28a0 ffff8800bf21dd00 0000000000000004
> ffffffff820a28a0
> <4>[  614.511874] Call Trace:
> <4>[  614.512061]  [<ffffffff81866cb1>] cpuidle_enter_state+0x45/0xb5
> <4>[  614.512369]  [<ffffffff81866e2c>] cpuidle_idle_call+0x10b/0x1db
> <4>[  614.512678]  [<ffffffff8104241b>] arch_cpu_idle+0xe/0x28
> <4>[  614.512965]  [<ffffffff8112452b>] cpu_startup_entry+0x131/0x20a
> <4>[  614.513273]  [<ffffffff819aae53>] rest_init+0x87/0x89
> <4>[  614.513550]  [<ffffffff8214fde0>] start_kernel+0x407/0x412
> <4>[  614.513842]  [<ffffffff8214f7e7>] ? repair_env_string+0x58/0x58
> <4>[  614.514150]  [<ffffffff8214f120>] ? early_idt_handlers+0x120/0x120
> <4>[  614.514466]  [<ffffffff8214f4a2>] x86_64_start_reservations+0x2a/0x2c
> <4>[  614.514792]  [<ffffffff8214f5df>] x86_64_start_kernel+0x13b/0x148
> <4>[  614.515104] Code: b9 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65
> 48 8b 04 25 60 b9 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8
> 0f 01 c9 <65> 48 8b 04 25 60 b9 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48
> <4>[  614.519105] NMI backtrace for cpu 1
> 
> Full dmesg & Kconifg are attached, and more details can be provided on
> your request.
> 
> Thanks,
> Jet


-- 
Thanks
    Alex
