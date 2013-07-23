Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3GWSHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:07:17 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3804 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933842Ab3GWSHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:07:14 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51EEC646.7070306@broadcom.com>
Date: Tue, 23 Jul 2013 20:07:02 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: regression 3.11-rc1: rmmod hangs after tracing module
X-WSS-ID: 7DF01B892L851358198-01-01
Content-Type: multipart/mixed;
 boundary=------------070302040506090303070408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------070302040506090303070408
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

During testing of our brcmfmac wireless driver I had a trace-cmd running 
along (trace-cmd record -e brcmfmac:*). After the test I stopped the 
trace, unplugged my usb device and did a rmmod resulting in the attached 
lockdep splat. Hope you have an idea what is going wrong here.

Regards,
Arend

--------------070302040506090303070408
Content-Type: text/plain;
 name=lockdep-splat.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=lockdep-splat.log

Jul 23 16:05:00 arend-lp-dev kernel: [23055.298412] usbcore: deregistering interface driver brcmfmac
Jul 23 16:05:00 arend-lp-dev kernel: [23055.304526] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.306019] =============================================
Jul 23 16:05:00 arend-lp-dev kernel: [23055.311417] [ INFO: possible recursive locking detected ]
Jul 23 16:05:00 arend-lp-dev kernel: [23055.316812] 3.11.0-rc1-wl-testing-lockdep-00002-g41cc093-dirty #1 Tainted: G        W  O
Jul 23 16:05:00 arend-lp-dev kernel: [23055.324893] ---------------------------------------------
Jul 23 16:05:00 arend-lp-dev kernel: [23055.330289] rmmod/3345 is trying to acquire lock:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.334989]  (trace_types_lock){+.+.+.}, at: [<c10df3a0>] tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:05:00 arend-lp-dev kernel: [23055.343921] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.343921] but task is already holding lock:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.349751]  (trace_types_lock){+.+.+.}, at: [<c10ef799>] trace_module_notify+0x19/0x270
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353445] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353445] other info that might help us debug this:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353446]  Possible unsafe locking scenario:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353446] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353447]        CPU0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353448]        ----
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353450]   lock(trace_types_lock);
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353451]   lock(trace_types_lock);
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353452] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353452]  *** DEADLOCK ***
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353452] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353453]  May be due to missing lock nesting notation
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353453] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353454] 3 locks held by rmmod/3345:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353464]  #0:  ((module_notify_list).rwsem){.+.+.+}, at: [<c10683da>] __blocking_notifier_call_chain+0x2a/0x70
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353469]  #1:  (trace_types_lock){+.+.+.}, at: [<c10ef799>] trace_module_notify+0x19/0x270
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353474]  #2:  (event_mutex){+.+.+.}, at: [<c10ef7a5>] trace_module_notify+0x25/0x270
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353475] 
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353475] stack backtrace:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353479] CPU: 3 PID: 3345 Comm: rmmod Tainted: G        W  O 3.11.0-rc1-wl-testing-lockdep-00002-g41cc093-dirty #1
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353480] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353486]  00000000 00000000 e2659dd4 c1522e3d c1a3b010 e2659e50 c109ee33 c16b70b5
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353492]  e1603890 00000d11 c1a3d320 e1603a50 bc1d806f 00000003 e1603a80 00011781
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353497]  bc1d806f c18d8e00 00000000 c1a3b010 00000000 00011781 e16035a0 e16035a0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353498] Call Trace:
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353504]  [<c1522e3d>] dump_stack+0x4b/0x66
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353510]  [<c109ee33>] __lock_acquire+0x14a3/0x19d0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353515]  [<c10a0038>] ? mark_held_locks+0x68/0x110
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353518]  [<c10a0038>] ? mark_held_locks+0x68/0x110
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353522]  [<c109f8b9>] lock_acquire+0x79/0x110
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353526]  [<c10df3a0>] ? tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353531]  [<c1524b06>] mutex_lock_nested+0x66/0x350
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353535]  [<c10df3a0>] ? tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353540]  [<c113e2df>] ? kfree+0x18f/0x1a0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353543]  [<c10ef9dc>] ? trace_module_notify+0x25c/0x270
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353547]  [<c10df3a0>] tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353550]  [<c10ef9eb>] trace_module_notify+0x26b/0x270
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353555]  [<c152d655>] notifier_call_chain+0x45/0x60
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353559]  [<c10683f3>] __blocking_notifier_call_chain+0x43/0x70
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353576]  [<f8667140>] ? brcmf_usb_ctlwrite_complete+0x90/0x90 [brcmfmac]
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353580]  [<c106843f>] blocking_notifier_call_chain+0x1f/0x30
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353585]  [<c10a894e>] SyS_delete_module+0x14e/0x200
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353590]  [<c1529b46>] ? restore_all+0xf/0xf
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353593]  [<c152d600>] ? __do_page_fault+0x4d0/0x4d0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353597]  [<c10a01cc>] ? trace_hardirqs_on_caller+0xec/0x1b0
Jul 23 16:05:00 arend-lp-dev kernel: [23055.353601]  [<c1531061>] sysenter_do_call+0x12/0x32
Jul 23 16:07:12 arend-lp-dev kernel: [23187.532144] INFO: task rmmod:3345 blocked for more than 120 seconds.
Jul 23 16:07:12 arend-lp-dev kernel: [23187.538557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 23 16:07:12 arend-lp-dev kernel: [23187.546429] rmmod           D c12bbdc8     0  3345   3344 0x00000000
Jul 23 16:07:12 arend-lp-dev kernel: [23187.552900]  e2659e80 00000096 e2658000 c12bbdc8 e16035a0 f4ccc780 c1865da0 c1865da0
Jul 23 16:07:12 arend-lp-dev kernel: [23187.560839]  fe29af00 000014f7 f53d7da0 e16035a0 e15f0000 e2659e90 e16035a0 c10a007b
Jul 23 16:07:12 arend-lp-dev kernel: [23187.568781]  0000007b 000000d8 c17700e0 ffffff10 c109f8cd 00000060 00000246 00000000
Jul 23 16:07:12 arend-lp-dev kernel: [23187.576715] Call Trace:
Jul 23 16:07:12 arend-lp-dev kernel: [23187.579169]  [<c12bbdc8>] ? trace_hardirqs_on_thunk+0xc/0x10
Jul 23 16:07:12 arend-lp-dev kernel: [23187.584877]  [<c10a007b>] ? mark_held_locks+0xab/0x110
Jul 23 16:07:12 arend-lp-dev kernel: [23187.590058]  [<c109f8cd>] ? lock_acquire+0x8d/0x110
Jul 23 16:07:12 arend-lp-dev kernel: [23187.594988]  [<c10df3a0>] ? tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:07:12 arend-lp-dev kernel: [23187.601302]  [<c1527d73>] schedule+0x23/0x60
Jul 23 16:07:12 arend-lp-dev kernel: [23187.605580]  [<c1528048>] schedule_preempt_disabled+0x18/0x30
Jul 23 16:07:12 arend-lp-dev kernel: [23187.611370]  [<c1524bf5>] mutex_lock_nested+0x155/0x350
Jul 23 16:07:12 arend-lp-dev kernel: [23187.616640]  [<c10df3a0>] ? tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:07:12 arend-lp-dev kernel: [23187.622954]  [<c10df3a0>] tracing_reset_all_online_cpus+0x10/0x50
Jul 23 16:07:12 arend-lp-dev kernel: [23187.629098]  [<c10ef9eb>] trace_module_notify+0x26b/0x270
Jul 23 16:07:12 arend-lp-dev kernel: [23187.634540]  [<c152d655>] notifier_call_chain+0x45/0x60
Jul 23 16:07:12 arend-lp-dev kernel: [23187.639819]  [<c10683f3>] __blocking_notifier_call_chain+0x43/0x70
Jul 23 16:07:12 arend-lp-dev kernel: [23187.646065]  [<f8667140>] ? brcmf_usb_ctlwrite_complete+0x90/0x90 [brcmfmac]
Jul 23 16:07:12 arend-lp-dev kernel: [23187.653161]  [<c106843f>] blocking_notifier_call_chain+0x1f/0x30
Jul 23 16:07:12 arend-lp-dev kernel: [23187.659227]  [<c10a894e>] SyS_delete_module+0x14e/0x200
Jul 23 16:07:12 arend-lp-dev kernel: [23187.664508]  [<c1529b46>] ? restore_all+0xf/0xf
Jul 23 16:07:12 arend-lp-dev kernel: [23187.669093]  [<c152d600>] ? __do_page_fault+0x4d0/0x4d0
Jul 23 16:07:12 arend-lp-dev kernel: [23187.674373]  [<c10a01cc>] ? trace_hardirqs_on_caller+0xec/0x1b0
Jul 23 16:07:12 arend-lp-dev kernel: [23187.680317]  [<c1531061>] sysenter_do_call+0x12/0x32
Jul 23 16:07:12 arend-lp-dev kernel: [23187.685331] INFO: lockdep is turned off.

--------------070302040506090303070408--

