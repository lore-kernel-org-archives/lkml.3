Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaDPRkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:40:36 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:53177 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaDPRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:40:34 -0400
Date: Wed, 16 Apr 2014 13:43:49 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <20140416141514.GS11182@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Vince Weaver wrote:

> On Wed, 16 Apr 2014, Peter Zijlstra wrote:
> 
> > Does the below make any difference? I've only ran it through some light
> > testing to make sure it didn't insta-explode on running.
> > 
> > (perf stat make -j64 -s in fact)
> 
> I'm running with your patch now and so far so good.

spoke too soon, just got this with your patch applied
(I wasn't running ftrace so no trace with this one):

[ 1555.756490] Slab corruption (Not tainted): kmalloc-2048 start=ffff88011879a000, len=2048
[ 1555.765699] 040: 6b 6b 6b 6b 6b 6b 6b 6b 88 a7 97 ce 00 88 ff ff  kkkkkkkk........
[ 1555.774684] Next obj: start=ffff88011879a800, len=2048
[ 1555.780396] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1555.789150] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1556.048915] Slab corruption (Not tainted): kmalloc-2048 start=ffff88011879a000, len=2048
[ 1556.057655] 040: 6b 6b 6b 6b 6b 6b 6b 6b 40 30 04 18 01 88 ff ff  kkkkkkkk@0......
[ 1556.065946] Next obj: start=ffff88011879a800, len=2048
[ 1556.071544] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1556.079770] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1556.150121] general protection fault: 0000 [#1] SMP
[ 1556.155467] Dumping ftrace buffer:
[ 1556.159051]    (ftrace buffer empty)
[ 1556.162848] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi coretemp kvm i915 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic aesni_intel aes_x86_64 drm_kms_helper lrw snd_hda_intel snd_hda_controller snd_hda_codec drm snd_hwdep gf128mul tpm_tis mei_me snd_pcm glue_helper tpm evdev mei parport_pc snd_seq ablk_helper iTCO_wdt i2c_algo_bit psmouse iTCO_vendor_support parport snd_timer cryptd serio_raw pcspkr lpc_ich i2c_i801 mfd_core battery button processor video wmi i2c_core snd_seq_device snd soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci ehci_pci e1000e libata ptp ehci_hcd xhci_hcd crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[ 1556.236213] CPU: 4 PID: 28 Comm: ksoftirqd/4 Not tainted 3.15.0-rc1+ #62     
[ 1556.243169] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 1556.251114] task: ffff8801188f8890 ti: ffff8801188fa000 task.ti: ffff8801188fa000
[ 1556.259065] RIP: 0010:[<ffffffff8113884d>]  [<ffffffff8113884d>] perf_tp_event+0x9d/0x210
[ 1556.267821] RSP: 0000:ffff8801188fba30  EFLAGS: 00010006                     
[ 1556.273479] RAX: ffff88011879a040 RBX: 6b6b6b6b6b6b6b2b RCX: 000000000000002c
[ 1556.281000] RDX: ffffe8ffffd01878 RSI: 0000000000000001 RDI: 0000000000000000
[ 1556.288543] RBP: ffff8801188fbb08 R08: ffff8801188fbb30 R09: ffffe8ffffd03098
[ 1556.296068] R10: 0000000000000001 R11: 0000000225c17d03 R12: ffff8800cebde4d0
[ 1556.303619] R13: 0000000000000001 R14: ffff8801188fbb30 R15: ffffe8ffffd01878
[ 1556.311197] FS:  0000000000000000(0000) GS:ffff88011eb00000(0000) knlGS:0000000000000000
[ 1556.320659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1556.327681] CR2: 0000000000618b50 CR3: 0000000001c11000 CR4: 00000000001407e0
[ 1556.336092] DR0: 0000000000a9e000 DR1: 0000000000000000 DR2: 0000000000a9e000
[ 1556.344624] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 1556.353012] Stack:
[ 1556.356024]  ffff8801188f8890 ffffffff81c48380 ffffffff0000002c ffffe8ffffd01878
[ 1556.364798]  ffff8801188fba88 0000000000000046 0000000000000000 0000000000000004
[ 1556.373689]  0000000000000000 ffff8801188fbb78 ffff88011eb10420 ffff8801188fbb68
[ 1556.382627] Call Trace:
[ 1556.386190]  [<ffffffff81093607>] perf_trace_sched_wakeup_template+0xe7/0x100
[ 1556.394778]  [<ffffffff810953f2>] ? ttwu_do_wakeup+0xb2/0xc0                 
[ 1556.401703]  [<ffffffff810953f2>] ttwu_do_wakeup+0xb2/0xc0                   
[ 1556.408468]  [<ffffffff810954ed>] ttwu_do_activate.constprop.95+0x5d/0x70    
[ 1556.416659]  [<ffffffff810982c0>] try_to_wake_up+0x200/0x300                 
[ 1556.423711]  [<ffffffff81098432>] default_wake_function+0x12/0x20            
[ 1556.431114]  [<ffffffff810a95f8>] __wake_up_common+0x58/0x90                 
[ 1556.438103]  [<ffffffff810c90c0>] ? ftrace_raw_output_rcu_utilization+0x50/0x50
[ 1556.446860]  [<ffffffff810a9643>] __wake_up_locked+0x13/0x20                 
[ 1556.453756]  [<ffffffff810a9e07>] complete+0x37/0x50                         
[ 1556.459995]  [<ffffffff810c90d2>] wakeme_after_rcu+0x12/0x20                 
[ 1556.466903]  [<ffffffff810cc6ad>] rcu_process_callbacks+0x29d/0x620          
[ 1556.474468]  [<ffffffff810cc646>] ? rcu_process_callbacks+0x236/0x620        
[ 1556.482232]  [<ffffffff81069995>] __do_softirq+0xf5/0x290                    
[ 1556.488837]  [<ffffffff81069b60>] run_ksoftirqd+0x30/0x50                    
[ 1556.495385]  [<ffffffff8108f6ff>] smpboot_thread_fn+0xff/0x1b0               
[ 1556.502441]  [<ffffffff8108f600>] ? SyS_setgroups+0x1a0/0x1a0                
[ 1556.509398]  [<ffffffff8108822d>] kthread+0xed/0x110                         
[ 1556.515486]  [<ffffffff81088140>] ? kthread_create_on_node+0x200/0x200       
[ 1556.523324]  [<ffffffff8165a4bc>] ret_from_fork+0x7c/0xb0                    
[ 1556.529858]  [<ffffffff81088140>] ? kthread_create_on_node+0x200/0x200       
[ 1556.537642] Code: 48 c7 45 c8 00 00 00 00 48 c7 45 90 00 00 00 00 48 c7 45 d0 00 00 00 00 75 11 eb 52 66 90 48 8b 5b 40 48 85 db 74 47 48 83 eb 40 <f6> 83 90 01 00 00 01 75 ea f6 83 e8 00 00 00 20 75 e1 48 8d b5                          
[ 1556.561008] RIP  [<ffffffff8113884d>] perf_tp_event+0x9d/0x210               
[ 1556.568036]  RSP <ffff8801188fba30>                                          
[ 1556.572833] general protection fault: 0000 [#2] SMP                          
[ 1556.578955] Dumping ftrace buffer:                                           
[ 1556.583342]    (ftrace buffer empty)                                         
[ 1556.587897] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi coretemp kvm i915 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic aesni_intel aes_x86_64 drm_kms_helper lrw snd_hda_intel snd_hda_controller snd_hda_codec drm snd_hwdep gf128mul tpm_tis mei_me snd_pcm glue_helper tpm evdev mei parport_pc snd_seq ablk_helper iTCO_wdt i2c_algo_bit psmouse iTCO_vendor_support parport snd_timer cryptd serio_raw pcspkr lpc_ich i2c_i801 mfd_core battery button processor video wmi i2c_core snd_seq_device snd soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci ehci_pci e1000e libata ptp ehci_hcd xhci_hcd crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys                           
[ 1556.667183] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.15.0-rc1+ #62        
[ 1556.674820] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014                                                                             
[ 1556.683519] task: ffff880118f5e350 ti: ffff880118f60000 task.ti: ffff880118f60000                                                                            
[ 1556.692431] RIP: 0010:[<ffffffff8113884d>]  [<ffffffff8113884d>] perf_tp_event+0x9d/0x210                                                                    
[ 1556.702028] RSP: 0000:ffff88011eb03af8  EFLAGS: 00010006                     
[ 1556.708553] RAX: ffff88011879a040 RBX: 6b6b6b6b6b6b6b2b RCX: 000000000000002c
[ 1556.716851] RDX: ffffe8ffffd02078 RSI: 0000000000000001 RDI: 0000000000000000
[ 1556.725272] RBP: ffff88011eb03bd0 R08: ffff88011eb03bf8 R09: ffffe8ffffd03098
[ 1556.733740] R10: 000000000000000f R11: 000000000000b717 R12: ffff8800cfb16750
[ 1556.742209] R13: 0000000000000001 R14: ffff88011eb03bf8 R15: ffffe8ffffd02078
[ 1556.750617] FS:  0000000000000000(0000) GS:ffff88011eb00000(0000) knlGS:0000000000000000                                                                     
[ 1556.760111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                
[ 1556.767040] CR2: 0000000000618b50 CR3: 0000000001c11000 CR4: 00000000001407e0
[ 1556.775451] DR0: 0000000000a9e000 DR1: 0000000000000000 DR2: 0000000000a9e000
[ 1556.783797] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 1556.792254] Stack:                                                           
[ 1556.795279]  0000000000000046 ffffffff81138fab 000000000000002c ffffe8ffffd02078                                                                             
[ 1556.804056]  0000000000000046 0000000000000046 0000000000000000 0000000000000008                                                                             
[ 1556.812825]  0000000000000000 ffff88011eb03c40 ffff88011eb10420 ffff88011eb03c30                                                                             
[ 1556.821642] Call Trace:                                                      
[ 1556.825070]  <IRQ>                                                           
[ 1556.827143]  [<ffffffff81138fab>] ? __perf_sw_event+0x6b/0x230               
[ 1556.835329]  [<ffffffff81093607>] perf_trace_sched_wakeup_template+0xe7/0x100
[ 1556.843753]  [<ffffffff810953f2>] ? ttwu_do_wakeup+0xb2/0xc0                 
[ 1556.850681]  [<ffffffff810953f2>] ttwu_do_wakeup+0xb2/0xc0                   
[ 1556.857334]  [<ffffffff810954ed>] ttwu_do_activate.constprop.95+0x5d/0x70    
[ 1556.865438]  [<ffffffff810982c0>] try_to_wake_up+0x200/0x300                 
[ 1556.872334]  [<ffffffff81098432>] default_wake_function+0x12/0x20            
[ 1556.879685]  [<ffffffff810a9d28>] autoremove_wake_function+0x18/0x40         
[ 1556.887333]  [<ffffffff810a95f8>] __wake_up_common+0x58/0x90                 
[ 1556.894223]  [<ffffffff810a9869>] __wake_up+0x39/0x50                        
[ 1556.900578]  [<ffffffff810c0f92>] wake_up_klogd_work_func+0x42/0x70          
[ 1556.908173]  [<ffffffff8112ff9f>] __irq_work_run+0x6f/0x90                   
[ 1556.914815]  [<ffffffff81130028>] irq_work_run+0x18/0x30                     
[ 1556.921277]  [<ffffffff8107272b>] update_process_times+0x5b/0x70             
[ 1556.928572]  [<ffffffff810d8665>] tick_sched_handle.isra.20+0x25/0x60        
[ 1556.936233]  [<ffffffff810d8d41>] tick_sched_timer+0x41/0x60                 
[ 1556.943021]  [<ffffffff8108b596>] __run_hrtimer+0x86/0x1e0                   
[ 1556.949681]  [<ffffffff810d8d00>] ? tick_sched_do_timer+0x40/0x40            
[ 1556.956981]  [<ffffffff8108bd87>] hrtimer_interrupt+0xf7/0x240               
[ 1556.964068]  [<ffffffff81044637>] local_apic_timer_interrupt+0x37/0x60       
[ 1556.971800]  [<ffffffff8165c996>] smp_trace_apic_timer_interrupt+0x46/0xb9   
[ 1556.979903]  [<ffffffff8165b39d>] trace_apic_timer_interrupt+0x6d/0x80       
[ 1556.987606]  <EOI>                                                           
[ 1556.989710]  [<ffffffff8165103e>] ? _raw_spin_unlock_irq+0x2e/0x40           
[ 1556.998038]  [<ffffffff81651037>] ? _raw_spin_unlock_irq+0x27/0x40           
[ 1557.005313]  [<ffffffff81090c4d>] finish_task_switch+0x7d/0x120              
[ 1557.012301]  [<ffffffff81090c0f>] ? finish_task_switch+0x3f/0x120            
[ 1557.019455]  [<ffffffff8164c6b0>] __schedule+0x2c0/0x740                     
[ 1557.025852]  [<ffffffff8164d009>] schedule_preempt_disabled+0x29/0x70        
[ 1557.033380]  [<ffffffff810aa0e3>] cpu_startup_entry+0x133/0x3d0              
[ 1557.040257]  [<ffffffff81042a43>] start_secondary+0x193/0x200                
[ 1557.047061] Code: 48 c7 45 c8 00 00 00 00 48 c7 45 90 00 00 00 00 48 c7 45 d0 00 00 00 00 75 11 eb 52 66 90 48 8b 5b 40 48 85 db 74 47 48 83 eb 40 <f6> 83 90 01 00 00 01 75 ea f6 83 e8 00 00 00 20 75 e1 48 8d b5                          
[ 1557.070211] RIP  [<ffffffff8113884d>] perf_tp_event+0x9d/0x210               
[ 1557.077114]  RSP <ffff88011eb03af8>                                          
[ 1557.081529] ---[ end trace de66fd3e04dbf8d0 ]---                             
[ 1557.087043] Kernel panic - not syncing: Fatal exception in interrupt         
[ 1558.139376] Shutting down cpus with NMI                                      
[ 1558.144092] Dumping ftrace buffer:                                           
[ 1558.148310]    (ftrace buffer empty)                                         
[ 1558.152807] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)             
