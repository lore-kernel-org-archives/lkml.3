Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbaALNuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:50:08 -0500
Received: from plane.gmane.org ([80.91.229.3]:48061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALNuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:50:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Juha Luoma <jsluoma@kolumbus.fi>
Subject: Re: Watchdog detected hard LOCKUP on cpu 0 on FITPC2
Date: Sun, 12 Jan 2014 15:47:08 +0200
Message-ID: <lau6cg$r36$1@ger.gmane.org>
References: <52BF3CB2.5020703@openmailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-156-22-32.elisa-laajakaista.fi
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0 SeaMonkey/2.23
In-Reply-To: <52BF3CB2.5020703@openmailbox.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Beller wrote:
> I noticed a machine to hang after a few days of uptime,
> i.e. the USB, networking etc are all gone, but the machine is still up
> and displaying the login screen.
>
> I am running
> 	$ uname -a
> Linux sd 3.12.5-302.fc20.i686 #1 SMP Tue Dec 17 21:01:18 UTC 2013 i686 i686 i386 GNU/Linux

I use a system that has a bit similar symptoms. That system still 
answers to ping but I can't login any more. When I was still able to 
access the system remotely, I was able to collect some data and reported 
it here:
https://bugzilla.redhat.com/show_bug.cgi?id=1051626

[282818.373615] INFO: rcu_sched self-detected stall on CPU
[282818.373616] INFO: rcu_sched self-detected stall on CPU
[282818.373617] INFO: rcu_sched self-detected stall on CPU
[282818.373617] INFO: rcu_sched self-detected stall on CPU
[282818.373618]  {
[282818.373618]  {
[282818.373620]  {
[282818.373620]  4
[282818.373621]  1
[282818.373621]  2
[282818.373622] }
[282818.373622] }
[282818.373623]  (t=2400039 jiffies g=288243 c=288242 q=200719)
[282818.373623]  (t=2400039 jiffies g=288243 c=288242 q=200719)
[282818.373624] }  (t=2400039 jiffies g=288243 c=288242 q=200719)
[282818.373624] sending NMI to all CPUs:
[282818.373626] NMI backtrace for cpu 4
[282818.373627] CPU: 4 PID: 1203 Comm: java Not tainted 
3.12.6-300.fc20.x86_64 #1
[282818.373628] Hardware name: Dell Inc. OptiPlex 9020/0PC5F7, BIOS A02 
08/15/2013
[282818.373628] task: ffff8807e33ea940 ti: ffff8807ef640000 task.ti: 
ffff8807ef640000
[282818.373633] RIP: 0010:[<ffffffff81312474>]  [<ffffffff81312474>] 
__bitmap_andnot+0x24/0x50
[282818.373633] RSP: 0018:ffff88081eb03d78  EFLAGS: 00000016
[282818.373634] RAX: 0000000000000000 RBX: 00000000000000ff RCX: 
0000000000000004
[282818.373634] RDX: ffff88081ea0df80 RSI: ffff88081eb0df00 RDI: 
ffff88081eb0df00
[282818.373635] RBP: ffff88081eb03d78 R08: 0000000000000000 R09: 
0000000000000010
[282818.373636] R10: 0000000000013f5c R11: 0000000000040000 R12: 
ffff88081eb0df00
[282818.373636] R13: 000000000000e000 R14: ffff88081ea0df80 R15: 
0000000000080000
[282818.373637] FS:  00007f420eded700(0000) GS:ffff88081eb00000(0000) 
knlGS:0000000000000000
[282818.373638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[282818.373638] CR2: 00007f4f39dcd7b8 CR3: 00000007f1b94000 CR4: 
00000000001407e0
[282818.373639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[282818.373639] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[282818.373640] Stack:
[282818.373642]  ffff88081eb03dd8 ffffffff81047c65 0000000000000096 
000000021eb03de8
[282818.373643]  000000000000df80 0000000000000004 0000000000000004 
0000000000002710
[282818.373645]  ffffffff81c53bc0 ffffffff81c53bc0 ffff88081eb0ef60 
000000000003100f
[282818.373645] Call Trace:
[282818.373646]  <IRQ>
[282818.373649]  [<ffffffff81047c65>] __x2apic_send_IPI_mask+0x1c5/0x1f0
[282818.373650]  [<ffffffff81047cac>] x2apic_send_IPI_all+0x1c/0x20
[282818.373653]  [<ffffffff81043627>] 
arch_trigger_all_cpu_backtrace+0x57/0x90
[282818.373655]  [<ffffffff81103aad>] rcu_check_callbacks+0x31d/0x600
[282818.373658]  [<ffffffff81076d77>] update_process_times+0x47/0x80
[282818.373661]  [<ffffffff810caca5>] tick_sched_handle.isra.15+0x25/0x60
[282818.373663]  [<ffffffff810cad21>] tick_sched_timer+0x41/0x60
[282818.373665]  [<ffffffff8108e704>] __run_hrtimer+0x74/0x1d0
[282818.373666]  [<ffffffff810cace0>] ? tick_sched_handle.isra.15+0x60/0x60
[282818.373668]  [<ffffffff8108ef17>] hrtimer_interrupt+0xf7/0x240
[282818.373670]  [<ffffffff810419f7>] local_apic_timer_interrupt+0x37/0x60
[282818.373672]  [<ffffffff8167437f>] smp_apic_timer_interrupt+0x3f/0x60
[282818.373673]  [<ffffffff81672d1d>] apic_timer_interrupt+0x6d/0x80
[282818.373674]  <EOI>
[282818.373676]  [<ffffffff81669b0d>] ? _raw_spin_lock+0x2d/0x40
[282818.373677]  [<ffffffff810cd098>] futex_wait+0xe8/0x290
[282818.373680]  [<ffffffff811a019e>] ? lookup_page_cgroup_used+0xe/0x30
[282818.373682]  [<ffffffff8108e440>] ? hrtimer_get_res+0x50/0x50
[282818.373683]  [<ffffffff8108ed34>] ? hrtimer_start_range_ns+0x14/0x20
[282818.373684]  [<ffffffff810cec96>] do_futex+0xe6/0xc30
[282818.373687]  [<ffffffff810a18fc>] ? update_curr+0xcc/0x160
[282818.373689]  [<ffffffff81011611>] ? __switch_to+0x181/0x4b0
[282818.373690]  [<ffffffff810cf851>] SyS_futex+0x71/0x150
[282818.373691]  [<ffffffff81672129>] system_call_fastpath+0x16/0x1b
[282818.373705] Code: 1f 84 00 00 00 00 00 48 63 c9 55 48 83 c1 3f 48 c1 
e9 06 48 89 e5 85 c9 7e 32 41 89 c9 45 31 c0 31 c9 0f 1f 44 00 00 48 8b 
04 ca <48> f7 d0 48 23 04 ce 48 89 04 cf 48 83 c1 01 49 09 c0 41 39 c9

  - Juha

