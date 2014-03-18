Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaCRVIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:08:04 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46441 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaCRVIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:08:02 -0400
Date: Tue, 18 Mar 2014 17:10:37 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> 
> > [    3.678040] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018                                                                        
> > [    3.686776] IP: [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250    
> 
> The back trace is not really helpful. Is there anything before that
> BUG in dmesg?

no, just normal boot messages.

I re-compiled with the frame pointer enabled and here's an updated 
version:

[    3.722836] sd 1:0:0:0: [sda] 4096-byte physical blocks                      
[    3.728682] sd 1:0:0:0: [sda] Write Protect is off                           
[    3.728826] sr 0:0:0:0: Attached scsi generic sg0 type 5                     
[    3.728992] sd 1:0:0:0: Attached scsi generic sg1 type 0                     
[    3.745700] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
[    3.787096]  sda: sda1 sda2 sda3 sda4                                        
[    3.792169] sd 1:0:0:0: [sda] Attached SCSI disk                             
[    4.312111] ------------[ cut here ]------------                             
[    4.317176] kernel BUG at kernel/timer.c:1084!                               
[    4.322093] invalid opcode: 0000 [#1] SMP                                    
[    4.326856] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci ehci_pci libata e1000e xhci_hcd ehci_hcd ptp scsi_mod crc32c_intel usbcore pps_core usb_common fan thermal thermal_sys 
[    4.352168] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc7 #3          
[    4.359034] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014                                                                             
[    4.367138] task: ffff880118e989a0 ti: ffff880118e9e000 task.ti: ffff880118e9e000                                                                            
[    4.375353] RIP: 0010:[<ffffffff8106d073>]  [<ffffffff8106d073>] cascade+0x93/0xa0                                                                           
[    4.383766] RSP: 0018:ffff88011ea43e78  EFLAGS: 00010086                     
[    4.389555] RAX: 0000000000000000 RBX: ffff88011839de60 RCX: ffff880118ecdc28
[    4.397324] RDX: 000000000000001f RSI: ffff8801183a8150 RDI: ffff880118ecc000
Begin: Loading essential drivers ... done.                                                                      
[    4.405232] RBP: ffff88011ea43ea8 R08: ffe20047a9380000 R09: 0000000000000000                                                                
[    4.414260] R10: 0000000000000004 R11: 0000000000000005 R12: ffff880118ecc000                                                                
Begin: Running /scripts/init-premount ... done.                                                                     
[    4.423278] R13: ffff88011ea43e78 R14: 000000000000001f R15: ffffffff81876e10                                                                            
[    4.432348] FS:  0000000000000000(0000) GS:ffff88011ea40000(0000) knlGS:0000000000000000                                                     
[    4.442441] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Begin: Mounting root file system ...
[    4.450013] CR2: 0000000000e762c8 CR3: 000000000180e000 CR4: 00000000001407e0                                                                             
[    4.459072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                                                
[    4.468156] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400                                                                
[    4.477197] Stack:                                           
Begin: Running /scripts/local-top ... done.                   
[    4.480741]  ffff8801183a8150 ffff88011839d460 ffff880118ecc0000000000000000000
Begin: Running /scripts/local-pre mount ... done.                                                             
[    4.495754]  0000000000000001 0000000000000100 ffff88011ea43f18 ffffffff8106e15c                                                                             
[    4.504269]  ffff880118ecdc28 ffff880118ecd828 ffff880118ecd428 ffff880118ecd028                                                                             
[    4.512741] Call Trace:                                                      
[    4.515466]  <IRQ>                                                           
[    4.517617]  [<ffffffff8106e15c>] run_timer_softirq+0x21c/0x2a0              
[    4.524524]  [<ffffffff810c8716>] ? clockevents_program_event+0x66/0xe0      
[    4.531800]  [<ffffffff81066c15>] __do_softirq+0xf5/0x290                    
[    4.537734]  [<ffffffff81066fdd>] irq_exit+0x9d/0xb0                         
[    4.543211]  [<ffffffff8104440f>] smp_apic_timer_interrupt+0x3f/0x50         
[    4.550147]  [<ffffffff81545f9d>] apic_timer_interrupt+0x6d/0x80             
[    4.556729]  <EOI>                                                           
[    4.558894]  [<ffffffff81413ffd>] ? cpuidle_enter_state+0x4d/0xc0            
[    4.565969]  [<ffffffff81414124>] cpuidle_idle_call+0xb4/0x1f0               
[    4.572381]  [<ffffffff8101cfc9>] arch_cpu_idle+0x9/0x30                     
[    4.578239]  [<ffffffff810b4f05>] cpu_startup_entry+0x95/0x240               
[    4.584608]  [<ffffffff810426f0>] start_secondary+0x1a0/0x1f0                
[    4.590924] Code: 49 39 cc 75 26 48 89 de 48 89 c3 4c 89 e7 e8 15 f7 ff ff 4c 39 eb 48 8b 03 75 dd 48 83 c4 10 44 89 f0 5b 41 5c 41 5d 41 5e 5d c3 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 31 c0 48 89 e5 41 56                          
[    4.617262] RIP  [<ffffffff8106d073>] cascade+0x93/0xa0                      
[    4.623091]  RSP <ffff88011ea43e78>                                          
[    4.626976] ---[ end trace dd695d8667870673 ]---                             
[    4.632059] Kernel panic - not syncing: Fatal exception in interrupt         
[    4.639037] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Vince
