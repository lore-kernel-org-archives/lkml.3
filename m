Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3GBOqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:46:31 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:47299 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GBOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:46:29 -0400
Message-ID: <51D2E7BA.4020308@t-online.de>
Date: Tue, 02 Jul 2013 16:46:18 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: isdn4linux@listserv.isdn4linux.de, Karsten Keil <kkeil@linux-pingi.de>
Subject: [BUG 3.9.x, 3.10] divertctrl triggers kernel bug  at kernel/timer.c:910
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EA1HW0ZJQhnBI7ze28lXu2tQh9fAaHOJidRkoJyLe-n0HFQF0mKl7k1HxOldLlogcy
X-TOI-MSGID: d0805be5-5a58-4f17-9757-97d199b91be5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing  "divertctrl wait interrogate HiSax cfu 999999 0" occasionally
triggers a kernel bug in kernel 3.10. The same problem is present in
kernel 3.9.x and was already reported to lkml on May 9, 2013.

cu,
  Knut

[  284.593070] ------------[ cut here ]------------
[  284.593137] kernel BUG at kernel/timer.c:910!
[  284.593187] invalid opcode: 0000 [#1] PREEMPT
[  284.593244] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat dss1_divert hisax isdn ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 ir_kbd_i2c binfmt_misc isl6421 cx24116 cx88_dvb videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_rc5_decoder rc_hauppauge snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_pcm_oss snd_pcm snd_seq snd_timer tuner snd_seq_device snd_mixer_oss cx8800 cx8802 snd cx88xx v4l2_common videodev rc_core tveeprom videobuf_dma_sg videobuf_core btcx_risc soundcore snd_page_alloc
[  284.594226] CPU: 0 PID: 2075 Comm: divertctrl Not tainted 3.10.0-main #23
[  284.594300] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
[  284.594368] task: efb4a3a0 ti: f3a5c000 task.ti: f3a5c000
[  284.594428] EIP: 0060:[<c01316ee>] EFLAGS: 00010286 CPU: 0
[  284.594493] EIP is at add_timer+0xd/0x19
[  284.594538] EAX: f394a430 EBX: f394a42c ECX: fffff0f4 EDX: 00000000
[  284.594606] ESI: f394a430 EDI: 000003e8 EBP: f3a5db14 ESP: f3a5db14
[  284.594675]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  284.594734] CR0: 8005003b CR2: b7656062 CR3: 37224000 CR4: 000007f0
[  284.594802] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  284.594869] DR6: ffff0ff0 DR7: 00000400
[  284.594912] Stack:
[  284.594936]  f3a5db30 fa39c804 fa3acb00 00001b58 f394a400 fa393787 00000001 f3a5db44
[  284.595049]  fa3937ca 00000000 00000002 f394a414 f3a5db60 fa39c677 c051d0ec 00000000
[  284.595161]  f394a400 00000009 00000000 f3a5db78 fa393fdf f393e000 f393e000 00000246
[  284.595273] Call Trace:
[  284.595316]  [<fa39c804>] FsmRestartTimer+0x60/0x6c [hisax]
[  284.595385]  [<fa393787>] ? l1b_activate+0x34/0x34 [hisax]
[  284.595452]  [<fa3937ca>] l1_power_up_s+0x43/0x5d [hisax]
[  284.595520]  [<fa39c677>] FsmEvent+0x77/0xa8 [hisax]
[  284.595580]  [<c051d0ec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[  284.595654]  [<fa393fdf>] l1_msg+0x6b/0xd6 [hisax]
[  284.595716]  [<fa3a2771>] HFCPCI_l1hw+0x25c/0x352 [hisax]
[  284.595782]  [<fa393569>] ? l1_timer_deact+0x34/0x34 [hisax]
[  284.595851]  [<fa393584>] l1_activate_s+0x1b/0x1e [hisax]
[  284.595918]  [<fa39c677>] FsmEvent+0x77/0xa8 [hisax]
[  284.595981]  [<fa39397a>] dch_l2l1+0x9a/0x109 [hisax]
[  284.596007]  [<fa39562d>] isdnl2_l3l2+0xed/0x145 [hisax]
[  284.596007]  [<fa397f69>] ? isdnl3_trans+0x14/0x14 [hisax]
[  284.596007]  [<fa397f8e>] lc_activate+0x25/0x28 [hisax]
[  284.596007]  [<fa39c677>] FsmEvent+0x77/0xa8 [hisax]
[  284.596007]  [<fa3989ca>] l3_msg+0xc1/0xc4 [hisax]
[  284.596007]  [<fa3a0452>] l3dss1_cmd_global.part.12+0x1e8/0x1ff [hisax]
[  284.596007]  [<c015eea7>] ? noop_count+0x9/0x9
[  284.596007]  [<c016053f>] ? check_usage+0x8a/0x499
[  284.596007]  [<c016b579>] ? is_module_text_address+0x2b/0x43
[  284.596007]  [<c0167539>] ? __module_text_address+0x10/0x51
[  284.596007]  [<c016b579>] ? is_module_text_address+0x2b/0x43
[  284.596007]  [<c013dffa>] ? __kernel_text_address+0x22/0x3e
[  284.596007]  [<c0102fc4>] ? print_context_stack+0x86/0x99
[  284.596007]  [<c0108ff5>] ? save_stack_trace+0x3d/0x3d
[  284.596007]  [<c010249c>] ? dump_trace+0x84/0xb7
[  284.596007]  [<c0108fd9>] ? save_stack_trace+0x21/0x3d
[  284.596007]  [<c016221d>] ? __lock_acquire+0x1271/0x1544
[  284.596007]  [<fa3a048d>] l3dss1_cmd_global+0x24/0x85 [hisax]
[  284.596007]  [<fa39c3a5>] HiSax_command+0x8f2/0x949 [hisax]
[  284.596007]  [<c02e0d90>] ? string.isra.4+0x30/0xa1
[  284.596007]  [<c02e1b6a>] ? vsnprintf+0x74/0x27d
[  284.596007]  [<c02e221f>] ? sprintf+0x17/0x19
[  284.596007]  [<fa1053f7>] ? cf_command+0x223/0x280 [dss1_divert]
[  284.596007]  [<fa0ea81c>] isdn_command+0xbd/0xc5 [isdn]
[  284.596007]  [<fa105402>] cf_command+0x22e/0x280 [dss1_divert]
[  284.596007]  [<c01b8ddd>] ? might_fault+0x2e/0x6c
[  284.596007]  [<fa106518>] ? isdn_divert_ioctl_unlocked.isra.0+0x1d8/0x1d8 [dss1_divert]
[  284.596007]  [<fa1064ef>] isdn_divert_ioctl_unlocked.isra.0+0x1af/0x1d8 [dss1_divert]
[  284.596007]  [<fa106518>] ? isdn_divert_ioctl_unlocked.isra.0+0x1d8/0x1d8 [dss1_divert]
[  284.596007]  [<fa10653b>] isdn_divert_ioctl+0x23/0x35 [dss1_divert]
[  284.596007]  [<c0211216>] proc_reg_unlocked_ioctl+0x3a/0x5e
[  284.596007]  [<c02111dc>] ? proc_reg_mmap+0x56/0x56
[  284.596007]  [<c01db6d4>] vfs_ioctl+0x20/0x2a
[  284.596007]  [<c01dc124>] do_vfs_ioctl+0x42d/0x46b
[  284.596007]  [<c01437e1>] ? up_read+0x1b/0x2d
[  284.596007]  [<c051fa81>] ? __do_page_fault+0x3fb/0x480
[  284.596007]  [<c01d6ec6>] ? putname+0x22/0x2b
[  284.596007]  [<c01ce306>] ? do_sys_open+0x174/0x17e
[  284.596007]  [<c01dc1ae>] SyS_ioctl+0x4c/0x76
[  284.596007]  [<c01630a5>] ? trace_hardirqs_on_caller+0x12e/0x180
[  284.596007]  [<c051d505>] syscall_call+0x7/0xb
[  284.596007] Code: 8b 3d 08 24 79 c0 85 ff 0f 85 65 ff ff ff e9 74 ff ff ff 8b 45 e8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 3e 8d 74 26 00 83 38 00 74 02 <0f> 0b 8b 50 08 e8 99 fe ff ff 5d c3 55 89 e5 57 56 53 83 ec 0c
[  284.596007] EIP: [<c01316ee>] add_timer+0xd/0x19 SS:ESP 0068:f3a5db14
[  284.660411] ---[ end trace 2c5765b4a8a4b081 ]---
[  288.600023] dss1_divert unhandled process



