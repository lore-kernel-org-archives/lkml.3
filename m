Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaDACF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:05:57 -0400
Received: from mail-qg0-f67.google.com ([209.85.192.67]:38491 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDACFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:05:55 -0400
X-Greylist: delayed 85923 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2014 22:05:55 EDT
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 10:05:54 +0800
Message-ID: <CAA0n=K9EApRmHRTWCuTc0BASvhsNnGZR37b0HvS_s2j71OQMeQ@mail.gmail.com>
Subject: crash dev_hard_start_xmi
From: javen lee <javenkml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version: linux 3.0.35
Platform:         Freescale IMX6Q

/ # cat /proc/cpuinfo
Processor : ARMv7 Processor rev 10 (v7l)
processor : 0
BogoMIPS : 1988.29

processor : 1
BogoMIPS : 1988.29

processor : 2
BogoMIPS : 1988.29

processor : 3
BogoMIPS : 1988.29

Features : swp half thumb fastmult vfp edsp neon vfpv3
CPU implementer : 0x41
CPU architecture: 7
CPU variant : 0x2
CPU part : 0xc09
CPU revision : 10

Hardware : Freescale i.MX 6Quad/DualLite/Solo based Board
Revision : 63012
Serial : 011399d4dbc90e67
[37372.766715] Unable to handle kernel NULL pointer dereference at
virtual address 000000ac
[37372.774825] pgd = e280c000
[37372.777539] [000000ac] *pgd=34636831, *pte=00000000, *ppte=00000000
[37372.783859] Internal error: Oops: 80000007 [#1] PREEMPT SMP
[37372.789435] Modules linked in: gPRI gFXS gFXO gTDM
dahdi_echocan_oslec dahdi_transcode dahdi ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter
ip_tables x_tables drv_svip drv_tapi drv_event_logger drv_ifxos
[37372.811974] CPU: 3    Not tainted  (3.0.35 #207)
[37372.816599] PC is at 0xac
[37372.819236] LR is at __wake_up_common+0x50/0x90
[37372.823772] pc : [<000000ac>]    lr : [<c0057910>]    psr: 20000093
[37372.823776] sp : e2e73b70  ip : e3c69ca0  fp : e2e73b9c
[37372.835266] r10: 00000001  r9 : 00000304  r8 : 00000001
[37372.840494] r7 : e5298c68  r6 : e3c69d8c  r5 : 000000ac  r4 : c032bce8
[37372.847023] r3 : 00000304  r2 : 00000001  r1 : 00000001  r0 : e3c69ca0
[37372.853555] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[37372.860782] Control: 10c53c7d  Table: 3280c04a  DAC: 00000015
[37372.866532] Process asterisk (pid: 6129, stack limit = 0xe2e722f0)
[37372.872715] Stack: (0xe2e73b70 to 0xe2e74000)
[37372.877077] 3b60:                                     00000002
00000001 000000c8 e5298c60
[37372.885260] 3b80: 00000304 a0000013 00000001 00000001 c03c2c90
e9d8f4e0 e2e73bc4 c0057de8
[37372.893443] 3ba0: 00000304 00000000 e9dfe000 e3369dc0 e3369e60
e9dfe000 e354ee60 c04e61fc
[37372.901625] 3bc0: c053caa4 c02ef01c e3369dc0 c02f01dc c02f0168
c04e61dc e4d6b240 c02ff2bc
[37372.909808] 3be0: ab983665 135ff08b e9d8f4e0 c04e61fc c02952d4
e4252200 e9dfe000 e425225c
[37372.917991] 3c00: e4d6b240 e9d8f4e0 00000000 00000003 e2ac3214
c031a65c e9d8f4e0 e4252200
[37372.926174] 3c20: c04d2080 e2e72000 00389177 c053d300 e4d6b240
c031a834 e425225c c031a5fc
[37372.934356] 3c40: e9d8f4e0 e4252200 e4a44a60 e9dfe000 e9d8f4e0
e425225c 00000000 c02ff8e4
[37372.942539] 3c60: e425225c e2e72000 6afd4fd8 00000026 e4a44a60
0000000e e42c30c0 0000000e
[37372.950721] 3c80: e42c30f4 000000ac 00000000 c032b900 00000000
e4a44a60 e3523024 e2ac3040
[37372.958904] 3ca0: e2e73d8c 000000b4 000000ac c032bcf4 e4a44a60
c032cfd8 00000000 000000b4
[37372.967086] 3cc0: 00000000 e4a44a60 e3523024 c034b61c e2e73ccc
00000000 000000ac e2ac3040
[37372.975270] 3ce0: e4a44a60 e2e73f5c 00000000 067aa8c0 000000ac
000000b4 e2ac3214 c034d0c4
[37372.983453] 3d00: 000000b4 00000008 e2e73dac e2e73dbc 00000040
e2977c00 000000ac e2e73d8c
[37372.991636] 3d20: 00000000 e2e73dac c032a024 00003823 00000000
067aa8c0 00000004 00000000
[37372.999818] 3d40: 00000000 00009243 000000b4 000000ac 000000ac
e2ac3940 e2ac3970 c03a1568
[37373.008001] 3d60: e2ac3940 c02efe98 e2e72000 e4a44a60 e4a44a60
e2e73f5c e4a44a60 e2e73f5c
[37373.016183] 3d80: e2ac3940 c034bf88 e2e73d98 00000000 00000000
00000000 04110000 00000000
[37373.024366] 3da0: 067aa8c0 a97aa8c0 92433823 067aa8c0 00000000
00000000 00000000 00000000
[37373.032548] 3dc0: 483ff0f4 e2ac3040 000000ac e2e73f5c e2e73e00
00000000 00000000 00000010
[37373.040731] 3de0: 483fed84 c0354b24 000000ac 000000ac e2e73f5c
c03c72c0 e3744b60 c02ec178
[37373.048913] 3e00: 00000000 00000003 00000000 00000001 ffffffff
00000000 00000000 00000000
[37373.057095] 3e20: 00000000 00000000 e3744b60 cc020e80 00000000
00000000 00000003 e2e72000
[37373.065278] 3e40: e2e73e78 c005b868 cc021320 e344ab80 00000000
e2e72000 00000000 00000008
[37373.073460] 3e60: 00000000 c00ea788 00000b6d 00000003 00000b6e
00000003 00000b6f e2e73f40
[37373.081642] 3e80: 00000040 000000ac e63c2520 00000000 00000000
e2e73f5c 00000b68 00000010
[37373.089824] 3ea0: e2e73edc 47815554 00000000 47815554 e63c2520
483fed84 00000000 000000ac
[37373.098008] 3ec0: 47815554 e63c2520 483fed84 00000040 e2e72000
c02edc48 ffffffff 38230002
[37373.106190] 3ee0: 067aa8c0 00000000 00000000 00000000 e3744b60
c04e5cd0 00000000 00000000
[37373.114372] 3f00: 00000000 00000000 e2e73f3c c005ab04 00000004
cc020e80 00000004 e3744b60
[37373.122556] 3f20: cc020e80 00000000 00000000 00000003 e2e72000
00000000 e2e73f4c c005b2f4
[37373.130738] 3f40: 483ff30c 00000004 e4efd8c0 00000004 483ff30c
e2e73f80 00000004 e2e73edc
[37373.138920] 3f60: 00000010 e2e73f78 00000001 00000000 00000000
00000040 47815554 000000ac
[37373.147103] 3f80: 00000000 00000001 00000000 483fed84 00000010
00e24f40 00000122 c0035144
[37373.155285] 3fa0: 00000000 c0034fc0 483fed84 00000010 00000b6a
47815554 000000ac 00000000
[37373.163468] 3fc0: 483fed84 00000010 00e24f40 00000122 47815554
00e26258 478154b0 483fed84
[37373.171651] 3fe0: 00000000 483fed48 403a41f4 40399184 60000010
00000b6a 00000000 00000000
[37373.179849] [<c0057910>] (__wake_up_common+0x50/0x90) from
[<c0057de8>] (__wake_up_sync_key+0x44/0x60)
[37373.189176] [<c0057de8>] (__wake_up_sync_key+0x44/0x60) from
[<c02ef01c>] (sock_def_write_space+0x4c/0x88)
[37373.198843] [<c02ef01c>] (sock_def_write_space+0x4c/0x88) from
[<c02f01dc>] (sock_wfree+0x74/0x7c)
[37373.207822] [<c02f01dc>] (sock_wfree+0x74/0x7c) from [<c02ff2bc>]
(dev_hard_start_xmit+0x16c/0x59c)
[37373.216884] [<c02ff2bc>] (dev_hard_start_xmit+0x16c/0x59c) from
[<c031a65c>] (sch_direct_xmit+0xb0/0x1dc)
[37373.226459] [<c031a65c>] (sch_direct_xmit+0xb0/0x1dc) from
[<c031a834>] (__qdisc_run+0xac/0x130)
[37373.235257] [<c031a834>] (__qdisc_run+0xac/0x130) from [<c02ff8e4>]
(dev_queue_xmit+0x1f8/0x60c)
[37373.244054] [<c02ff8e4>] (dev_queue_xmit+0x1f8/0x60c) from
[<c032b900>] (ip_finish_output+0x134/0x39c)
[37373.253370] [<c032b900>] (ip_finish_output+0x134/0x39c) from
[<c032bcf4>] (ip_local_out+0x28/0x2c)
[37373.262338] [<c032bcf4>] (ip_local_out+0x28/0x2c) from [<c032cfd8>]
(ip_send_skb+0xc/0xd8)
[37373.270615] [<c032cfd8>] (ip_send_skb+0xc/0xd8) from [<c034b61c>]
(udp_send_skb+0xf0/0x3c8)
[37373.278979] [<c034b61c>] (udp_send_skb+0xf0/0x3c8) from
[<c034d0c4>] (udp_sendmsg+0x254/0x7f8)
[37373.287607] [<c034d0c4>] (udp_sendmsg+0x254/0x7f8) from
[<c0354b24>] (inet_sendmsg+0x94/0xb8)
[37373.296141] [<c0354b24>] (inet_sendmsg+0x94/0xb8) from [<c02ec178>]
(sock_sendmsg+0x94/0xb4)
[37373.304589] [<c02ec178>] (sock_sendmsg+0x94/0xb4) from [<c02edc48>]
(sys_sendto+0xb4/0xd8)
[37373.312863] [<c02edc48>] (sys_sendto+0xb4/0xd8) from [<c0034fc0>]
(ret_fast_syscall+0x0/0x30)
