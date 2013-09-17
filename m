Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3IQVIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:08:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3IQVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:08:16 -0400
Date: Tue, 17 Sep 2013 17:15:27 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf-related lockup on 3.11
In-Reply-To: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1309171710130.15599@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Vince Weaver wrote:

> 
> I got this hard lockup running my perf_fuzzer on 3.11 on a core2.
> I guess I should try to reproduce it on linus-git but was hoping
> I could wait until -rc1 before trying that.

OK, I can also lock up 3.12-rc1 using the perf_fuzzer.  Last message
logged is below.

The system won't respond, even to sysrq (well, the serial port equiv)
and then after a while alarming file system/disk warnings start popping
up presumably because interrupts aren't working anymore.

[ 1173.553545] perf samples too long (2501 > 2500), lowering kernel.perf_event_max_sample_rate to 50000                                            
[ 1173.556002] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 2.464 msecs                                                                     
[ 1314.102904] hrtimer: interrupt took 3787 ns                                  
[ 1351.896018] ------------[ cut here ]------------                             
[ 1351.896018] WARNING: CPU: 0 PID: 3718 at kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()                                                        
[ 1351.896018] Watchdog detected hard LOCKUP on cpu 0                           
[ 1351.896018] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev pcspkr ohci_pci psmouse mcs7830 serio_raw usbnet ohci_hcd coretemp i2c_nforce2 video wmi acpi_cpufreq button processor thermal_sys sg ehci_pci sd_mod ehci_hcd usbcore usb_common                       
[ 1351.896018] CPU: 0 PID: 3718 Comm: perf_fuzzer Not tainted 3.12.0-rc1 #1     
[ 1351.896018] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012                                                            
[ 1351.896018]  00000000000000f5 ffff88011fc07c48 ffffffff8151a026 ffff88011fc07c58
[ 1351.896018]  ffffffff8103cd58 ffffffff817fa8e9 ffffffff810a0e6c ffff88011b313400
[ 1351.896018]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc07ca8
[ 1351.896018] Call Trace:                                                      
[ 1351.896018]  <NMI>  [<ffffffff8151a026>] ? dump_stack+0x41/0x53              
[ 1351.896018]  [<ffffffff8103cd58>] ? warn_slowpath_common+0x81/0x9c           
[ 1351.896018]  [<ffffffff810a0e6c>] ? watchdog_overflow_callback+0x9b/0xa6     
[ 1351.896018]  [<ffffffff8103ce15>] ? warn_slowpath_fmt+0x46/0x48              
[ 1351.896018]  [<ffffffff810a0dda>] ? watchdog_overflow_callback+0x9/0xa6      
[ 1351.896018]  [<ffffffff810a0e6c>] ? watchdog_overflow_callback+0x9b/0xa6     
[ 1351.896018]  [<ffffffff810ca0eb>] ? __perf_event_overflow+0x12e/0x1ab        
[ 1351.896018]  [<ffffffff8101806f>] ? intel_pmu_save_and_restart+0xe/0x22      
[ 1351.896018]  [<ffffffff81018cbd>] ? intel_pmu_handle_irq+0x2b8/0x34d         
[ 1351.896018]  [<ffffffff81523e7c>] ? ftrace_call+0x5/0x2f                     
[ 1351.896018]  [<ffffffff810a7d02>] ? ftrace_ops_test+0x40/0x78                
[ 1351.896018]  [<ffffffff8151e9b3>] ? perf_event_nmi_handler+0x24/0x3d         
[ 1351.896018]  [<ffffffff8151e2f2>] ? nmi_handle+0x5e/0x13a                    
[ 1351.896018]  [<ffffffff810a1610>] ? rcu_nmi_enter+0x9/0x5b                   
[ 1351.896018]  [<ffffffff8151e475>] ? do_nmi+0xa7/0x2bd                        
[ 1351.896018]  [<ffffffff8111f1d7>] ? send_sigio_to_task+0xc6/0xf5             
[ 1351.896018]  [<ffffffff8151da77>] ? end_repeat_nmi+0x1e/0x2e                 
[ 1351.896018]  [<ffffffff8111f1d7>] ? send_sigio_to_task+0xc6/0xf5             
[ 1351.896018]  [<ffffffff8104b023>] ? do_send_sig_info+0xf/0x75                
[ 1351.896018]  [<ffffffff8104b023>] ? do_send_sig_info+0xf/0x75                
[ 1351.896018]  [<ffffffff810a7d02>] ? ftrace_ops_test+0x40/0x78                
[ 1351.896018]  [<ffffffff810a7d02>] ? ftrace_ops_test+0x40/0x78                
[ 1351.896018]  [<ffffffff810a7d02>] ? ftrace_ops_test+0x40/0x78                
[ 1351.896018]  <<EOE>>  <IRQ>  [<ffffffff8104b023>] ? do_send_sig_info+0xf/0x75
[ 1351.896018]  [<ffffffff810a8d1c>] ? ftrace_ops_control_func+0x88/0xc8        
[ 1351.896018]  [<ffffffff810a8d2e>] ? ftrace_ops_control_func+0x9a/0xc8        
[ 1351.896018]  [<ffffffff81523e7c>] ? ftrace_call+0x5/0x2f                     
[ 1351.896018]  [<ffffffff8111f11d>] ? send_sigio_to_task+0xc/0xf5              
[ 1351.896018]  [<ffffffff810a8d2e>] ? ftrace_ops_control_func+0x9a/0xc8        
[ 1351.896018]  [<ffffffff8104b028>] ? do_send_sig_info+0x14/0x75               
[ 1351.896018]  [<ffffffff810a2904>] ? rcu_irq_enter+0xd/0x75                   
[ 1351.896018]  [<ffffffff8104b028>] ? do_send_sig_info+0x14/0x75               
[ 1351.896018]  [<ffffffff8111f1d7>] ? send_sigio_to_task+0xc6/0xf5             
[ 1351.896018]  [<ffffffff8151d164>] ? _raw_spin_lock_irqsave+0x4/0x2d          
[ 1351.896018]  [<ffffffff810a2904>] ? rcu_irq_enter+0xd/0x75                   
[ 1351.896018]  [<ffffffff8151cf82>] ? _raw_read_lock+0x9/0x15                  
[ 1351.896018]  [<ffffffff8111f21c>] ? send_sigio+0x16/0xdd                     
[ 1351.896018]  [<ffffffff8111f2b0>] ? send_sigio+0xaa/0xdd                     
[ 1351.896018]  [<ffffffff8151d169>] ? _raw_spin_lock_irqsave+0x9/0x2d          
[ 1351.896018]  [<ffffffff8111f34c>] ? kill_fasync+0x69/0x86                    
[ 1351.896018]  [<ffffffff810ca850>] ? perf_event_wakeup+0x8c/0xa1              
[ 1351.896018]  [<ffffffff810c472b>] ? __irq_work_run+0x5f/0x7b                 
[ 1351.896018]  [<ffffffff81005f82>] ? smp_trace_irq_work_interrupt+0x4b/0x7e   
[ 1351.896018]  [<ffffffff8152578a>] ? trace_irq_work_interrupt+0x6a/0x70       
[ 1351.896018]  [<ffffffff810a1930>] ? __note_gp_changes+0xc/0x54               
[ 1351.896018]  [<ffffffff8151cf57>] ? _raw_spin_unlock_irqrestore+0xf/0x11     
[ 1351.896018]  [<ffffffff810a347b>] ? rcu_process_callbacks+0xb7/0x4b8         
[ 1351.896018]  [<ffffffff810408f2>] ? perf_trace_softirq+0x38/0x96             
[ 1351.896018]  [<ffffffff81040f76>] ? __do_softirq+0x102/0x208                 
[ 1351.896018]  [<ffffffff810410f5>] ? irq_exit+0x45/0xa1                       
[ 1351.896018]  [<ffffffff81525fd4>] ? smp_trace_apic_timer_interrupt+0x83/0x91 
[ 1351.896018]  [<ffffffff810c7c58>] ? perf_event_task_output+0x117/0x117       
[ 1351.896018]  [<ffffffff81524f3a>] ? trace_apic_timer_interrupt+0x6a/0x70     
[ 1351.896018]  <EOI>  [<ffffffff8108c2b6>] ? smp_call_function_single+0x8c/0x101
[ 1351.896018]  [<ffffffff810a8d2e>] ? ftrace_ops_control_func+0x9a/0xc8        
[ 1351.896018]  [<ffffffff810c7cd3>] ? task_function_call+0x42/0x4c             
[ 1351.896018]  [<ffffffff810c77f1>] ? __perf_event_task_sched_in+0x108/0x108   
[ 1351.896018]  [<ffffffff810c81cb>] ? perf_event_enable+0xf7/0x12e             
[ 1351.896018]  [<ffffffff810c5a4a>] ? perf_event_task_enable+0x57/0x6c         
[ 1351.896018]  [<ffffffff8151bfea>] ? _cond_resched+0x9/0x37                   
[ 1351.896018]  [<ffffffff8151a511>] ? mutex_lock+0x16/0x37                     
[ 1351.896018]  [<ffffffff810c80d4>] ? perf_install_in_context+0xb8/0xb8        
[ 1351.896018]  [<ffffffff810c5955>] ? perf_event_for_each_child+0x56/0x88      
[ 1351.896018]  [<ffffffff810c5a4a>] ? perf_event_task_enable+0x57/0x6c         
[ 1351.896018]  [<ffffffff810c5a32>] ? perf_event_task_enable+0x3f/0x6c         
[ 1351.896018]  [<ffffffff8104eb20>] ? SyS_prctl+0x151/0x341                    
[ 1351.896018]  [<ffffffff8100cefe>] ? syscall_trace_leave+0x52/0xba            
[ 1351.896018]  [<ffffffff815243c1>] ? tracesys+0xd4/0xd9                       
[ 1351.896018] ---[ end trace dea2e0afc6629577 ]---                             

