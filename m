Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHUPWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:22:31 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.157]:47482 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaHUPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:22:30 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 11:22:29 EDT
Date: Thu, 21 Aug 2014 17:05:17 +0200
From: Lampshade <lampshade@poczta.fm>
Subject: swap(((long *) &dentry->d_iname)[i], ((long *)
 &target->d_iname)[i]); kmemcheck reported read from unallocated memory
 fs/dcache.c:2440
To: linux-kernel@vger.kernel.org
X-Mailer: interia.pl/pf09
X-Originating-IP: 93.105.200.89
Message-Id: <aamxyohdimmidqusyvei@qqwv>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
At the beginning I want say clear that I am not a kernel developer and I don't \
studied anything directly related to IT so I could don't know how to properly debug 
kernel.
For some reasons (example Debian Jessie will have 3.16) I would like to stick with \
3.16.1 kernel on my laptop, so I tried to configure it. After all I wanted to test \
kernel using memory tests in kernel. Kmemcheck caught read from unallocated memory. I \
compiled two kernels with slightly different configuration and both had same issue. I \
don't have config or binary file for first kernel (but I have for second), I have only this message:

dmesg:
[  114.392483] WARNING: kmemcheck: Caught 64-bit read from unallocated memory \
(ffff880099c1e7c8) [  114.393740] \
88004000070000000000000000000000a075825e0188ffffc0c3c1990088fffffac2a6f909000000b8e7c1 \
990088ffff10fd78590188ffff71756575652e62696e00ffffffffffffffffffffffffffffffffffffffff \
ff0003000000ffffffff402b6181ffffffff00f06f590188ffffffffffffffffffff0000000000000000 \
[  114.396915]  i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i \
i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i a a a a a a \
a a a a a a a a a i i i i i a a a a i i i i i i i i i i i i i i i i a a a a a a a a i \
i i i i i i i [  114.400234]                                                          \
^ [  114.401672] RIP: 0010:[<ffffffff810d7fe2>]  [<ffffffff810d7fe2>] \
switch_names+0xd2/0x100 [  114.403107] RSP: 0018:ffff88009a023cf0  EFLAGS: 00010287
[  114.404542] RAX: ffff880099c1e840 RBX: ffff880099c1e780 RCX: 0000000000000010
[  114.405977] RDX: ffff880099c1e780 RSI: ffff880099c1e7b8 RDI: ffffffffffff0070
[  114.407407] RBP: ffff88009a023cf0 R08: ffff880099c1e878 R09: ffffffffffff006e
[  114.408823] R10: ffff880099c1e7b8 R11: ffff880099c1e840 R12: ffff880099c1e840
[  114.410227] R13: 0000000000000000 R14: ffff88015978e918 R15: ffff880099c1e780
[  114.411627] FS:  0000000000000000(0000) GS:ffffffff81820000(0000) \
knlGS:0000000000000000 [  114.413032] CS:  0010 DS: 0000 ES: 0000 CR0: \
0000000080050033 [  114.414431] CR2: ffff880159b3d130 CR3: 000000009a04a000 CR4: \
00000000000407f0 [  114.415845] DR0: 0000000000000000 DR1: 0000000000000000 DR2: \
0000000000000000 [  114.417257] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: \
0000000000000400 [  114.418647]  [<ffffffff810d8b80>] __d_move+0x1a0/0x370
[  114.420032]  [<ffffffff810da6a2>] d_move+0x12/0x20
[  114.421403]  [<ffffffff810d4037>] vfs_rename+0x637/0x670
[  114.422779]  [<ffffffff810d444f>] SyS_renameat2+0x3df/0x4a0
[  114.424152]  [<ffffffff810d4539>] SyS_rename+0x19/0x20
[  114.425514]  [<ffffffff814d6144>] tracesys+0xcf/0xd4
[  114.426849]  [<ffffffffffffffff>] 0xffffffffffffffff


bash-4.2# addr2line -e vmlinux -i ffffffff810d7fe2
/home/slack/kernel/linux-3.16.1/fs/dcache.c:2440 (discriminator 2)


for second I have config:
http://pastebin.ca/2833888

I have vmlinux with debug info:
vmlinux 86.1 MB
https://mega.co.nz/#!lx9EhDSb!7azlKwAJ9K4ictCx-07P-ky9yNSNH-iKxdQQBUoRGTM

I have /boot/vmlinuz:
vmlinuz 2.7 MB
https://mega.co.nz/#!5k9yHYxY!CiCxAAY_o-yPbg1N63cQymjRlA-764zDRhJ1oXc9Dmo

and full dmesg:
http://pastebin.ca/2833906

and cutted message:
[    4.199236] kmemcheck: Initialized

[  113.813070] WARNING: kmemcheck: Caught 64-bit read from unallocated memory \
(ffff880099ccd108) [  113.814321] \
6e00ffffffffffffffffffffffffffffffffffffffffff0003000000ffffffff40316181ffffffff006462 \
000188ffffffffffffffffffff000000000000000040d1cc990088ffff40d1cc990088ffff000110000000 \
adde000220000000adde60d1cc990088ffff60d1cc990088ffff0000000000000000087e6b000188ffff88 \
0000000500000000000000000000000000000000000000009cc9990088fffff8c204d509000000b8d1cc99 \
0088ffff000000000000000071756575652e746d7000ffffffffffffffffffffffffffffffffffffffffff \
0002000000ffffffff40316181ffffffff006462000188ffffffffffffffffffff0000000000000000 [  \
113.820725]  i i i i i i i i a a a a a a a a a a a a a a a i i i i i a a a a i i i i \
i i i i i i i i i i i i a a a a a a a a i i i i i i i i i i i i i i i i i i i i i i i \
i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i \
i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i \
i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i a a a a a a a a \
a a a a a a a i i i i i a a a a i i i i i i i i i i i i i i i i a a a a a a a a i i i \
i i i i i [  113.827766]                  ^
[  113.829261] RIP: 0010:[<ffffffff810da652>]  [<ffffffff810da652>] \
switch_names+0xb2/0xe0 [  113.830784] RSP: 0018:ffff88009992fcf0  EFLAGS: 00010287
[  113.832299] RAX: ffff880099ccd180 RBX: ffff880099ccd0c0 RCX: 0000000000000010
[  113.833816] RDX: ffff880099ccd0c0 RSI: ffff880099ccd0f8 RDI: ffffffffffff0070
[  113.835323] RBP: ffff88009992fcf0 R08: ffff880099ccd1b8 R09: ffffffffffff006e
[  113.836823] R10: ffff880099ccd0f8 R11: ffff880099ccd180 R12: ffff880099ccd180
[  113.838317] R13: 0000000000000000 R14: ffff8801006b6918 R15: ffff880099ccd0c0
[  113.839797] FS:  0000000000000000(0000) GS:ffffffff81820000(0000) \
knlGS:0000000000000000 [  113.841274] CS:  0010 DS: 0000 ES: 0000 CR0: \
0000000080050033 [  113.842733] CR2: ffff88009a00a510 CR3: 00000000998fb000 CR4: \
00000000000407f0 [  113.844201] DR0: 0000000000000000 DR1: 0000000000000000 DR2: \
0000000000000000 [  113.845674] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: \
0000000000000400 [  113.847152]  [<ffffffff810db49c>] __d_moFrom dve+0x1ec/0x340
[  113.848629]  [<ffffffff810dcd32>] d_move+0x12/0x20
[  113.850076]  [<ffffffff810d643e>] vfs_rename+0x3be/0x640
[  113.851493]  [<ffffffff810d69af>] SyS_renameat2+0x2ef/0x4e0
[  113.852881]  [<ffffffff810d6bc9>] SyS_rename+0x19/0x20
[  113.854236]  [<ffffffff814dfc04>] tracesys+0xcf/0xd4
[  113.855591]  [<ffffffffffffffff>] 0xffffffffffffffff


bash-4.2# addr2line -e vmlinux -i ffffffff810da652
/home/slack/kernel/linux-3.16.1/fs/dcache.c:2440 (discriminator 2)

So in two kmemcheck reports from 2 kernels addresses are different but they point to \
the same line in same file. Other addresses on stack point to: 
bash-4.2$ ./addr2l 
ffffffff810db49c
/home/slack/kernel/linux-3.16.1/fs/dcache.c:2544
---
ffffffff810dcd32
/home/slack/kernel/linux-3.16.1/include/linux/seqlock.h:219
/home/slack/kernel/linux-3.16.1/include/linux/seqlock.h:240
/home/slack/kernel/linux-3.16.1/include/linux/seqlock.h:306
/home/slack/kernel/linux-3.16.1/fs/dcache.c:2584
---
ffffffff810d643e
/home/slack/kernel/linux-3.16.1/fs/namei.c:4154
---
ffffffff810d69af
/home/slack/kernel/linux-3.16.1/fs/namei.c:4286
/home/slack/kernel/linux-3.16.1/fs/namei.c:4178
---
ffffffff810d6bc9
/home/slack/kernel/linux-3.16.1/fs/namei.c:4324
---
ffffffff814dfc04
/home/slack/kernel/linux-3.16.1/arch/x86/kernel/entry_64.S:543
---

I caught this error in one-shot mode. In enabled mode I have inifinite loop of \
kmemcheck two warnings. First is the same, second points to address ffffffff810da656 \
which points to the same line: 
bash-4.2# addr2line -e vmlinux -i ffffffff810da656
/home/slack/kernel/linux-3.16.1/fs/dcache.c:2440 (discriminator 2)
Other adresses are the same in second warning (I don't have and thus don't provide \
all informations from second warning because I can't login to shell without one-shot \
                mode. I written ffffffff810da656 addresse by pen on paper manually from screen).
