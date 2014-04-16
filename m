Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067AbaDPNNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:13:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:64859 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbaDPNNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="494133580"
Date: Wed, 16 Apr 2014 06:12:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1857 at arch/x86/kernel/smp.c:124
Message-ID: <20140416131257.GF32556@tassilo.jf.intel.com>
References: <534E49C8.7050206@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534E49C8.7050206@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  [<ffffffff810349ab>] local_apic_timer_interrupt+0x3b/0x60
>  [<ffffffff815903d5>] smp_apic_timer_interrupt+0x45/0x60
>  [<ffffffff8158f18a>] apic_timer_interrupt+0x6a/0x70
>  <EOI>  [<ffffffff81581bd1>] ? panic+0x1a7/0x1ea
>  [<ffffffff81581bcd>] ? panic+0x1a3/0x1ea

You're using panic_on_oops?

That seems like a bug in panic. It shouldn't reenable interrupts

-Andi


>  [<ffffffff81586df4>] oops_end+0xd4/0xf0
>  [<ffffffff8104299e>] no_context+0x12e/0x200
>  [<ffffffff81042b8d>] __bad_area_nosemaphore+0x11d/0x220
>  [<ffffffff81042cfe>] bad_area+0x4e/0x60
>  [<ffffffff815898e0>] __do_page_fault+0x430/0x490
>  [<ffffffff810a4d85>] ? call_console_drivers.clone.2+0xa5/0x100
>  [<ffffffff811192b9>] ? irq_work_queue+0x69/0xc0
>  [<ffffffff810a46a4>] ? wake_up_klogd+0x34/0x40
>  [<ffffffff810a51bd>] ? console_unlock+0x24d/0x280
>  [<ffffffff81589a1c>] do_page_fault+0xc/0x10
>  [<ffffffff815862a2>] page_fault+0x22/0x30
>  [<ffffffff81350206>] ? sysrq_handle_crash+0x16/0x20
>  [<ffffffff81350b79>] __handle_sysrq+0x129/0x190
>  [<ffffffff81350c1d>] write_sysrq_trigger+0x3d/0x40
>  [<ffffffff811edc93>] proc_reg_write+0x43/0x70
>  [<ffffffff81189b84>] vfs_write+0xc4/0x1e0
>  [<ffffffff81189d86>] SyS_write+0x56/0xd0
>  [<ffffffff810e3d56>] ? __audit_syscall_exit+0x216/0x2c0
>  [<ffffffff8158e5d2>] system_call_fastpath+0x16/0x1b
