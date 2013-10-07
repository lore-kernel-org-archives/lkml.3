Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3JGIuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:50:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3JGIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:50:08 -0400
Date: Mon, 7 Oct 2013 10:49:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86] BUG: unable to handle kernel paging request at 08000060
Message-ID: <20131007084957.GY3081@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
 <20131005234728.GA22657@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005234728.GA22657@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 07:47:28AM +0800, Fengguang Wu wrote:
> 
> Hi Peter,
> 
> Here is another bisect on a different kconfig.
> 
> [    6.612196] Write protecting the kernel text: 9752k
> [    6.613078] Write protecting the kernel read-only data: 3444k
> [    6.647222] BUG: unable to handle kernel paging request at 08000060
> [    6.648030] IP: [<41046ab0>] task_work_run+0x60/0xa0
> [    6.648030] *pde = 0686f067 *pte = 00000000 
> [    6.648030] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [    6.648030] CPU: 0 PID: 131 Comm: rc.local Not tainted 3.12.0-rc2-02842-g45c4ea0 #2
> [    6.648030] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    6.648030] task: 46865000 ti: 46874000 task.ti: 46874000
> [    6.648030] EIP: 0060:[<41046ab0>] EFLAGS: 00010206 CPU: 0
> [    6.648030] EIP is at task_work_run+0x60/0xa0
> [    6.648030] EAX: 08000060 EBX: 46862f40 ECX: 00000000 EDX: 08000060
> [    6.648030] ESI: 468652ac EDI: 46865000 EBP: 46875f9c ESP: 46875f90
> [    6.648030]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    6.648030] CR0: 8005003b CR2: 08000060 CR3: 0686e000 CR4: 00000690
> [    6.648030] Stack:
> [    6.648030]  396f7903 396e0ee8 37642ff4 46875fac 41002310 41984ebc 4fff01bc 46874000
> [    6.648030]  419848e6 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    6.648030]  0000007b 0000007b 00000000 00000000 0000000b 377a01d0 00000073 00000200
> [    6.648030] Call Trace:
> [    6.648030]  [<41002310>] do_notify_resume+0x50/0x60
> [    6.648030]  [<41984ebc>] ? sysenter_do_call+0x1e/0x37
> [    6.648030]  [<419848e6>] work_notifysig+0x26/0x30
> [    6.648030] Code: eb 0b 89 f6 8d bc 27 00 00 00 00 31 c9 89 d0 0f b1 0e 39 c2 75 d5 85 d2 74 46 90 f3 90 8b 87 e4 02 00 00 85 c0 74 f4 31 db 66 90 <8b> 02 89 1a 85 c0 74 08 89 d3 89 c2 eb f2 66 90 89 d0 ff 52 04
> [    6.648030] EIP: [<41046ab0>] task_work_run+0x60/0xa0 SS:ESP 0068:46875f90
> [    6.648030] CR2: 0000000008000060
> [    6.678032] CRED: Invalid credentials
> 
> git bisect start 45c4ea0c4c1b8abffb575b865243fd1c69bbecd9 v3.11 --
> git bisect good 39eda2aba6be642b71f2e0ad623dcb09fd9d79cf  # 00:42    150+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect good bff157b3ad4b9f6be0af6987fcd62deaf0f2b799  # 03:47    150+  Merge branch 'slab/next' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux
> git bisect good f659a4f17bbecdbad57dd5c63a1783e5ec5fd792  # 09:17    150+  Merge remote-tracking branch 'drm-intel/for-linux-next'
> git bisect  bad 6405cd58ac5c0a6ed5f4f1308892147870b9d5cf  # 09:22      1-  Merge remote-tracking branch 'regmap/for-next'
> git bisect good 5094001bc464c12d3e04eb73a5e0d5e8436f09f7  # 12:28    150+  Merge remote-tracking branch 'omap_dss2/for-next'
> git bisect good 8f31410ee9917e8648c7cf7f45e22320c166998a  # 17:48    150+  Merge remote-tracking branch 'spi/for-next'
> git bisect  bad 6f014a7ea91f80f765ba700dcd1728680ba5c58e  # 17:52      0-  Merge remote-tracking branch 'tip/auto-latest'
> git bisect  bad bce56fbc0f165658f7e0715fedc8d39840bae31c  # 17:57      0-  Merge branch 'sched/core'
> git bisect  bad c2daa3bed53a81171cf8c1a36db798e82b91afe8  # 18:01      2-  sched, x86: Provide a per-cpu preempt_count implementation
> git bisect good 4314895165623879937f46d767673654662b570c  # 18:18    150+  sched: Micro-optimize by dropping unnecessary task_rq() calls
> git bisect  bad 4a2b4b222743bb07fedf985b884550f2ca067ea9  # 18:22      2-  sched: Introduce preempt_count accessor functions
> git bisect  bad b021fe3e25094fbec22d0eff846d2adeee1b9736  # 18:26      0-  sched, rcu: Make RCU use resched_cpu()
> git bisect  bad 0c44c2d0f459cd7e275242b72f500137c4fa834d  # 18:27      0-  x86: Use asm goto to implement better modify_and_test() functions
> git bisect good 4314895165623879937f46d767673654662b570c  # 21:38    450+  sched: Micro-optimize by dropping unnecessary task_rq() calls
> git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:38      0-  Add linux-next specific files for 20130927
> git bisect good c31eeaced22ce8bd61268a3c595d542bb38c0a4f  # 21:59    450+  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:59      0-  Add linux-next specific files for 20130927
> 

Does this point to the same commit or what? How does one read these
things?
