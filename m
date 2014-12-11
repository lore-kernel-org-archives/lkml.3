Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaLKLrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:47:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLKLrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:47:10 -0500
Message-ID: <54898436.3030708@redhat.com>
Date: Thu, 11 Dec 2014 12:47:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [LKP] [virtio] Out of memory: Kill process 2924 (time) score
 999 or sacrifice child
References: <1418284417.5745.65.camel@intel.com>
In-Reply-To: <1418284417.5745.65.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2014 08:53, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> commit 8faeb529b2dabb9df691d614dda18910a43d05c9 ("virtio-scsi: fix various bad behavior on aborted requests")
> 
> Some test crashes are fixed by this commit, but we found OOM at the same time.  The test case is xfstests.

Can you capture /proc/slabinfo, and also try disabling asynchronous page
faults?

Thanks,

Paolo

> testbox/testcase/testparams: vm-kbuild-1G/xfstests/4HDD-ext4-generic-slow2
> 
> cdda0e5acbb78f7b  8faeb529b2dabb9df691d614dd  
> ----------------  --------------------------  
>        fail:runs  %reproduction    fail:runs
>            |             |             |    
>            :30         100%          30:30    dmesg.Out_of_memory:Kill_process
>            :30          36%          11:30    last_state.xfstests.exit_code.9
>            :30           3%           1:30    last_state.xfstests.kill_code.9
>          25:30         -83%            :30    dmesg.BUG:kernel_test_crashed
>           5:30         -16%            :30    dmesg.kernel_BUG_at_block/blk-core.c
>           5:30         -16%            :30    dmesg.invalid_opcode
>           5:30         -16%            :30    dmesg.RIP:blk_finish_request
>           5:30         -16%            :30    dmesg.Kernel_panic-not_syncing:Fatal_exception_in_interrupt
> 
> [  178.290439] sda: WRITE SAME failed. Manually zeroing.
> [  180.488061] EXT4-fs (sdd): mounted filesystem with ordered data mode. Opts: acl,user_xattr
> [  184.689327] EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: acl,user_xattr
> [  186.720974] 224 invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
> [  186.722943] 224 cpuset=/ mems_allowed=0
> [  186.724090] CPU: 0 PID: 4904 Comm: 224 Not tainted 3.18.0-gb2776bf #1
> [  186.725321] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  186.726476]  0000000000000000 ffff880015a739d8 ffffffff819f1bb0 0000000000002695
> [  186.728892]  ffff880036969bc0 ffff880015a73a58 ffffffff819f028b ffff880015a73a38
> [  186.731138]  ffffffff814ac2bb 000000000000b7bc 000000000000b800 0000000000000000
> [  186.733173] Call Trace:
> [  186.733949]  [<ffffffff819f1bb0>] dump_stack+0x4e/0x68
> [  186.735021]  [<ffffffff819f028b>] dump_header+0xa3/0x224
> [  186.736140]  [<ffffffff814ac2bb>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [  186.737381]  [<ffffffff8119f1ef>] oom_kill_process+0x73/0x36b
> [  186.738543]  [<ffffffff8119ef25>] ? oom_unkillable_task+0xc0/0xe2
> [  186.739737]  [<ffffffff810f1ed1>] ? has_ns_capability_noaudit+0x1f/0x2e
> [  186.740999]  [<ffffffff8119fa86>] out_of_memory+0x42b/0x446
> [  186.742121]  [<ffffffff811a42d2>] __alloc_pages_nodemask+0x860/0x8a9
> [  186.743335]  [<ffffffff811dd88e>] alloc_pages_vma+0x10b/0x15f
> [  186.744521]  [<ffffffff811c1c02>] do_wp_page+0x40a/0x772
> [  186.745612]  [<ffffffff811c4b73>] handle_mm_fault+0xc0f/0xeae
> [  186.746762]  [<ffffffff81073561>] __do_page_fault+0x38b/0x4c3
> [  186.748249]  [<ffffffff81073712>] ? trace_do_page_fault+0x52/0xb7
> [  186.749443]  [<ffffffff814ac2bb>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [  186.750674]  [<ffffffff819f83f7>] ? _raw_spin_lock_irq+0x1a/0x50
> [  186.752310]  [<ffffffff810f7f55>] ? do_sigaction+0xa2/0x171
> [  186.754150]  [<ffffffff810f429b>] ? recalc_sigpending+0x17/0x4c
> [  186.755560]  [<ffffffff81073712>] trace_do_page_fault+0x52/0xb7
> [  186.756766]  [<ffffffff8106dd57>] do_async_page_fault+0x31/0x67
> [  186.757942]  [<ffffffff819fa838>] async_page_fault+0x28/0x30
> [  186.766685] Mem-Info:
> [  186.767419] Node 0 DMA per-cpu:
> [  186.768350] CPU    0: hi:    0, btch:   1 usd:   0
> 
> Thanks,
> Fengguang
> 
