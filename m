Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbaGXXi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:38:57 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:53700 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934843AbaGXXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:38:56 -0400
Message-ID: <53D1990F.6040404@candelatech.com>
Date: Thu, 24 Jul 2014 16:38:55 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crashes in 3.14.13+ related to anon_vma_clone.
References: <53D191E1.3080107@candelatech.com>
In-Reply-To: <53D191E1.3080107@candelatech.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 04:08 PM, Ben Greear wrote:
> A few of our systems are repeatedly crashing when upgraded from
> the 3.14.6+ to 3.14.13+ kernels.  Both kernels have a fair bit
> of our out-of-tree patches, so could be our fault.

Ahh, looks like a bad merge of a stable patch with a slightly different
manually applied stable patch, causing double-free
in the wifi stack...

Sorry for the noise.

Thanks,
Ben

> 
> But, in case this is a known problem...has anyone seen crashes like
> this below?
> 
> Test case is using some ath9k APs and stations, but not certain
> that has much to do with the problem.
> 
> BUG: unable to handle kernel paging request at 0000003f9840b000
> IP: [<ffffffff81169ae8>] anon_vma_clone+0x88/0xf5
> PGD be580067 PUD bab85067 PMD babd5067 PTE 80000000bebbd065
> Oops: 0003 [#1] PREEMPT SMP
> Modules linked in: 8021q garp stp mrp llc fuse macvlan wanlink(O) pktgen ip6table_filter ip6_tables ebtable_nat ebtables coretemp hwmoo
> CPU: 1 PID: 1777 Comm: btserver Tainted: G         C O 3.14.13+ #19
> Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 03/06/2012
> task: ffff88020dcfb100 ti: ffff8800baa3e000 task.ti: ffff8800baa3e000
> RIP: 0010:[<ffffffff81169ae8>]  [<ffffffff81169ae8>] anon_vma_clone+0x88/0xf5
> RSP: 0018:ffff8800baa3fda0  EFLAGS: 00010246
> RAX: ffff8800ba8b8380 RBX: 0000003f9840b000 RCX: 000000000142b101
> RDX: 0000000000000000 RSI: ffff8800ba8b8380 RDI: ffff8800ba8b8388
> RBP: ffff8800baa3fdd0 R08: 0000000000015d60 R09: 0000003f9840b000
> R10: 000000000000000b R11: 0000000000016338 R12: 0000000000000000
> R13: ffff8800bc609450 R14: ffff8802212db980 R15: ffff8800ba8b8380
> FS:  00007f0b70511740(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003f9840b000 CR3: 00000000bab8f000 CR4: 00000000000007e0
> Stack:
>  ffff880221ba92a0 ffff88020dcfc980 ffff8800bc609450 ffff880221ba9228
>  ffff8800bc609450 ffff880221ba9228 ffff8800baa3fe08 ffffffff81169b7b
>  ffff88020dcfc980 ffff880211db5f80 ffff880221ba9228 ffff8800bc609450
> Call Trace:
>  [<ffffffff81169b7b>] anon_vma_fork+0x26/0xec
>  [<ffffffff810c0070>] copy_process.part.28+0xf98/0x16ca
>  [<ffffffff810c091d>] do_fork+0xb4/0x211
>  [<ffffffff810cbe9b>] ? __set_task_blocked+0x5e/0x64
>  [<ffffffff815a1b9f>] ? _raw_spin_unlock_irq+0xc/0x1f
>  [<ffffffff810c0ae0>] SyS_clone+0x11/0x13
>  [<ffffffff815a6a59>] stub_clone+0x69/0x90
>  [<ffffffff815a66fd>] ? system_call_fastpath+0x1a/0x1f
> Code: 48 8b 3d 64 f1 b0 00 be d0 00 00 00 e8 9b 5e 01 00 48 85 c0 48 89 c3 74 62 45 31 e4 4d 8b 7e 08 4c 89 e7 49 8b 37 e8 fa ec ff ff
> RIP  [<ffffffff81169ae8>] anon_vma_clone+0x88/0xf5
>  RSP <ffff8800baa3fda0>
> CR2: 0000003f9840b000
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

