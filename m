Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3LXL24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 06:28:56 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51310 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3LXL2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 06:28:52 -0500
MIME-Version: 1.0
Date: Tue, 24 Dec 2013 16:58:51 +0530
Message-ID: <CAKohpom5JmFamPpOsyPRqXNAqXu6VF_t0zXXhT90MCMutp5FgQ@mail.gmail.com>
Subject: [Query]: trace-cmd crashing with '-e syscalls' on 3.13-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I am trying to trace some stuff on Samsung's Arndale Board (ARM)
with 3.13-rc1 and seeing these crashes/segmentation faults
whenever I try to trace syscalls.

Is this a know issue? Or something new?

trace-cmd version 2.2.0


[  299.998874] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  300.005554] pgd = ed9fc000
[  300.008201] [0000001b] *pgd=6eb1e831, *pte=00000000, *ppte=00000000
[  300.014428] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[  300.019812] Modules linked in:
[  300.022847] CPU: 0 PID: 2172 Comm: is-cpu-isolated Not tainted
3.13.0-rc1-00090-gd6eaf98-dirty #141
[  300.031880] task: ee9a9680 ti: eddfc000 task.ti: eddfc000
[  300.037263] PC is at ftrace_syscall_enter+0x44/0x17c
[  300.042208] LR is at syscall_trace_enter+0xf8/0x138
[  300.047066] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  300.047066] sp : eddfdf40  ip : eddfdf80  fp : eddfdf7c
[  300.058529] r10: 00001400  r9 : eddfc000  r8 : c000eea4
[  300.063731] r7 : eddfdfb0  r6 : eddfc000  r5 : ffffffff  r4 : 000f0005
[  300.070242] r3 : eddfc000  r2 : 000f001d  r1 : eddfdfb0  r0 : c06cb2f8
[  300.076754] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  300.083872] Control: 10c5387d  Table: 6d9fc06a  DAC: 00000015
[  300.089599] Process is-cpu-isolated (pid: 2172, stack limit = 0xeddfc240)
[  300.096370] Stack: (0xeddfdf40 to 0xeddfe000)
[  300.100711] df40: ef1c5910 00000000 eddfdf8c 00000022 00000003
ede2c490 000f0005 eddfc000
[  300.108872] df60: eddfdfb0 c000eea4 eddfc000 00001400 eddfdfa4
eddfdf80 c0010eb0 c00ad61c
[  300.117034] df80: b6f824c0 b6f83c90 00000001 00000000 000f0005
c000eea4 00000000 eddfdfa8
[  300.125194] dfa0: c000ee4c c0010dc4 b6f83c90 00000001 b6f824c0
b6f88050 b6f82b98 b6f824c0
[  300.133352] dfc0: b6f83c90 00000001 00000000 000f0005 00000001
00000000 0009688c b6f88958
[  300.141511] dfe0: 000f0005 bef66460 b6f698fb b6f79966 80000030
b6f824c0 00000000 00000000
[  300.149678] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  300.159573] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  300.168510] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  300.174595] ---[ end trace f8b3633d964e9e60 ]---
[  300.179189] note: is-cpu-isolated[2172] exited with preempt_count 1
Segmentation fault
[  300.956933] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  300.963587] pgd = ed9fc000
[  300.966234] [0000001b] *pgd=6ebd3831, *pte=00000000, *ppte=00000000
[  300.972483] Internal error: Oops: 17 [#2] PREEMPT SMP ARM
[  300.977867] Modules linked in:
[  300.980903] CPU: 0 PID: 2173 Comm: trace-cmd Tainted: G      D
3.13.0-rc1-00090-gd6eaf98-dirty #141
[  300.990372] task: ee9aa1c0 ti: eddfe000 task.ti: eddfe000
[  300.995752] PC is at ftrace_syscall_enter+0x44/0x17c
[  301.000700] LR is at syscall_trace_enter+0xf8/0x138
[  301.005557] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  301.005557] sp : eddfff40  ip : eddfff80  fp : eddfff7c
[  301.017022] r10: 00001400  r9 : eddfe000  r8 : c000eea4
[  301.022222] r7 : eddfffb0  r6 : eddfe000  r5 : ffffffff  r4 : 000f0005
[  301.028733] r3 : eddfe000  r2 : 000f001d  r1 : eddfffb0  r0 : c06cb2f8
[  301.035244] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  301.042362] Control: 10c5387d  Table: 6d9fc06a  DAC: 00000015
[  301.048089] Process trace-cmd (pid: 2173, stack limit = 0xeddfe240)
[  301.054340] Stack: (0xeddfff40 to 0xede00000)
[  301.058679] ff40: eddfffb0 ef09a280 eddfff8c eddfff58 c00ad2d0
ede2c490 000f0005 eddfe000
[  301.066843] ff60: eddfffb0 c000eea4 eddfe000 00001400 eddfffa4
eddfff80 c0010eb0 c00ad61c
[  301.075002] ff80: 000bc320 000bc318 00000008 00000010 000f0005
c000eea4 00000000 eddfffa8
[  301.083162] ffa0: c000ee4c c0010dc4 000bc318 00000008 000be4c0
000b2018 00000000 000bc320
[  301.091321] ffc0: 000bc318 00000008 00000010 000f0005 00000038
000be4c0 00000004 00000001
[  301.099480] ffe0: 000f0005 be9cc6d8 0002ed43 0002ef66 40000030
000be4c0 6f7fd821 6f7fdc21
[  301.107645] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  301.117540] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  301.126477] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  301.132565] ---[ end trace f8b3633d964e9e61 ]---
[  301.137158] note: trace-cmd[2173] exited with preempt_count 1
Segmentation fault
[  301.922253] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  301.928899] pgd = eda00000
[  301.931556] [0000001b] *pgd=6d9f2831, *pte=00000000, *ppte=00000000
[  301.937803] Internal error: Oops: 17 [#3] PREEMPT SMP ARM
[  301.943187] Modules linked in:
[  301.946223] CPU: 0 PID: 2174 Comm: cat Tainted: G      D
3.13.0-rc1-00090-gd6eaf98-dirty #141
[  301.955172] task: ee9aa580 ti: ed9f8000 task.ti: ed9f8000
[  301.960552] PC is at ftrace_syscall_enter+0x44/0x17c
[  301.965500] LR is at syscall_trace_enter+0xf8/0x138
[  301.970356] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  301.970356] sp : ed9f9f40  ip : ed9f9f80  fp : ed9f9f7c
[  301.981820] r10: 00001400  r9 : ed9f8000  r8 : c000eea4
[  301.987021] r7 : ed9f9fb0  r6 : ed9f8000  r5 : ffffffff  r4 : 000f0005
[  301.993532] r3 : ed9f8000  r2 : 000f001d  r1 : ed9f9fb0  r0 : c06cb2f8
[  302.000044] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  302.007161] Control: 10c5387d  Table: 6da0006a  DAC: 00000015
[  302.012888] Process cat (pid: 2174, stack limit = 0xed9f8240)
[  302.018617] Stack: (0xed9f9f40 to 0xed9fa000)
[  302.022958] 9f40: ed9f9fb0 00000000 ed9f9f8c 00000022 00000003
ede2c490 000f0005 ed9f8000
[  302.031122] 9f60: ed9f9fb0 c000eea4 ed9f8000 00001400 ed9f9fa4
ed9f9f80 c0010eb0 c00ad61c
[  302.039281] 9f80: b6f6d840 b6f6d178 00000001 00000000 000f0005
c000eea4 00000000 ed9f9fa8
[  302.047440] 9fa0: c000ee4c c0010dc4 b6f6d178 00000001 b6f6d840
b6f72050 b6f6df18 b6f6d840
[  302.055599] 9fc0: b6f6d178 00000001 00000000 000f0005 00000001
00000000 0000e67c b6f72958
[  302.063758] 9fe0: 000f0005 beaf6480 b6f538fb b6f63966 80000030
b6f6d840 00000000 00000000
[  302.071922] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  302.081819] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  302.090756] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  302.096845] ---[ end trace f8b3633d964e9e62 ]---
[  302.101436] note: cat[2174] exited with preempt_count 1
Segmentation fault
[  302.881881] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  302.888532] pgd = ed9fc000
[  302.891180] [0000001b] *pgd=6eb1e831, *pte=00000000, *ppte=00000000
[  302.897429] Internal error: Oops: 17 [#4] PREEMPT SMP ARM
[  302.902813] Modules linked in:
[  302.905849] CPU: 0 PID: 2175 Comm: trace-cmd Tainted: G      D
3.13.0-rc1-00090-gd6eaf98-dirty #141
[  302.915319] task: ee9aa1c0 ti: ee492000 task.ti: ee492000
[  302.920698] PC is at ftrace_syscall_enter+0x44/0x17c
[  302.925645] LR is at syscall_trace_enter+0xf8/0x138
[  302.930503] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  302.930503] sp : ee493f40  ip : ee493f80  fp : ee493f7c
[  302.941967] r10: 00001400  r9 : ee492000  r8 : c000eea4
[  302.947169] r7 : ee493fb0  r6 : ee492000  r5 : ffffffff  r4 : 000f0005
[  302.953679] r3 : ee492000  r2 : 000f001d  r1 : ee493fb0  r0 : c06cb2f8
[  302.960190] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  302.967307] Control: 10c5387d  Table: 6d9fc06a  DAC: 00000015
[  302.973035] Process trace-cmd (pid: 2175, stack limit = 0xee492240)
[  302.979286] Stack: (0xee493f40 to 0xee494000)
[  302.983625] 3f40: ee493fb0 ef09a280 ee493f8c ee493f58 c00ad2d0
ede2c490 000f0005 ee492000
[  302.991789] 3f60: ee493fb0 c000eea4 ee492000 00001400 ee493fa4
ee493f80 c0010eb0 c00ad61c
[  302.999948] 3f80: 000bc320 000bc318 00000008 00000010 000f0005
c000eea4 00000000 ee493fa8
[  303.008108] 3fa0: c000ee4c c0010dc4 000bc318 00000008 000be4c0
000b2018 00000000 000bc320
[  303.016267] 3fc0: 000bc318 00000008 00000010 000f0005 00000038
000be4c0 00000004 00000001
[  303.024426] 3fe0: 000f0005 be8c76c8 0002ed43 0002ef66 40000030
000be4c0 00000000 00000000
[  303.032591] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  303.042487] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  303.051423] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  303.057512] ---[ end trace f8b3633d964e9e63 ]---
[  303.062103] note: trace-cmd[2175] exited with preempt_count 1
Segmentation fault
[  303.842447] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  303.849096] pgd = eddfc000
[  303.851752] [0000001b] *pgd=6d9f1831, *pte=00000000, *ppte=00000000
[  303.858002] Internal error: Oops: 17 [#5] PREEMPT SMP ARM
[  303.863386] Modules linked in:
[  303.866422] CPU: 0 PID: 2176 Comm: is-cpu-isolated Tainted: G
D      3.13.0-rc1-00090-gd6eaf98-dirty #141
[  303.876412] task: ee9a9680 ti: ed9fa000 task.ti: ed9fa000
[  303.881791] PC is at ftrace_syscall_enter+0x44/0x17c
[  303.886738] LR is at syscall_trace_enter+0xf8/0x138
[  303.891596] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  303.891596] sp : ed9fbf40  ip : ed9fbf80  fp : ed9fbf7c
[  303.903059] r10: 00001400  r9 : ed9fa000  r8 : c000eea4
[  303.908261] r7 : ed9fbfb0  r6 : ed9fa000  r5 : ffffffff  r4 : 000f0005
[  303.914772] r3 : ed9fa000  r2 : 000f001d  r1 : ed9fbfb0  r0 : c06cb2f8
[  303.921283] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  303.928400] Control: 10c5387d  Table: 6ddfc06a  DAC: 00000015
[  303.934128] Process is-cpu-isolated (pid: 2176, stack limit = 0xed9fa240)
[  303.940900] Stack: (0xed9fbf40 to 0xed9fc000)
[  303.945239] bf40: ed9fbfb0 00000000 ed9fbf8c 00000022 00000003
ede2c490 000f0005 ed9fa000
[  303.953403] bf60: ed9fbfb0 c000eea4 ed9fa000 00001400 ed9fbfa4
ed9fbf80 c0010eb0 c00ad61c
[  303.961562] bf80: b6f174c0 b6f18c90 00000001 00000000 000f0005
c000eea4 00000000 ed9fbfa8
[  303.969721] bfa0: c000ee4c c0010dc4 b6f18c90 00000001 b6f174c0
b6f1d050 b6f17b98 b6f174c0
[  303.977880] bfc0: b6f18c90 00000001 00000000 000f0005 00000001
00000000 0009688c b6f1d958
[  303.986039] bfe0: 000f0005 be90c460 b6efe8fb b6f0e966 80000030
b6f174c0 6f7fd821 6f7fdc21
[  303.994204] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  304.004101] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  304.013037] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  304.019125] ---[ end trace f8b3633d964e9e64 ]---
[  304.023717] note: is-cpu-isolated[2176] exited with preempt_count 1
Segmentation fault
Saved trace in: dft
[  304.807095] Unable to handle kernel NULL pointer dereference at
virtual address 0000001b
[  304.813737] pgd = ed9fc000
[  304.816395] [0000001b] *pgd=6eb1e831, *pte=00000000, *ppte=00000000
[  304.822644] Internal error: Oops: 17 [#6] PREEMPT SMP ARM
[  304.828029] Modules linked in:
[  304.831065] CPU: 0 PID: 2177 Comm: sync Tainted: G      D
3.13.0-rc1-00090-gd6eaf98-dirty #141
[  304.840100] task: ee9aa1c0 ti: ee492000 task.ti: ee492000
[  304.845479] PC is at ftrace_syscall_enter+0x44/0x17c
[  304.850426] LR is at syscall_trace_enter+0xf8/0x138
[  304.855284] pc : [<c00ad654>]    lr : [<c0010eb0>]    psr: a0000013
[  304.855284] sp : ee493f40  ip : ee493f80  fp : ee493f7c
[  304.866749] r10: 00001400  r9 : ee492000  r8 : c000eea4
[  304.871950] r7 : ee493fb0  r6 : ee492000  r5 : ffffffff  r4 : 000f0005
[  304.878461] r3 : ee492000  r2 : 000f001d  r1 : ee493fb0  r0 : c06cb2f8
[  304.884972] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  304.892089] Control: 10c5387d  Table: 6d9fc06a  DAC: 00000015
[  304.897816] Process sync (pid: 2177, stack limit = 0xee492240)
[  304.903632] Stack: (0xee493f40 to 0xee494000)
[  304.907973] 3f40: ee493fb0 00000000 ee493f8c 00000022 00000003
ede2c490 000f0005 ee492000
[  304.916137] 3f60: ee493fb0 c000eea4 ee492000 00001400 ee493fa4
ee493f80 c0010eb0 c00ad61c
[  304.924296] 3f80: b6fa8840 b6fa8178 00000001 00000000 000f0005
c000eea4 00000000 ee493fa8
[  304.932455] 3fa0: c000ee4c c0010dc4 b6fa8178 00000001 b6fa8840
b6fad050 b6fa8f18 b6fa8840
[  304.940615] 3fc0: b6fa8178 00000001 00000000 000f0005 00000001
00000000 0000b0d8 b6fad958
[  304.948773] 3fe0: 000f0005 bebbb4a0 b6f8e8fb b6f9e966 80000030
b6fa8840 00000000 00000000
[  304.956937] [<c00ad654>] (ftrace_syscall_enter+0x44/0x17c) from
[<c0010eb0>] (syscall_trace_enter+0xf8/0x138)
[  304.966834] [<c0010eb0>] (syscall_trace_enter+0xf8/0x138) from
[<c000ee4c>] (__sys_trace+0xc/0x38)
[  304.975771] Code: e2842018 e7905102 e3550000 0a000038 (e595201c)
[  304.981859] ---[ end trace f8b3633d964e9e65 ]---
[  304.986451] note: sync[2177] exited with preempt_count 1
Segmentation fault

--
viresh
