Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3CESHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:07:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51785 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab3CESGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:06:54 -0500
Date: Tue, 5 Mar 2013 19:06:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
Message-ID: <20130305180650.GD4914@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	hpa@linux.intel.com, linux-kernel@vger.kernel.org,
	Dave Hansen <dave@linux.vnet.ibm.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp>
 <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Dave.

This still says 3.8.0-rc5-00105-g68d00bb. Can you still trigger this
with 3.9-rc1?

And also, this is Linux running as a 32-bit guest in vmware, correct?

On Wed, Mar 06, 2013 at 12:41:10AM +0900, Tetsuo Handa wrote:
> Another problem
> 
> [    0.021748] Mount-cache hash table entries: 512
> [    0.036341] Disabled fast string operations
> [    0.037760] mce: CPU supports 0 MCE banks
> [    0.039813] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> [    0.039813] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
> [    0.039813] tlb_flushall_shift: -1
> [    0.074005] debug: unmapping init [mem 0xc186a000-0xc186efff]
> [    0.077005] ACPI: Core revision 20121018
> [    0.083350] ------------[ cut here ]------------
> [    0.084000] kernel BUG at arch/x86/mm/physaddr.c:79!
> [    0.084000] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    0.084000] Modules linked in:
> [    0.084000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc5-00105-g68d00bb #47 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
> [    0.084000] EIP: 0060:[<c102fa12>] EFLAGS: 00010206 CPU: 0
> [    0.084000] EIP is at __phys_addr+0x42/0x90
> [    0.084000] EAX: 00000000 EBX: 1fef0000 ECX: 0000000c EDX: 00000000
> [    0.084000] ESI: c1657edc EDI: 0000000f EBP: c1657dcc ESP: c1657dc8
> [    0.084000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.084000] CR0: 8005003b CR2: ffe13000 CR3: 01872000 CR4: 000006d0
> [    0.084000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [    0.084000] DR6: ffff0ff0 DR7: 00000400
> [    0.084000] Process swapper/0 (pid: 0, ti=c1656000 task=c1661180 task.ti=c1656000)
> [    0.084000] Stack:
> [    0.084000]  c1657e90 c1657dec c102ca3e c1661608 c166f700 00000000 c166f700 c1657df0
> [    0.084000]  00000000 c1657e70 c102ceee c10d7899 00000002 c1655000 00000000 c10d7632
> [    0.084000]  00000001 00000dfc 000002f0 c1657e60 c14ab000 0000000f 00000110 c1657e90
> [    0.084000] Call Trace:
> [    0.084000]  [<c102ca3e>] __cpa_process_fault+0x3e/0x80
> [    0.084000]  [<c102ceee>] __change_page_attr_set_clr+0x3de/0x6d0
> [    0.084000]  [<c10d7899>] ? __purge_vmap_area_lazy+0x2a9/0x360
> [    0.084000]  [<c10d7632>] ? __purge_vmap_area_lazy+0x42/0x360
> [    0.084000]  [<c10d913c>] ? vm_unmap_aliases+0x2bc/0x300
> [    0.084000]  [<c10d8ee4>] ? vm_unmap_aliases+0x64/0x300
> [    0.084000]  [<c102d2c5>] change_page_attr_set_clr+0xe5/0x390
> [    0.084000]  [<c102d5a2>] _set_memory_wb+0x32/0x40
> [    0.084000]  [<c102c46f>] ioremap_change_attr+0xf/0x40
> [    0.084000]  [<c102e857>] kernel_map_sync_memtype+0x87/0xf0
> [    0.084000]  [<c102c29b>] __ioremap_caller+0x21b/0x2f0
> [    0.084000]  [<c103d32a>] ? walk_system_ram_range+0xca/0xf0
> [    0.084000]  [<c102c3a3>] ioremap_cache+0x13/0x20
> [    0.084000]  [<c149a231>] ? acpi_os_map_memory+0xb6/0x112
> [    0.084000]  [<c149a231>] acpi_os_map_memory+0xb6/0x112
> [    0.084000]  [<c12ce038>] acpi_tb_verify_table+0x20/0x49
> [    0.084000]  [<c12cea67>] acpi_load_tables+0x35/0x13e
> [    0.084000]  [<c16c78c6>] acpi_early_init+0x67/0xeb
> [    0.084000]  [<c16a7b14>] start_kernel+0x30e/0x319
> [    0.084000]  [<c16a7677>] ? repair_env_string+0x5b/0x5b
> [    0.084000]  [<c16a7356>] i386_start_kernel+0x12c/0x12f
> [    0.084000] Code: 0c db c1 8d 98 00 00 00 40 85 d2 74 12 89 d9 c1 e9 0c 39 ca 72 19 e8 be cd ff ff 39 c3 75 0c 89 d8 5b 5d c3 0f 0b 8d 76 00 eb fb <0f> 0b eb fe 0f 0b 90 8d b4 26 00 00 00 00 eb f6 8b 15 8c 0b db
> [    0.084000] EIP: [<c102fa12>] __phys_addr+0x42/0x90 SS:ESP 0068:c1657dc8
> [    0.085033] ---[ end trace bd778c4c9eceaf67 ]---
> [    0.088242] Kernel panic - not syncing: Attempted to kill the idle task!
> 
> was found using http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1 and was bisected
> to commit 68d00bbe "Merge remote-tracking branch 'origin/x86/mm' into x86/mm2".
> 
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
