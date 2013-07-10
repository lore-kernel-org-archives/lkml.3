Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3GJWNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:13:41 -0400
Received: from fifo99.com ([67.223.236.141]:46331 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3GJWNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:13:39 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 18:13:39 EDT
Date: Wed, 10 Jul 2013 15:03:30 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: crash in sys_get_curr_temp
Message-ID: <20130710220329.GA13732@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I get this crash on linux-next as of today ..


[    4.678947] general protection fault: 0000 [#1] SMP                                                                                                                                                          
  2 [    4.678953] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-next-20130710 #57                                                                                                                               
  3 [    4.678959] Hardware name: Intel Corp. Mohan Peak/Server, BIOS EDVLCRB1.86B.0017.R00.1305271414 05/27/2013                                                                                                   
  4 [    4.678963] task: ffff88017aa80000 ti: ffff88017aa6c000 task.ti: ffff88017aa6c000                                                                                                                            
  5 [    4.678985] RIP: 0010:[<ffffffff812c0e19>]  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                    
  6 [    4.678987] RSP: 0000:ffff88017aa6dc70  EFLAGS: 00010046                                                                                                                                                     
  7 [    4.678989] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000000000001b1                                                                                                                                
  8 [    4.678990] RDX: 0000000000000000 RSI: ffff88017aa6dd00 RDI: ffff88017aa6dcf8                                                                                                                                
  9 [    4.678992] RBP: ffff88017aa6dc70 R08: ffff88017aa3c9e8 R09: 0000000000000000                                                                                                                                
 10 [    4.678993] R10: 0000000000002172 R11: ffffffff812a6ae7 R12: 0000000000000000                                                                                                                                
 11 [    4.678995] R13: ffffffff81cb9ae0 R14: ffffffff812c0df0 R15: 0000000000000000                                                                                                                                
 12 [    4.678997] FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000                                                                                                                     
 13 [    4.678999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                                                
 14 [    4.679000] CR2: ffff88017ffff000 CR3: 0000000001c0b000 CR4: 00000000001007f0                                                                                                                                
 15 [    4.679001] Stack:                                                                                                                                                                                           
 16 [    4.679005]  ffff88017aa6dce8 ffffffff8109ac29 ffffffff81e9ec04 ffffffff81e9ebe0                                                                                                                             
 17 [    4.679007]  0000000000000000 0000000000000000 0000000000000000 0000000000000000                                                                                                                             
 18 [    4.679010]  0000000000000000 ffffffff8119ed6c ffff88017ab90001 ffff88017aa6dd3c                                                                                                                             
 19 [    4.679013] Call Trace:                                                                                                                                                                                      
 20 [    4.679025]  [<ffffffff8109ac29>] smp_call_function_single+0x149/0x190                                                                                                                                       
 21 [    4.679032]  [<ffffffff8119ed6c>] ? __sysfs_add_one+0x6c/0x110                                                                                                                                               
 22 [    4.679037]  [<ffffffff812c0fb9>] rdmsr_on_cpu+0x49/0x60                                                                                                                                                     
 23 [    4.679046]  [<ffffffff814fa01b>] sys_get_curr_temp+0x2b/0x60                                                                                                                                                
 24 [    4.679052]  [<ffffffff814f7a8c>] thermal_zone_get_temp+0x3c/0x60                                                                                                                                            
 25 [    4.679057]  [<ffffffff814f7b47>] thermal_zone_device_update+0x17/0xa0                                                                                                                                       
 26 [    4.679061]  [<ffffffff814f91c1>] thermal_zone_device_register+0x781/0xaa0                                                                                                                                   
 27 [    4.679064]  [<ffffffff814fa7f5>] get_core_online+0x285/0x350                                                                                                                                                
 28 [    4.679075]  [<ffffffff81d19d73>] pkg_temp_thermal_init+0x6d/0x15c                                                                                                                                           
 29 [    4.679078]  [<ffffffff81d19d06>] ? thermal_init+0xa2/0xa2                                                                                                                                                   
 30 [    4.679083]  [<ffffffff81cdae92>] do_one_initcall+0x7f/0x108                                                                                                                                                 
 31 [    4.679089]  [<ffffffff81066338>] ? parse_args+0x1e8/0x320                                                                                                                                                   
 32 [    4.679093]  [<ffffffff81cdb075>] kernel_init_freeable+0x15a/0x1db                                                                                                                                           
 33 [    4.679096]  [<ffffffff81cda836>] ? do_early_param+0x88/0x88                                                                                                                                                 
 34 [    4.679102]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 35 [    4.679104]  [<ffffffff81765d79>] kernel_init+0x9/0x180                                                                                                                                                      
 36 [    4.679112]  [<ffffffff81777e2c>] ret_from_fork+0x7c/0xb0                                                                                                                                                    
 37 [    4.679115]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 38 [    4.679152] Code: 90 90 48 8b 47 10 55 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 89 e5 48 85 c0 74 0e 48 63 d2 48 89 c6 48 03 34 d5 e0 93 cb 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 48 09 c2 89 16 48 c1 ea 20 89 56     04 5d                                                                                                                                                                                                          
 39 [    4.679155] RIP  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                                               
 40 [    4.679156]  RSP <ffff88017aa6dc70>                                                                                                                                                                          
 41 [    4.679171] ---[ end trace 540c9227357f4c3a ]---                                                                                                                                                             
 42 [    4.679209] swapper/0 (1) used greatest stack depth: 4784 bytes left                                                                                                                                         
 43 [    4.679225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b              Hi,


I get this crash on next as of today ..


[    4.678947] general protection fault: 0000 [#1] SMP                                                                                                                                                          
  2 [    4.678953] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-next-20130710 #57                                                                                                                               
  3 [    4.678959] Hardware name: Intel Corp. Mohan Peak/Server, BIOS EDVLCRB1.86B.0017.R00.1305271414 05/27/2013                                                                                                   
  4 [    4.678963] task: ffff88017aa80000 ti: ffff88017aa6c000 task.ti: ffff88017aa6c000                                                                                                                            
  5 [    4.678985] RIP: 0010:[<ffffffff812c0e19>]  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                    
  6 [    4.678987] RSP: 0000:ffff88017aa6dc70  EFLAGS: 00010046                                                                                                                                                     
  7 [    4.678989] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000000000001b1                                                                                                                                
  8 [    4.678990] RDX: 0000000000000000 RSI: ffff88017aa6dd00 RDI: ffff88017aa6dcf8                                                                                                                                
  9 [    4.678992] RBP: ffff88017aa6dc70 R08: ffff88017aa3c9e8 R09: 0000000000000000                                                                                                                                
 10 [    4.678993] R10: 0000000000002172 R11: ffffffff812a6ae7 R12: 0000000000000000                                                                                                                                
 11 [    4.678995] R13: ffffffff81cb9ae0 R14: ffffffff812c0df0 R15: 0000000000000000                                                                                                                                
 12 [    4.678997] FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000                                                                                                                     
 13 [    4.678999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                                                
 14 [    4.679000] CR2: ffff88017ffff000 CR3: 0000000001c0b000 CR4: 00000000001007f0                                                                                                                                
 15 [    4.679001] Stack:                                                                                                                                                                                           
 16 [    4.679005]  ffff88017aa6dce8 ffffffff8109ac29 ffffffff81e9ec04 ffffffff81e9ebe0                                                                                                                             
 17 [    4.679007]  0000000000000000 0000000000000000 0000000000000000 0000000000000000                                                                                                                             
 18 [    4.679010]  0000000000000000 ffffffff8119ed6c ffff88017ab90001 ffff88017aa6dd3c                                                                                                                             
 19 [    4.679013] Call Trace:                                                                                                                                                                                      
 20 [    4.679025]  [<ffffffff8109ac29>] smp_call_function_single+0x149/0x190                                                                                                                                       
 21 [    4.679032]  [<ffffffff8119ed6c>] ? __sysfs_add_one+0x6c/0x110                                                                                                                                               
 22 [    4.679037]  [<ffffffff812c0fb9>] rdmsr_on_cpu+0x49/0x60                                                                                                                                                     
 23 [    4.679046]  [<ffffffff814fa01b>] sys_get_curr_temp+0x2b/0x60                                                                                                                                                
 24 [    4.679052]  [<ffffffff814f7a8c>] thermal_zone_get_temp+0x3c/0x60                                                                                                                                            
 25 [    4.679057]  [<ffffffff814f7b47>] thermal_zone_device_update+0x17/0xa0                                                                                                                                       
 26 [    4.679061]  [<ffffffff814f91c1>] thermal_zone_device_register+0x781/0xaa0                                                                                                                                   
 27 [    4.679064]  [<ffffffff814fa7f5>] get_core_online+0x285/0x350                                                                                                                                                
 28 [    4.679075]  [<ffffffff81d19d73>] pkg_temp_thermal_init+0x6d/0x15c                                                                                                                                           
 29 [    4.679078]  [<ffffffff81d19d06>] ? thermal_init+0xa2/0xa2                                                                                                                                                   
 30 [    4.679083]  [<ffffffff81cdae92>] do_one_initcall+0x7f/0x108                                                                                                                                                 
 31 [    4.679089]  [<ffffffff81066338>] ? parse_args+0x1e8/0x320                                                                                                                                                   
 32 [    4.679093]  [<ffffffff81cdb075>] kernel_init_freeable+0x15a/0x1db                                                                                                                                           
 33 [    4.679096]  [<ffffffff81cda836>] ? do_early_param+0x88/0x88                                                                                                                                                 
 34 [    4.679102]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 35 [    4.679104]  [<ffffffff81765d79>] kernel_init+0x9/0x180                                                                                                                                                      
 36 [    4.679112]  [<ffffffff81777e2c>] ret_from_fork+0x7c/0xb0                                                                                                                                                    
 37 [    4.679115]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 38 [    4.679152] Code: 90 90 48 8b 47 10 55 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 89 e5 48 85 c0 74 0e 48 63 d2 48 89 c6 48 03 34 d5 e0 93 cb 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 48 09 c2 89 16 48 c1 ea 20 89 56     04 5d                                                                                                                                                                                                          
 39 [    4.679155] RIP  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                                               
 40 [    4.679156]  RSP <ffff88017aa6dc70>                                                                                                                                                                          
 41 [    4.679171] ---[ end trace 540c9227357f4c3a ]---                                                                                                                                                             
 42 [    4.679209] swapper/0 (1) used greatest stack depth: 4784 bytes left                                                                                                                                         
 43 [    4.679225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b              Hi,


I get this crash on next as of today ..


[    4.678947] general protection fault: 0000 [#1] SMP                                                                                                                                                          
  2 [    4.678953] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-next-20130710 #57                                                                                                                               
  3 [    4.678959] Hardware name: Intel Corp. Mohan Peak/Server, BIOS EDVLCRB1.86B.0017.R00.1305271414 05/27/2013                                                                                                   
  4 [    4.678963] task: ffff88017aa80000 ti: ffff88017aa6c000 task.ti: ffff88017aa6c000                                                                                                                            
  5 [    4.678985] RIP: 0010:[<ffffffff812c0e19>]  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                    
  6 [    4.678987] RSP: 0000:ffff88017aa6dc70  EFLAGS: 00010046                                                                                                                                                     
  7 [    4.678989] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000000000001b1                                                                                                                                
  8 [    4.678990] RDX: 0000000000000000 RSI: ffff88017aa6dd00 RDI: ffff88017aa6dcf8                                                                                                                                
  9 [    4.678992] RBP: ffff88017aa6dc70 R08: ffff88017aa3c9e8 R09: 0000000000000000                                                                                                                                
 10 [    4.678993] R10: 0000000000002172 R11: ffffffff812a6ae7 R12: 0000000000000000                                                                                                                                
 11 [    4.678995] R13: ffffffff81cb9ae0 R14: ffffffff812c0df0 R15: 0000000000000000                                                                                                                                
 12 [    4.678997] FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000                                                                                                                     
 13 [    4.678999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                                                
 14 [    4.679000] CR2: ffff88017ffff000 CR3: 0000000001c0b000 CR4: 00000000001007f0                                                                                                                                
 15 [    4.679001] Stack:                                                                                                                                                                                           
 16 [    4.679005]  ffff88017aa6dce8 ffffffff8109ac29 ffffffff81e9ec04 ffffffff81e9ebe0                                                                                                                             
 17 [    4.679007]  0000000000000000 0000000000000000 0000000000000000 0000000000000000                                                                                                                             
 18 [    4.679010]  0000000000000000 ffffffff8119ed6c ffff88017ab90001 ffff88017aa6dd3c                                                                                                                             
 19 [    4.679013] Call Trace:                                                                                                                                                                                      
 20 [    4.679025]  [<ffffffff8109ac29>] smp_call_function_single+0x149/0x190                                                                                                                                       
 21 [    4.679032]  [<ffffffff8119ed6c>] ? __sysfs_add_one+0x6c/0x110                                                                                                                                               
 22 [    4.679037]  [<ffffffff812c0fb9>] rdmsr_on_cpu+0x49/0x60                                                                                                                                                     
 23 [    4.679046]  [<ffffffff814fa01b>] sys_get_curr_temp+0x2b/0x60                                                                                                                                                
 24 [    4.679052]  [<ffffffff814f7a8c>] thermal_zone_get_temp+0x3c/0x60                                                                                                                                            
 25 [    4.679057]  [<ffffffff814f7b47>] thermal_zone_device_update+0x17/0xa0                                                                                                                                       
 26 [    4.679061]  [<ffffffff814f91c1>] thermal_zone_device_register+0x781/0xaa0                                                                                                                                   
 27 [    4.679064]  [<ffffffff814fa7f5>] get_core_online+0x285/0x350                                                                                                                                                
 28 [    4.679075]  [<ffffffff81d19d73>] pkg_temp_thermal_init+0x6d/0x15c                                                                                                                                           
 29 [    4.679078]  [<ffffffff81d19d06>] ? thermal_init+0xa2/0xa2                                                                                                                                                   
 30 [    4.679083]  [<ffffffff81cdae92>] do_one_initcall+0x7f/0x108                                                                                                                                                 
 31 [    4.679089]  [<ffffffff81066338>] ? parse_args+0x1e8/0x320                                                                                                                                                   
 32 [    4.679093]  [<ffffffff81cdb075>] kernel_init_freeable+0x15a/0x1db                                                                                                                                           
 33 [    4.679096]  [<ffffffff81cda836>] ? do_early_param+0x88/0x88                                                                                                                                                 
 34 [    4.679102]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 35 [    4.679104]  [<ffffffff81765d79>] kernel_init+0x9/0x180                                                                                                                                                      
 36 [    4.679112]  [<ffffffff81777e2c>] ret_from_fork+0x7c/0xb0                                                                                                                                                    
 37 [    4.679115]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 38 [    4.679152] Code: 90 90 48 8b 47 10 55 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 89 e5 48 85 c0 74 0e 48 63 d2 48 89 c6 48 03 34 d5 e0 93 cb 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 48 09 c2 89 16 48 c1 ea 20 89 56     04 5d                                                                                                                                                                                                          
 39 [    4.679155] RIP  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                                               
 40 [    4.679156]  RSP <ffff88017aa6dc70>                                                                                                                                                                          
 41 [    4.679171] ---[ end trace 540c9227357f4c3a ]---                                                                                                                                                             
 42 [    4.679209] swapper/0 (1) used greatest stack depth: 4784 bytes left                                                                                                                                         
 43 [    4.679225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b              Hi,


I get this crash on next as of today ..


[    4.678947] general protection fault: 0000 [#1] SMP                                                                                                                                                          
  2 [    4.678953] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-next-20130710 #57                                                                                                                               
  3 [    4.678959] Hardware name: Intel Corp. Mohan Peak/Server, BIOS EDVLCRB1.86B.0017.R00.1305271414 05/27/2013                                                                                                   
  4 [    4.678963] task: ffff88017aa80000 ti: ffff88017aa6c000 task.ti: ffff88017aa6c000                                                                                                                            
  5 [    4.678985] RIP: 0010:[<ffffffff812c0e19>]  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                    
  6 [    4.678987] RSP: 0000:ffff88017aa6dc70  EFLAGS: 00010046                                                                                                                                                     
  7 [    4.678989] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000000000001b1                                                                                                                                
  8 [    4.678990] RDX: 0000000000000000 RSI: ffff88017aa6dd00 RDI: ffff88017aa6dcf8                                                                                                                                
  9 [    4.678992] RBP: ffff88017aa6dc70 R08: ffff88017aa3c9e8 R09: 0000000000000000                                                                                                                                
 10 [    4.678993] R10: 0000000000002172 R11: ffffffff812a6ae7 R12: 0000000000000000                                                                                                                                
 11 [    4.678995] R13: ffffffff81cb9ae0 R14: ffffffff812c0df0 R15: 0000000000000000                                                                                                                                
 12 [    4.678997] FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000                                                                                                                     
 13 [    4.678999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                                                
 14 [    4.679000] CR2: ffff88017ffff000 CR3: 0000000001c0b000 CR4: 00000000001007f0                                                                                                                                
 15 [    4.679001] Stack:                                                                                                                                                                                           
 16 [    4.679005]  ffff88017aa6dce8 ffffffff8109ac29 ffffffff81e9ec04 ffffffff81e9ebe0                                                                                                                             
 17 [    4.679007]  0000000000000000 0000000000000000 0000000000000000 0000000000000000                                                                                                                             
 18 [    4.679010]  0000000000000000 ffffffff8119ed6c ffff88017ab90001 ffff88017aa6dd3c                                                                                                                             
 19 [    4.679013] Call Trace:                                                                                                                                                                                      
 20 [    4.679025]  [<ffffffff8109ac29>] smp_call_function_single+0x149/0x190                                                                                                                                       
 21 [    4.679032]  [<ffffffff8119ed6c>] ? __sysfs_add_one+0x6c/0x110                                                                                                                                               
 22 [    4.679037]  [<ffffffff812c0fb9>] rdmsr_on_cpu+0x49/0x60                                                                                                                                                     
 23 [    4.679046]  [<ffffffff814fa01b>] sys_get_curr_temp+0x2b/0x60                                                                                                                                                
 24 [    4.679052]  [<ffffffff814f7a8c>] thermal_zone_get_temp+0x3c/0x60                                                                                                                                            
 25 [    4.679057]  [<ffffffff814f7b47>] thermal_zone_device_update+0x17/0xa0                                                                                                                                       
 26 [    4.679061]  [<ffffffff814f91c1>] thermal_zone_device_register+0x781/0xaa0                                                                                                                                   
 27 [    4.679064]  [<ffffffff814fa7f5>] get_core_online+0x285/0x350                                                                                                                                                
 28 [    4.679075]  [<ffffffff81d19d73>] pkg_temp_thermal_init+0x6d/0x15c                                                                                                                                           
 29 [    4.679078]  [<ffffffff81d19d06>] ? thermal_init+0xa2/0xa2                                                                                                                                                   
 30 [    4.679083]  [<ffffffff81cdae92>] do_one_initcall+0x7f/0x108                                                                                                                                                 
 31 [    4.679089]  [<ffffffff81066338>] ? parse_args+0x1e8/0x320                                                                                                                                                   
 32 [    4.679093]  [<ffffffff81cdb075>] kernel_init_freeable+0x15a/0x1db                                                                                                                                           
 33 [    4.679096]  [<ffffffff81cda836>] ? do_early_param+0x88/0x88                                                                                                                                                 
 34 [    4.679102]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 35 [    4.679104]  [<ffffffff81765d79>] kernel_init+0x9/0x180                                                                                                                                                      
 36 [    4.679112]  [<ffffffff81777e2c>] ret_from_fork+0x7c/0xb0                                                                                                                                                    
 37 [    4.679115]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 38 [    4.679152] Code: 90 90 48 8b 47 10 55 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 89 e5 48 85 c0 74 0e 48 63 d2 48 89 c6 48 03 34 d5 e0 93 cb 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 48 09 c2 89 16 48 c1 ea 20 89 56     04 5d                                                                                                                                                                                                          
 39 [    4.679155] RIP  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                                               
 40 [    4.679156]  RSP <ffff88017aa6dc70>                                                                                                                                                                          
 41 [    4.679171] ---[ end trace 540c9227357f4c3a ]---                                                                                                                                                             
 42 [    4.679209] swapper/0 (1) used greatest stack depth: 4784 bytes left                                                                                                                                         
 43 [    4.679225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b             ao
n fault: 0000 [#1] SMP                                                                                                                                                          
  2 [    4.678953] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-next-20130710 #57                                                                                                                               
  3 [    4.678959] Hardware name: Intel Corp. Mohan Peak/Server, BIOS EDVLCRB1.86B.0017.R00.1305271414 05/27/2013                                                                                                   
  4 [    4.678963] task: ffff88017aa80000 ti: ffff88017aa6c000 task.ti: ffff88017aa6c000                                                                                                                            
  5 [    4.678985] RIP: 0010:[<ffffffff812c0e19>]  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                    
  6 [    4.678987] RSP: 0000:ffff88017aa6dc70  EFLAGS: 00010046                                                                                                                                                     
  7 [    4.678989] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000000000001b1                                                                                                                                
  8 [    4.678990] RDX: 0000000000000000 RSI: ffff88017aa6dd00 RDI: ffff88017aa6dcf8                                                                                                                                
  9 [    4.678992] RBP: ffff88017aa6dc70 R08: ffff88017aa3c9e8 R09: 0000000000000000                                                                                                                                
 10 [    4.678993] R10: 0000000000002172 R11: ffffffff812a6ae7 R12: 0000000000000000                                                                                                                                
 11 [    4.678995] R13: ffffffff81cb9ae0 R14: ffffffff812c0df0 R15: 0000000000000000                                                                                                                                
 12 [    4.678997] FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000                                                                                                                     
 13 [    4.678999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                                                
 14 [    4.679000] CR2: ffff88017ffff000 CR3: 0000000001c0b000 CR4: 00000000001007f0                                                                                                                                
 15 [    4.679001] Stack:                                                                                                                                                                                           
 16 [    4.679005]  ffff88017aa6dce8 ffffffff8109ac29 ffffffff81e9ec04 ffffffff81e9ebe0                                                                                                                             
 17 [    4.679007]  0000000000000000 0000000000000000 0000000000000000 0000000000000000                                                                                                                             
 18 [    4.679010]  0000000000000000 ffffffff8119ed6c ffff88017ab90001 ffff88017aa6dd3c                                                                                                                             
 19 [    4.679013] Call Trace:                                                                                                                                                                                      
 20 [    4.679025]  [<ffffffff8109ac29>] smp_call_function_single+0x149/0x190                                                                                                                                       
 21 [    4.679032]  [<ffffffff8119ed6c>] ? __sysfs_add_one+0x6c/0x110                                                                                                                                               
 22 [    4.679037]  [<ffffffff812c0fb9>] rdmsr_on_cpu+0x49/0x60                                                                                                                                                     
 23 [    4.679046]  [<ffffffff814fa01b>] sys_get_curr_temp+0x2b/0x60                                                                                                                                                
 24 [    4.679052]  [<ffffffff814f7a8c>] thermal_zone_get_temp+0x3c/0x60                                                                                                                                            
 25 [    4.679057]  [<ffffffff814f7b47>] thermal_zone_device_update+0x17/0xa0                                                                                                                                       
 26 [    4.679061]  [<ffffffff814f91c1>] thermal_zone_device_register+0x781/0xaa0                                                                                                                                   
 27 [    4.679064]  [<ffffffff814fa7f5>] get_core_online+0x285/0x350                                                                                                                                                
 28 [    4.679075]  [<ffffffff81d19d73>] pkg_temp_thermal_init+0x6d/0x15c                                                                                                                                           
 29 [    4.679078]  [<ffffffff81d19d06>] ? thermal_init+0xa2/0xa2                                                                                                                                                   
 30 [    4.679083]  [<ffffffff81cdae92>] do_one_initcall+0x7f/0x108                                                                                                                                                 
 31 [    4.679089]  [<ffffffff81066338>] ? parse_args+0x1e8/0x320                                                                                                                                                   
 32 [    4.679093]  [<ffffffff81cdb075>] kernel_init_freeable+0x15a/0x1db                                                                                                                                           
 33 [    4.679096]  [<ffffffff81cda836>] ? do_early_param+0x88/0x88                                                                                                                                                 
 34 [    4.679102]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 35 [    4.679104]  [<ffffffff81765d79>] kernel_init+0x9/0x180                                                                                                                                                      
 36 [    4.679112]  [<ffffffff81777e2c>] ret_from_fork+0x7c/0xb0                                                                                                                                                    
 37 [    4.679115]  [<ffffffff81765d70>] ? rest_init+0x80/0x80                                                                                                                                                      
 38 [    4.679152] Code: 90 90 48 8b 47 10 55 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 89 e5 48 85 c0 74 0e 48 63 d2 48 89 c6 48 03 34 d5 e0 93 cb 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 48 09 c2 89 16 48 c1 ea 20 89 56     04 5d                                                                                                                                                                                                          
 39 [    4.679155] RIP  [<ffffffff812c0e19>] __rdmsr_on_cpu+0x29/0x40                                                                                                                                               
 40 [    4.679156]  RSP <ffff88017aa6dc70>                                                                                                                                                                          
 41 [    4.679171] ---[ end trace 540c9227357f4c3a ]---                                                                                                                                                             
 42 [    4.679209] swapper/0 (1) used greatest stack depth: 4784 bytes left                                                                                                                                         
 43 [    4.679225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b              
