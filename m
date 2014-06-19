Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbaFSQKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:10:18 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57758 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbaFSQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:10:16 -0400
Message-ID: <53A30B63.107@brockmann-consult.de>
Date: Thu, 19 Jun 2014 18:10:11 +0200
From: Peter Maloney <peter.maloney@brockmann-consult.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG - handle_mm_fault - Ubuntu 14.04 kernel 3.13.0-29-generic
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:3ihIEIOEcYwj2VRtlB5NHDiu+u0VqJE3RyxhDfnkCTG
 H2BSNP54ouNFdwx9HXwLyggP7i0ignLEBnbXGO01gwW3BXM70T
 nKr5wpCPhEHLTxIhmkNJOKo3wwYxAQzm9MakZdYhOOQNR6CNuw
 q6NFeCTLgh65VmUcdG3Wn983ecUUF24aZx6KDEC2aZbzml+5Qb
 oc52tOoGVXZ57AXoVFjMLorf3Hwvu8EWZxbwqif+kKeyKl6Eks
 WEEbI+CKH+n8LjWH0NWwD6ER5nIJCqQ9aHJYL2FQfM34MUMxWO
 GhlC4mBp3hklKVN3rQzZOKRvFWzCiW6gPPAxuhJf9fPVdPYcrh
 qLMYkv8mdyoJl2QB87CFaedEB14PLD7nBNEWIjnVZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, can someone please take a look at this and tell me what is going on?

The event log reports no ECC errors.

This machine was working fine with an older Ubuntu version, and has
failed this way twice since an upgrade 2 weeks ago.

Symptoms include:
 - load goes up high, currently 1872.72
 - "ps -ef" hangs
 - this time I tested "echo w > /proc/sysrq-trigger" which made the
local shell and ssh hang, and ctrl+alt+del doesn't work, but machine
still responds to ping

Please CC me; I'm not on the list.

Thanks,
Peter



Here's the log:

Jun 12 15:42:42 node73 kernel: [17196.908781] ------------[ cut here
]------------
Jun 12 15:42:42 node73 kernel: [17196.909789] kernel BUG at
/build/buildd/linux-3.13.0/mm/memory.c:3756!
Jun 12 15:42:42 node73 kernel: [17196.911210] invalid opcode: 0000 [#1] SMP
Jun 12 15:42:42 node73 kernel: [17196.912130] Modules linked in: nfsd
auth_rpcgss nfs_acl nfs lockd sunrpc fscache gpio_ich intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_inte
l kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac joydev
edac_core ioatdma mei_me mei lpc_ich wmi ipmi_si mac
_hid lp parport raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq raid1 igb hid_generic mpt2sas
i2c_algo_bit raid0 raid_class usbhid dca multipath ptp sc
si_transport_sas ahci hid libahci linear pps_core
Jun 12 15:42:42 node73 kernel: [17196.924647] CPU: 5 PID: 25935 Comm:
java Not tainted 3.13.0-29-generic #53-Ubuntu
Jun 12 15:42:42 node73 kernel: [17196.926280] Hardware name: Supermicro
X9DRFF-iG+/-7G+/-iTG+/-7TG+/X9DRFF-iG+/-7G+/-iTG+/-7TG+, BIOS 2.0a
04/30/2013
Jun 12 15:42:42 node73 kernel: [17196.928566] task: ffff880c4a795fc0 ti:
ffff880ce7d96000 task.ti: ffff880ce7d96000
Jun 12 15:42:42 node73 kernel: [17196.930200] RIP:
0010:[<ffffffff81179521>]  [<ffffffff81179521>] handle_mm_fault+0xe61/0xf10
Jun 12 15:42:42 node73 kernel: [17196.932066] RSP:
0018:ffff880ce7d97d98  EFLAGS: 00010246
Jun 12 15:42:42 node73 kernel: [17196.933217] RAX: 0000000000000100 RBX:
000000078ddfdc38 RCX: ffff880ce7d97b00
Jun 12 15:42:42 node73 kernel: [17196.934773] RDX: ffff880c4a795fc0 RSI:
0000000000000000 RDI: 80000001a82009e6
Jun 12 15:42:42 node73 kernel: [17196.936328] RBP: ffff880ce7d97e20 R08:
0000000000000000 R09: 00000000000000a9
Jun 12 15:42:42 node73 kernel: [17196.937884] R10: 0000000000000001 R11:
0000000000000000 R12: ffff880dee484370
Jun 12 15:42:42 node73 kernel: [17196.939440] R13: ffff881e0c4d3d40 R14:
ffff88102511c280 R15: 0000000000000080
Jun 12 15:42:42 node73 kernel: [17196.940996] FS: 
00007f2529340700(0000) GS:ffff88103fca0000(0000) knlGS:0000000000000000
Jun 12 15:42:42 node73 kernel: [17196.979078] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jun 12 15:42:42 node73 kernel: [17197.017222] CR2: 0000000718184000 CR3:
0000001021ae8000 CR4: 00000000000407e0
Jun 12 15:42:42 node73 kernel: [17197.056416] Stack:
Jun 12 15:42:42 node73 kernel: [17197.094614]  0000000000000001
ffff880ce7d97db0 ffffffff8109a790 ffff880ce7d97dd0
Jun 12 15:42:42 node73 kernel: [17197.171848]  ffffffff810d7b56
0000000000000001 ffffffff81f1fed0 ffff880ce7d97e78
Jun 12 15:42:42 node73 kernel: [17197.249793]  ffffffff810d996d
ffff880ce7d97e48 00000000000000a9 00000001ffffffff
Jun 12 15:42:42 node73 kernel: [17197.327660] Call Trace:
Jun 12 15:42:42 node73 kernel: [17197.365233]  [<ffffffff8109a790>] ?
wake_up_state+0x10/0x20
Jun 12 15:42:42 node73 kernel: [17197.403036]  [<ffffffff810d7b56>] ?
wake_futex+0x66/0x90
Jun 12 15:42:42 node73 kernel: [17197.439822]  [<ffffffff810d996d>] ?
futex_wake_op+0x4ed/0x620
Jun 12 15:42:42 node73 kernel: [17197.475937]  [<ffffffff81726164>]
__do_page_fault+0x184/0x560
Jun 12 15:42:42 node73 kernel: [17197.511226]  [<ffffffff8111140c>] ?
acct_account_cputime+0x1c/0x20
Jun 12 15:42:42 node73 kernel: [17197.546109]  [<ffffffff8109d77b>] ?
account_user_time+0x8b/0xa0
Jun 12 15:42:42 node73 kernel: [17197.580167]  [<ffffffff8109dd94>] ?
vtime_account_user+0x54/0x60
Jun 12 15:42:42 node73 kernel: [17197.613381]  [<ffffffff8172655a>]
do_page_fault+0x1a/0x70
Jun 12 15:42:42 node73 kernel: [17197.645771]  [<ffffffff817229c8>]
page_fault+0x28/0x30
Jun 12 15:42:42 node73 kernel: [17197.677251] Code: ff 48 89 d9 4c 89 e2
4c 89 ee 4c 89 f7 44 89 4d c8 e8 34 c1 ff ff 85 c0 0f 85 94 f5 ff ff 49
8b 3c 24 44 8b 4d c8 e9 68 f3 ff ff <0f> 0b be 8e 00 00 00 48 c7 c7 c0
3c a6 81 44 89 4d c8 e8 48 e2
Jun 12 15:42:42 node73 kernel: [17197.772738] RIP  [<ffffffff81179521>]
handle_mm_fault+0xe61/0xf10
Jun 12 15:42:42 node73 kernel: [17197.804166]  RSP <ffff880ce7d97d98>
Jun 12 15:42:42 node73 kernel: [17197.881409] ---[ end trace
b093101191f33d70 ]---
Jun 12 17:15:21 node73 kernel: [22748.792239] ------------[ cut here
]------------

