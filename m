Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaKSCTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:19:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbaKSCTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:19:18 -0500
Date: Tue, 18 Nov 2014 21:19:02 -0500
From: Dave Jones <davej@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119021902.GA14216@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118215540.GD35311@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:55:40PM -0500, Don Zickus wrote:
 
 > Can you provide another dump?  The hope is we get something not mangled?
 
Ok, here's another instance.
This time around, we got all 4 cpu traces.

NMI watchdog: BUG: soft lockup - CPU#2 stuck for 21s! [trinity-c42:31480]
CPU: 2 PID: 31480 Comm: trinity-c42 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
task: ffff88023fda4680 ti: ffff880101ee0000 task.ti: ffff880101ee0000
RIP: 0010:[<ffffffff8a1798b4>]  [<ffffffff8a1798b4>] context_tracking_user_enter+0xa4/0x190
RSP: 0018:ffff880101ee3f00  EFLAGS: 00000282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8802445d1258
RDX: 0000000000000001 RSI: ffffffff8aac2c64 RDI: ffffffff8aa94505
RBP: ffff880101ee3f10 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880101ee3ec0
R13: ffffffff8a38c577 R14: ffff880101ee3e70 R15: ffffffff8aa9ee99
FS:  00007f706c089740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001bf67f000 CR4: 00000000001407e0
DR0: 00007f0b19510000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff880101ee3f58 00007f706bcd0000 ffff880101ee3f40 ffffffff8a012fc5
 0000000000000000 0000000000007c1b 00007f706bcd0000 00007f706bcd0068
 0000000000000000 ffffffff8a7d8624 000000001008feff 0000000000000000
Call Trace:
 [<ffffffff8a012fc5>] syscall_trace_leave+0xa5/0x160
 [<ffffffff8a7d8624>] int_check_syscall_exit_work+0x34/0x3d
Code: 75 4d 48 c7 c7 64 2c ac 8a e8 e9 2c 21 00 65 c7 04 25 54 f7 1c 00 01 00 00 00 41 f7 c4 00 02 00 00 74 1c e8 8f 44 fd ff 41 54 9d <5b> 41 5c 5d c3 0f 1f 80 00 00 00 00 f3 c3 66 0f 1f 44 00 00 41 
sending NMI to other CPUs:
NMI backtrace for cpu 0
CPU: 0 PID: 27716 Comm: kworker/0:1 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
Workqueue: events nohz_kick_work_fn
task: ffff88017c358000 ti: ffff8801d7124000 task.ti: ffff8801d7124000
RIP: 0010:[<ffffffff8a0ffb52>]  [<ffffffff8a0ffb52>] smp_call_function_many+0x1b2/0x320
RSP: 0018:ffff8801d7127cb8  EFLAGS: 00000202
RAX: 0000000000000002 RBX: ffff8802441d4dc0 RCX: 0000000000000038
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff8802445d84e8
RBP: ffff8801d7127d08 R08: ffff880243c3aa80 R09: 0000000000000000
R10: ffff880243c3aa80 R11: 0000000000000000 R12: ffffffff8a0fa2c0
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f70688ff000 CR3: 000000000ac11000 CR4: 00000000001407f0
DR0: 00007f0b19510000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff8801d7127d28 0000000000000246 00000000d7127ce8 00000000001d4d80
 ffff880206b99780 ffff88017f6ccc30 ffff8802441d3640 ffff8802441d9e00
 ffffffff8ac4e340 0000000000000000 ffff8801d7127d18 ffffffff8a0fa3f5
Call Trace:
 [<ffffffff8a0fa3f5>] tick_nohz_full_kick_all+0x35/0x70
 [<ffffffff8a0ec8fe>] nohz_kick_work_fn+0xe/0x10
 [<ffffffff8a08e61d>] process_one_work+0x1fd/0x590
 [<ffffffff8a08e597>] ? process_one_work+0x177/0x590
 [<ffffffff8a0c112e>] ? put_lock_stats.isra.23+0xe/0x30
 [<ffffffff8a08eacb>] worker_thread+0x11b/0x490
 [<ffffffff8a08e9b0>] ? process_one_work+0x590/0x590
 [<ffffffff8a0942e9>] kthread+0xf9/0x110
 [<ffffffff8a0c112e>] ? put_lock_stats.isra.23+0xe/0x30
 [<ffffffff8a0941f0>] ? kthread_create_on_node+0x250/0x250
 [<ffffffff8a7d82ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8a0941f0>] ? kthread_create_on_node+0x250/0x250
Code: a5 c1 00 49 89 c7 41 89 c6 7d 7e 49 63 c7 48 8b 3b 48 03 3c c5 e0 6b d1 8a 0f b7 57 18 f6 c2 01 74 12 0f 1f 80 00 00 00 00 f3 90 <0f> b7 57 18 f6 c2 01 75 f5 83 ca 01 66 89 57 18 0f ae f0 48 8b 
NMI backtrace for cpu 1
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 34.478 msecs
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 10/411 32140]
task: ffff880242b5de00 ti: ffff880242b64000 task.ti: ffff880242b64000
RIP: 0010:[<ffffffff8a3e14a5>]  [<ffffffff8a3e14a5>] intel_idle+0xd5/0x180
RSP: 0018:ffff880242b67df8  EFLAGS: 00000046
RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880242b67fd8 RDI: 0000000000000001
RBP: ffff880242b67e28 R08: 000000008baf93be R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b64000
FS:  0000000000000000(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcd3a34d000 CR3: 000000000ac11000 CR4: 00000000001407e0
DR0: 00007f0b19510000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000142b67e28 84d4d6ff01c7f4fd ffffe8ffff002200 0000000000000005
 ffffffff8acaa080 0000000000000001 ffff880242b67e78 ffffffff8a666075
 000011f1e9f6e882 ffffffff8acaa250 ffff880242b64000 ffffffff8ad18f30
Call Trace:
 [<ffffffff8a666075>] cpuidle_enter_state+0x55/0x1c0
 [<ffffffff8a666297>] cpuidle_enter+0x17/0x20
 [<ffffffff8a0bb323>] cpu_startup_entry+0x433/0x4e0
 [<ffffffff8a02b763>] start_secondary+0x1a3/0x220
Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
NMI backtrace for cpu 3
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 62.461 msecs
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 10/411 32140]
task: ffff880242b5c680 ti: ffff880242b78000 task.ti: ffff880242b78000
RIP: 0010:[<ffffffff8a3e14a5>]  [<ffffffff8a3e14a5>] intel_idle+0xd5/0x180
RSP: 0018:ffff880242b7bdf8  EFLAGS: 00000046
RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880242b7bfd8 RDI: ffffffff8ac11000
RBP: ffff880242b7be28 R08: 000000008baf93be R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b78000
FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000ac11000 CR4: 00000000001407e0
DR0: 00007f0b19510000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000342b7be28 43db433bbd06c740 ffffe8ffff402200 0000000000000005
 ffffffff8acaa080 0000000000000003 ffff880242b7be78 ffffffff8a666075
 000011f1d69aaf37 ffffffff8acaa250 ffff880242b78000 ffffffff8ad18f30
Call Trace:
 [<ffffffff8a666075>] cpuidle_enter_state+0x55/0x1c0
 [<ffffffff8a666297>] cpuidle_enter+0x17/0x20
 [<ffffffff8a0bb323>] cpu_startup_entry+0x433/0x4e0
 [<ffffffff8a02b763>] start_secondary+0x1a3/0x220
Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 89.635 msecs

