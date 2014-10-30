Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbaJ3Kvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:51:32 -0400
Received: from mxmail.fiberhome.com.cn ([113.57.179.111]:54074 "EHLO
	mxtc.fiberhome.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758879AbaJ3Kva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:51:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAHAHcTUlQKEAEK/3poAFyDY1MFzVeHSwQCAoE7AQEBAQECAXqCOTMIBB0CDWUIMkwFKj4aJQEEGwMQiCsDyDgBK5Bfg2WBHgWLZ4pwiESDSopfimpfAYJKAQEB
X-IPAS-Result: AvAHAHcTUlQKEAEK/3poAFyDY1MFzVeHSwQCAoE7AQEBAQECAXqCOTMIBB0CDWUIMkwFKj4aJQEEGwMQiCsDyDgBK5Bfg2WBHgWLZ4pwiESDSopfimpfAYJKAQEB
From: =?utf-8?B?6auY5YGl?= <gaojian2014@fiberhome.com.cn>
To: "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: compiling tcl packet on 3.10.19 kernel encounter an Oops
Date: Thu, 30 Oct 2014 18:51:17 +0800
Message-ID: <FFBF3B03D5F241DB93902F4AB6F956BD@fenghuo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac/0Ldz5kstF9iIsRzaRMHosQFfwhg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7601.17609
X-CM-TRANSID: AQAAfwDHz5slGFJU2CIFAA--.8335S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1rJF17WF1rKrW8ZF4DXFb_yoW5KrW8pr
	y8Xr4UWw48Gr18Ar17tF15Jr1UKrnrAa1UJrykJr1DJF1UWr1UJ34UJFWUJr98J3W5Jr42
	qr1DJrWUtr1UGaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUsmb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF
	04k20xvE74AGY7Cv6cx26r45Jr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jr0_Jryl
	IxkGc2Ij64vIr4UvcSsGvfC2KfnxnUUI43ZEXa7IU5l385UUUUU==
X-CM-SenderInfo: xjdryxtdqsiimu6ixu5huk0z3hof0zgofq/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Recently I build a gcc toolchain on mips64 (broadcom netlogic xlp208) and
want to make my own filesystem. 

But when I use "make" to compile tcl packet, I meet Oops as below: 

CPU 0 Unable to handle kernel paging request at virtual address
c000000013fe0000, epc == ffffffffc020dcd8, ra == ffffffffc0332118 
Oops[#1]: 
CPU: 0 PID: 14550 Comm: cc1 Not tainted 3.10.19-WR6.0.0.5_standard+ #1 
task: c00000011be34fb0 ti: c000000113640000 task.ti: c000000113640000 
$ 0 : 0000000000000000 ffffffffc03320c8 c000000000000000 0000000013fe0000 
$ 4 : c000000013fe0000 0000000000000000 c000000013feff80 0000000000000001 
$ 8 : ffffffffc0f10000 c000000040980000 ffffffffc0b69668 0000000000000000 
$12 : c00000011364fb50 0000000000000001 000000000000000b 0000000000000003 
$16 : 000000ffe2070002 c00000011bd8f200 c00000fff1f90000 c000000001195f90 
$20 : ffffffffc0af8320 c000000013fe0000 c000000112b0fd00 c0000001138a3ff8 
$24 : ffffffffc08c53f0 ffffffffc08c0000 
$28 : c000000113640000 c00000011364fb58 c00000011364fb58 ffffffffc0332118 
Hi : 0000000000003bfa 
Lo : 00000000000013fe 
epc : ffffffffc020dcd8 clear_page+0x18/0x128 
Not tainted 
ra : ffffffffc0332118 handle_pte_fault+0xab0/0xef0 
Status: 7400f8e3 KX SX UX KERNEL EXL IE 
Cause : 0080000c 
BadVA : c000000013fe0000 
PrId : 000c1202 (Broadcom XLPII) 
Modules linked in: 
Process cc1 (pid: 14550, threadinfo=c000000113640000, task=c00000011be34fb0,
tls=000000fff2b03a10) 
Stack : 0000000000000029 c00000011be34fb0 ffffffffc0f10000 ffffffffc08a3c3c 
c00000011364fb88 c00000011364fb88 000000ffe2070002 000000ffe2070002 
000000ffe2070002 0000000000000029 c00000011be34fb0 c00000011bd8f200 
0000000000000001 c00000011364fe58 c00000011bd8f270 c000000112b0fd00 
c00000011364fbe8 ffffffffc08a5b78 0000000000000000 0000000000000000 
c00000011364fc08 c00000011364fc08 c00000011be34fb0 0000000000000001 
0000000000000000 c00000011364fc20 c00000011364fc20 ffffffffc0287998 
000000d2268e7d19 c00000011be34fb0 c000000001570ac0 c00000011364fc58 
c00000011364fe58 c000000001570ac0 c000000001570ac0 c0000000015708d0 
c00000011364fc88 c00000011364fc88 c000000001570220 0000000000000000 
... 
Call Trace: 
[<ffffffffc020dcd8>] clear_page+0x18/0x128 
[<ffffffffc0332118>] handle_pte_fault+0xab0/0xef0 
[<ffffffffc08a5b78>] do_page_fault+0x160/0x530 
[<ffffffffc01f3a64>] resume_userspace_check+0x0/0x10 
Code: cc9e0040 cc9e0060 cc9e0080 <fc800000> fc800008 fc800010 fc800018
64840040 cc9e0060 
---[ end trace 248ee2b369c3a6b1 ]--- 
note: cc1[14550] exited with preempt_count 1 
{standard input}: Assembler messages: 
{standard input}:89595: Warning: end of file not at end of a line; newline
inserted 
{standard input}:89783: Error: missing ')' 
{standard input}:89783: Error: invalid operands `ld $25,%call16(memcpy)($' 
{standard input}: Warning: missing .end at end of assembly 
gcc: internal compiler error: Segmentation fault (program cc1) 
0x12001354b execute 
../../gcc-4.8.3/gcc/gcc.c:2823 
Please submit a full bug report, 
with preprocessed source if appropriate. 
Please include the complete backtrace with any bug report. 
See <http://gcc.gnu.org/bugs.html> for instructions. 
make[1]: *** [tclsqlite3.o] Error 4 
make: *** [packages] Error 2 

it looks like a bug in kernel . Maybe the page table has been corrupted. 

BTW, the kernel version is 3.10.19. 

Is there any solution about this ? : )


