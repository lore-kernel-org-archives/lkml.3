Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaB1PFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:05:21 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37823 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaB1PFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:05:19 -0500
Date: Fri, 28 Feb 2014 10:07:29 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <20140228092341.12a40f7c@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net> <530C12CA.6070308@zytor.com>
 <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
 <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Steven Rostedt wrote:

> Interesting. Are you doing a perf function trace?
> 
> And just in case, can you add this patch and make sure the copy is
> called by NMI.

199.900682: function:             trace_do_page_fault
199.900683: page_fault_user:      address=__per_cpu_end ip=__per_cpu_end error_code=0x6
199.900683: function:             perf_swevent_get_recursion_context
199.900684: function:             perf_tp_event
199.900684: function:                perf_swevent_event
199.900684: function:                   perf_swevent_overflow
199.900684: function:                      __perf_event_overflow
199.900685: function:                         perf_prepare_sample
199.900685: function:                            __perf_event_header__init_id
199.900685: function:                               task_tgid_nr_ns
199.900685: function:                               perf_event_tid
199.900686: function:                                  __task_pid_nr_ns
199.900686: function:                            perf_callchain
199.900687: function:             copy_from_user_nmi
199.900687: function:             trace_do_page_fault
199.900687: page_fault_kernel:    address=irq_stack_union ip=copy_user_generic_string error_code=0x0
199.900688: function:                __do_page_fault
199.900688: function:                   bad_area_nosemaphore
199.900688: function:                      __bad_area_nosemaphore
199.900689: function:                         no_context
199.900689: function:                            fixup_exception
199.900689: function:                               search_exception_tables
199.900689: function:                                  search_extable
199.900691: function:             copy_user_handle_tail
199.900691: function:             trace_do_page_fault
199.900691: page_fault_kernel:    address=irq_stack_union ip=copy_user_handle_tail error_code=0x0
199.900691: function:                __do_page_fault
199.900692: function:                   bad_area_nosemaphore
199.900692: function:                      __bad_area_nosemaphore
199.900692: function:                         no_context
199.900692: function:                            fixup_exception
199.900692: function:                               search_exception_tables
199.900692: function:                                  search_extable
199.900693: function:             save_stack_trace
199.900693: function:                dump_trace
199.900694: function:                   print_context_stack
199.900694: function:                      __kernel_text_address
199.900694: function:                         is_module_text_address
199.900695: function:                            __module_text_address
199.900695: function:                               __module_address
199.900695: function:                      __kernel_text_address
199.900695: function:                         is_module_text_address
199.900696: function:                            __module_text_address
199.900696: function:                               __module_address
...
199.900705: function:                      __kernel_text_address
199.900809: kernel_stack:         <stack trace>
=> perf_callchain (ffffffff810d35a2)
=> perf_prepare_sample (ffffffff810cfae3)
=> __perf_event_overflow (ffffffff810d02f4)
=> perf_swevent_overflow (ffffffff810d04e3)
=> perf_swevent_event (ffffffff810d0574)
=> perf_tp_event (ffffffff810d070c)
=> perf_trace_x86_exceptions (ffffffff810341b6)
=> trace_do_page_fault (ffffffff81537702)
=> trace_page_fault (ffffffff81534772)
199.900810: function:             perf_output_begin
199.900810: function:             __do_page_fault
199.900810: function:                __perf_sw_event
199.900810: function:                   perf_swevent_get_recursion_context
199.900811: function:                down_read_trylock
199.900811: function:                _cond_resched
199.900811: function:                find_vma
199.900811: function:                bad_area
199.900812: function:                   up_read
199.900812: function:                   __bad_area_nosemaphore
199.900812: function:                      is_prefetch
199.900812: function:                         convert_ip_to_linear
199.900813: function:                      unhandled_signal
199.900813: function:                      __printk_ratelimit
199.900813: function:             _raw_spin_trylock
199.900813: function:             _raw_spin_unlock_irqrestore
199.900814: function:                      printk
199.900814: function:                         vprintk_emit

