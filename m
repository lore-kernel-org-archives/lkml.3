Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3FNMss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:48:48 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54897 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3FNMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:48:47 -0400
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Fri, 14 Jun 2013 15:49:01 +0300
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000040
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: nirinA raseliarison <nirina.raseliarison@gmail.com>
Message-ID: <op.wyn5vzc89ey1ta@localhost>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello there,
i have this ethernet controler:

  Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast  
Ethernet controller (rev 05)

that uses the r8169 module.
it works fine, but sometimes after a reboot and issueing:

  ifconfig eth0 192.168.1.1 up

i got the message below. after another reboot the
message disappears. i also get the same message this 3.9.5 and 3.9.4.

it seems i catch my first oops and don't know what to do with it.
currently running:

  cat /proc/version
  Linux version 3.9.6.20130614 (root@supernova) (gcc version 4.8.1 (GCC) )  
#1 SMP Fri Jun 14 09:14:50 EAT 2013

  uname -a
  Linux supernova 3.9.6.20130614 #1 SMP Fri Jun 14 09:14:50 EAT 2013 x86_64  
Intel(R) Celeron(R) CPU G1610 @ 2.60GHz GenuineIntel GNU/Linux

thanks,
-----------------8<------------------------------8<---------------------------------------

[   57.877560] BUG: unable to handle kernel NULL pointer dereference at  
0000000000000040
[   57.877603] IP: [<ffffffff81491844>] fw_load_abort.isra.5+0x4/0x20
[   57.877634] PGD 21330a067 PUD 211a3a067 PMD 0
[   57.877660] Oops: 0002 [#1] SMP
[   57.877681] Modules linked in: fuse coretemp kvm_intel kvm evdev r8169  
microcode mii
[   57.877735] CPU 0
[   57.877746] Pid: 1950, comm: firmware Not tainted 3.9.6.20130614 #1 To  
be filled by O.E.M. To be filled by O.E.M./ONDA H61V Ver:4.01
[   57.877790] RIP: 0010:[<ffffffff81491844>]  [<ffffffff81491844>]  
fw_load_abort.isra.5+0x4/0x20
[   57.877824] RSP: 0018:ffff8802119a7e80  EFLAGS: 00010246
[   57.877844] RAX: ffff8802158fe250 RBX: ffff880211a03b40 RCX:  
0000000000000000
[   57.877869] RDX: ffffffff81c742c8 RSI: ffff8802158fe250 RDI:  
0000000000000000
[   57.877895] RBP: ffff8802119a7e80 R08: ffff8802119a6000 R09:  
00000000000005aa
[   57.877920] R10: 0000000000000000 R11: 0000000000000000 R12:  
ffffffffffffffff
[   57.877945] R13: ffff880213d34088 R14: 0000000000000003 R15:  
ffff88020eafc230
[   57.877970] FS:  00007f3c6cb2a740(0000) GS:ffff88021f200000(0000)  
knlGS:0000000000000000
[   57.877998] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.878019] CR2: 0000000000000040 CR3: 0000000203155000 CR4:  
00000000001407f0
[   57.878044] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
0000000000000000
[   57.878069] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
0000000000000400
[   57.878094] Process firmware (pid: 1950, threadinfo ffff8802119a6000,  
task ffff8802158fe250)
[   57.878124] Stack:
[   57.878133]  ffff8802119a7eb0 ffffffff81491917 ffff880211a4d5a0  
0000000000000003
[   57.878168]  ffff8802119a7f50 ffffffff818765a0 ffff8802119a7ec0  
ffffffff81483063
[   57.878203]  ffff8802119a7f08 ffffffff8119bc9e ffff880213d34098  
ffff880211a4d5c0
[   57.878237] Call Trace:
[   57.878251]  [<ffffffff81491917>] firmware_loading_store+0x77/0x150
[   57.878275]  [<ffffffff81483063>] dev_attr_store+0x13/0x20
[   57.878297]  [<ffffffff8119bc9e>] sysfs_write_file+0xce/0x140
[   57.878320]  [<ffffffff81133e8a>] vfs_write+0x9a/0x160
[   57.878340]  [<ffffffff81134164>] sys_write+0x44/0x90
[   57.878360]  [<ffffffff817d70ed>] system_call_fastpath+0x1a/0x1f
[   57.879379] Code: 6b ff ff ff 48 89 df 31 db e8 b9 b0 c9 ff e9 79 ff ff  
ff 0f 1f 40 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 00 55 48 89 e5  
<f0> 80 4f 40 04 48 83 c7 18 e8 8e a9 bd ff 5d c3 66 66 66 2e 0f
[   57.881753] RIP  [<ffffffff81491844>] fw_load_abort.isra.5+0x4/0x20
[   57.882888]  RSP <ffff8802119a7e80>
[   57.884019] CR2: 0000000000000040
[   57.885166] ---[ end trace 6705f6d4ce6b6a12 ]---

-- 
nirinA
