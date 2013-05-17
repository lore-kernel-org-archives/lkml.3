Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3EQRcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:32:19 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43059 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3EQRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:32:18 -0400
MIME-Version: 1.0
X-Originating-IP: [77.185.175.205]
Date: Fri, 17 May 2013 19:32:17 +0200
X-Google-Sender-Auth: 109LEHhWUyAQScgBXLxq2WDoSD0
Message-ID: <CAL9nN6cf7=-mkwazcWS-=Yvqcw8xRwoOS4=POqd5CLDHqgKU5A@mail.gmail.com>
Subject: Urgent help required "kernel tried to execute NX-protected page -
 exploit attempt?"
From: Erik Nijkamp <erik.nijkamp@testobject.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

we are running into some serious issues with our dedicated servers.

Here's the setup:

    Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
    Linux Ubuntu-1204-precise-64-minimal 3.2.0-41-generic #66-Ubuntu
SMP Thu Apr 25 03:27:11 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

We are running x-servers on multiple dedicated machines with GPU
acceleration enabled. The x-server is used to boot up 32 Android
emulators.

After some hours the kernel crashes with the following log. We
understand the underlying basics (the emulator or an associated module
tried to execute an area of memory marked as not executable).

Any advice how to proceed? Any help would be highly appreciated!

May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511575]
kernel tried to execute NX-protected page - exploit attempt? (uid:
999)
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511625]
BUG: unable to handle kernel paging request at ffff88028d155ab8
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511669]
IP: [] 0xffff88028d155ab7
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511704]
PGD 1c06063 PUD cdc46067 PMD 800000028d0001e3
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511742]
Oops: 0011 [#1] SMP
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511766] CPU 4
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.511780]
Modules linked in: ip6table_filter ip6_tables i915 drm_kms_helper drm
i2c_algo_bit ipt_MASQUERADE xt_state ipt_REJECT xt_CHECKSUM
iptable_mangle iptable_filter ipt_REDIRECT xt_tcpudp iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
x_tables bridge stp kvm_intel kvm bnep rfcomm bluetooth eeepc_wmi
asus_wmi sparse_keymap video mac_hid wmi serio_raw mei(C) lp parport
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx raid1 raid0 multipath linear r8169 btrfs
zlib_deflate libcrc32c
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512176]
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512189]
Pid: 2404, comm: emulator64-arm- Tainted: G C 3.2.0-41-generic
#66-Ubuntu System manufacturer System Product Name/P8H77-M PRO
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512267]
RIP: 0010:[] [] 0xffff88028d155ab7
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512313]
RSP: 0018:ffff88028d155a28 EFLAGS: 00210246
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512343]
RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000000
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512379]
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88028d072900
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512436]
RBP: ffff88028d155f28 R08: ffff88040a9a5908 R09: ffff880302a05000
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512481]
R10: ffff88028d155908 R11: 0000000000000000 R12: 000000000000000a
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512524]
R13: 0000000000000400 R14: 00000000003c8400 R15: ffff88028d072900
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512564]
FS: 00007f3b271b1740(0000) GS:ffff88081fb00000(0000)
knlGS:0000000000000000
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512612]
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.512627]
CR2: ffff88028d155ab8 CR3: 000000028d0e3000 CR4: 00000000001406e0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.513235]
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.514484]
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.515279]
Process emulator64-arm- (pid: 2404, threadinfo ffff88028d154000, task
ffff88030288dc00)
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.516331] Stack:
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.517201]
0000000001200286 ffff88028d155d28 ffff88028d155dd0 ffff88028d155dc8
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.517804]
ffff88028d155dc0 ffff88028d155ea8 ffff88028d155db8 ffff88028d155db0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.519144]
ffff88028d155da8 0000000000000000 0000000000000000 0000000000000000
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.520416]
Call Trace:
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.522081]
[] ? poll_freewait+0xe0/0xe0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.522978]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.524317]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.525602]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.526733]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.527958]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.529261]
[] ? __pollwait+0xf0/0xf0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.530565]
[] ? enqueue_hrtimer+0x39/0xc0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.531576]
[] ? __hrtimer_start_range_ns+0x169/0x3a0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.532336]
[] ? __sigqueue_free+0x3d/0x50
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.533568]
[] ? core_sys_select+0x1ec/0x370
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.534895]
[] ? set_current_blocked+0x52/0x70
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.535953]
[] ? handle_signal+0xc0/0x190
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.537273]
[] ? check_for_xstate+0x3b/0xc0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.538680]
[] ? restore_user_xstate+0x54/0xa0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.540297]
[] ? read_tsc+0x9/0x20
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.541286]
[] ? ktime_get_ts+0xad/0xe0
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.541928]
[] ? sys_select+0xc0/0x100
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.542956]
[] ? system_call_fastpath+0x16/0x1b
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.544241]
Code: 00 00 00 00 00 00 00 00 00 00 00 00 84 3c 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 00 00 00 c8
18 81 ff ff ff ff db 00 00 00 00 00 00 00 00 00 00 00 00
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.546808]
RIP [] 0xffff88028d155ab7
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.547846] RSP
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.548692]
CR2: ffff88028d155ab8
May 17 10:12:10 Ubuntu-1204-precise-64-minimal kernel: [165670.552675]
---[ end trace 26ab579e528fd5f5 ]---

Best regards
  Erik Nijkamp
