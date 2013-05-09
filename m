Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3EIJ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:57:47 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:58712 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3EIJ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:57:44 -0400
X-Greylist: delayed 1005 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 05:57:43 EDT
Message-ID: <518B6F20.4040102@t-online.de>
Date: Thu, 09 May 2013 11:40:48 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: isdn4linux@listserv.isdn4linux.de, Thomas Gleixner <tglx@linutronix.de>,
        Karsten Keil <kkeil@linux-pingi.de>
Subject: [BUG 3.9.x] kernel BUG at kernel/timer.c:909 triggered by divertctl
Content-Type: multipart/mixed;
 boundary="------------070301080304050308010205"
X-ID: GQAldEZerhwnqG7vXJ9ScA60qvHAqlwlIzX81rwR3c3WqVE+JtJpuMqqhMzf-euZcx
X-TOI-MSGID: dc0cafff-abb3-4cdc-b8c0-34ea156012e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070301080304050308010205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After compiling kernel 3.9.1 I found that a script containing a
number of divertctrl commands triggered a kernel bug: (MSNs edited)

     divertctrl wait interrogate HiSax cfu 123456 0
     divertctrl wait interrogate HiSax cfu 1234567 0
     [...]

I tried the script with kernel 3.9.0 and found the same problem.
At that time it was reproducible on a 2nd identical machine.

After that I tried kernel 3.8.12 and everything was ok.

I tried to bisect the  problem. That failed. I found that the problem
totally disappeared, it is currently not reproducible with any of the
kernels mentioned above.

The only reasonable explanation is that an unusual answer from the switch side
triggered the problem ... something that definitely  should not be possible.

Unfortunately there is no trace of the d-channel traffic.

Hardware: AOpen i915GMm-hfs, hfc-pci isdn controller card (1397:2bd0)
Distribution:openSuSE 12.3
ISDN: Deutsche Telekom Euro-ISDN, no pbx.

cu,
  Knut

--------------070301080304050308010205
Content-Type: text/plain; charset=UTF-8;
 name="tracediv1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tracediv1"

Trace 1, kernel 3.9.1
=====================
2013-05-08T08:48:59.930157+02:00 golem kernel: [    0.000000] Linux version 3.9.1-main (knut@golem.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #14 PREEMPT Wed May 8 08:30:54 CEST 2013
[....]
2013-05-08T08:55:54.317180+02:00 golem sudo:     knut : TTY=pts/1 ; PWD=/home/knut ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 123456 0
2013-05-08T08:55:54.393408+02:00 golem kernel: [  430.161055] ------------[ cut here ]------------
2013-05-08T08:55:54.393428+02:00 golem kernel: [  430.161121] kernel BUG at kernel/timer.c:909!
2013-05-08T08:55:54.393431+02:00 golem kernel: [  430.161171] invalid opcode: 0000 [#1] PREEMPT 
2013-05-08T08:55:54.393435+02:00 golem kernel: [  430.161228] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat dss1_divert hisax isdn ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 ir_kbd_i2c binfmt_misc isl6421 cx24116 cx88_dvb videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_rc5_decoder rc_hauppauge snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_seq tuner snd_timer snd_seq_device snd_mixer_oss cx8800 cx8802 snd cx88xx v4l2_common videodev rc_core tveeprom videobuf_dma_sg videobuf_core btcx_risc soundcore snd_page_alloc
2013-05-08T08:55:54.393440+02:00 golem kernel: [  430.162213] Pid: 2328, comm: divertctrl Not tainted 3.9.1-main #14    /i915GMm-HFS
2013-05-08T08:55:54.393443+02:00 golem kernel: [  430.162296] EIP: 0060:[<c01322c4>] EFLAGS: 00010282 CPU: 0
2013-05-08T08:55:54.393446+02:00 golem kernel: [  430.162363] EIP is at add_timer+0xd/0x19
2013-05-08T08:55:54.393448+02:00 golem kernel: [  430.162407] EAX: f5b96830 EBX: f5b9682c ECX: 00007f1c EDX: 00000000
2013-05-08T08:55:54.393451+02:00 golem kernel: [  430.162476] ESI: f5b96830 EDI: 000003e8 EBP: eefffb18 ESP: eefffb18
2013-05-08T08:55:54.393454+02:00 golem kernel: [  430.162544]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
2013-05-08T08:55:54.393457+02:00 golem kernel: [  430.162603] CR0: 8005003b CR2: b75ac062 CR3: 2efd0000 CR4: 000007f0
2013-05-08T08:55:54.393459+02:00 golem kernel: [  430.162671] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
2013-05-08T08:55:54.393462+02:00 golem kernel: [  430.162739] DR6: ffff0ff0 DR7: 00000400
2013-05-08T08:55:54.393465+02:00 golem kernel: [  430.162783] Process divertctrl (pid: 2328, ti=eeffe000 task=eeffcb20 task.ti=eeffe000)
2013-05-08T08:55:54.393468+02:00 golem kernel: [  430.162867] Stack:
2013-05-08T08:55:54.393470+02:00 golem kernel: [  430.162892]  eefffb34 fa05f7e4 fa06fb00 00001b58 f5b96800 fa056767 00000001 eefffb48
2013-05-08T08:55:54.393473+02:00 golem kernel: [  430.163004]  fa0567aa 00000000 00000002 f5b96814 eefffb64 fa05f657 c050ff9c 00000000
2013-05-08T08:55:54.393476+02:00 golem kernel: [  430.163117]  f5b96800 00000009 00000000 eefffb7c fa056fbf f455c000 f455c000 00000246
2013-05-08T08:55:54.393479+02:00 golem kernel: [  430.163229] Call Trace:
2013-05-08T08:55:54.393481+02:00 golem kernel: [  430.163272]  [<fa05f7e4>] FsmRestartTimer+0x60/0x6c [hisax]
2013-05-08T08:55:54.393484+02:00 golem kernel: [  430.163340]  [<fa056767>] ? l1b_activate+0x34/0x34 [hisax]
2013-05-08T08:55:54.393487+02:00 golem kernel: [  430.163408]  [<fa0567aa>] l1_power_up_s+0x43/0x5d [hisax]
2013-05-08T08:55:54.393490+02:00 golem kernel: [  430.163475]  [<fa05f657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T08:55:54.393492+02:00 golem kernel: [  430.163537]  [<c050ff9c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
2013-05-08T08:55:54.393495+02:00 golem kernel: [  430.163610]  [<fa056fbf>] l1_msg+0x6b/0xd6 [hisax]
2013-05-08T08:55:54.393498+02:00 golem kernel: [  430.163673]  [<fa065723>] HFCPCI_l1hw+0x25c/0x352 [hisax]
2013-05-08T08:55:54.393501+02:00 golem kernel: [  430.163739]  [<fa056549>] ? l1_timer_deact+0x34/0x34 [hisax]
2013-05-08T08:55:54.393503+02:00 golem kernel: [  430.163808]  [<fa056564>] l1_activate_s+0x1b/0x1e [hisax]
2013-05-08T08:55:54.393506+02:00 golem kernel: [  430.163875]  [<fa05f657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T08:55:54.393509+02:00 golem kernel: [  430.163937]  [<fa05695a>] dch_l2l1+0x9a/0x109 [hisax]
2013-05-08T08:55:54.393512+02:00 golem kernel: [  430.164000]  [<fa05860d>] isdnl2_l3l2+0xed/0x145 [hisax]
2013-05-08T08:55:54.393515+02:00 golem kernel: [  430.164067]  [<fa05af49>] ? isdnl3_trans+0x14/0x14 [hisax]
2013-05-08T08:55:54.393517+02:00 golem kernel: [  430.164136]  [<fa05af6e>] lc_activate+0x25/0x28 [hisax]
2013-05-08T08:55:54.393520+02:00 golem kernel: [  430.164201]  [<fa05f657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T08:55:54.393523+02:00 golem kernel: [  430.164264]  [<fa05b9aa>] l3_msg+0xc1/0xc4 [hisax]
2013-05-08T08:55:54.393525+02:00 golem kernel: [  430.164327]  [<fa063432>] l3dss1_cmd_global.part.12+0x1e8/0x1ff [hisax]
2013-05-08T08:55:54.393528+02:00 golem kernel: [  430.164344]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T08:55:54.417481+02:00 golem kernel: last message repeated 2 times
2013-05-08T08:55:54.393536+02:00 golem kernel: [  430.164344]  [<c0157b82>] ? debug_mutex_init+0x26/0x34
2013-05-08T08:55:54.393539+02:00 golem kernel: [  430.164344]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T08:55:54.417519+02:00 golem kernel: last message repeated 2 times
2013-05-08T08:55:54.393547+02:00 golem kernel: [  430.164344]  [<c0157b82>] ? debug_mutex_init+0x26/0x34
2013-05-08T08:55:54.393550+02:00 golem kernel: [  430.164344]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T08:55:54.393553+02:00 golem kernel: [  430.164344]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T08:55:54.393555+02:00 golem kernel: [  430.164344]  [<c0302cbf>] ? vgacon_doresize+0x196/0x1ef
2013-05-08T08:55:54.393558+02:00 golem kernel: [  430.164344]  [<c01d8d43>] ? inode_init_always+0x135/0x1e2
2013-05-08T08:55:54.393561+02:00 golem kernel: [  430.164344]  [<fa06346d>] l3dss1_cmd_global+0x24/0x85 [hisax]
2013-05-08T08:55:54.393564+02:00 golem kernel: [  430.164344]  [<fa05f385>] HiSax_command+0x8f2/0x949 [hisax]
2013-05-08T08:55:54.393566+02:00 golem kernel: [  430.164344]  [<c02ddd18>] ? string.isra.4+0x30/0xa1
2013-05-08T08:55:54.393569+02:00 golem kernel: [  430.164344]  [<c02deaf0>] ? vsnprintf+0x74/0x27d
2013-05-08T08:55:54.393572+02:00 golem kernel: [  430.164344]  [<c02df1ac>] ? sprintf+0x17/0x19
2013-05-08T08:55:54.393575+02:00 golem kernel: [  430.164344]  [<fa0bd3f7>] ? cf_command+0x223/0x280 [dss1_divert]
2013-05-08T08:55:54.393577+02:00 golem kernel: [  430.164344]  [<fa197824>] isdn_command+0xbd/0xc5 [isdn]
2013-05-08T08:55:54.393580+02:00 golem kernel: [  430.164344]  [<fa0bd402>] cf_command+0x22e/0x280 [dss1_divert]
2013-05-08T08:55:54.393583+02:00 golem kernel: [  430.164344]  [<fa0be4ef>] isdn_divert_ioctl_unlocked.isra.0+0x1af/0x1d8 [dss1_divert]
2013-05-08T08:55:54.393586+02:00 golem kernel: [  430.164344]  [<fa0be53b>] isdn_divert_ioctl+0x23/0x35 [dss1_divert]
2013-05-08T08:55:54.393588+02:00 golem kernel: [  430.164344]  [<fa0be518>] ? isdn_divert_ioctl_unlocked.isra.0+0x1d8/0x1d8 [dss1_divert]
2013-05-08T08:55:54.393591+02:00 golem kernel: [  430.164344]  [<c0209b71>] proc_reg_unlocked_ioctl+0x62/0x7c
2013-05-08T08:55:54.393594+02:00 golem kernel: [  430.164344]  [<c0209b0f>] ? proc_reg_mmap+0x75/0x75
2013-05-08T08:55:54.393597+02:00 golem kernel: [  430.164344]  [<c01d2e2c>] vfs_ioctl+0x20/0x2a
2013-05-08T08:55:54.393599+02:00 golem kernel: [  430.164344]  [<c01d387c>] do_vfs_ioctl+0x42d/0x46b
2013-05-08T08:55:54.393602+02:00 golem kernel: [  430.164344]  [<c05128e2>] ? __do_page_fault+0x3fb/0x480
2013-05-08T08:55:54.393604+02:00 golem kernel: [  430.164344]  [<c01ce6ea>] ? putname+0x22/0x2b
2013-05-08T08:55:54.393607+02:00 golem kernel: [  430.164344]  [<c01c5e08>] ? do_sys_open+0x174/0x17e
2013-05-08T08:55:54.393610+02:00 golem kernel: [  430.164344]  [<c01b8124>] ? sys_mprotect+0x3e/0x1be
2013-05-08T08:55:54.393613+02:00 golem kernel: [  430.164344]  [<c02e05a4>] ? trace_hardirqs_on_thunk+0xc/0x10
2013-05-08T08:55:54.393615+02:00 golem kernel: [  430.164344]  [<c01d38fb>] sys_ioctl+0x41/0x62
2013-05-08T08:55:54.393618+02:00 golem kernel: [  430.164344]  [<c05103a5>] syscall_call+0x7/0xb
2013-05-08T08:55:54.393621+02:00 golem kernel: [  430.164344] Code: 8b 3d 74 5a 77 c0 85 ff 0f 85 65 ff ff ff e9 74 ff ff ff 8b 45 e8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 3e 8d 74 26 00 83 38 00 74 02 <0f> 0b 8b 50 08 e8 99 fe ff ff 5d c3 55 89 e5 57 56 53 83 ec 0c
2013-05-08T08:55:54.393624+02:00 golem kernel: [  430.164344] EIP: [<c01322c4>] add_timer+0xd/0x19 SS:ESP 0068:eefffb18
2013-05-08T08:55:54.416057+02:00 golem kernel: [  430.228075] ---[ end trace da0355d1654d4ee8 ]---
2013-05-08T08:55:54.446582+02:00 golem sudo:     knut : TTY=pts/1 ; PWD=/home/knut ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 1234567 0
2013-05-08T08:55:56.536059+02:00 golem kernel: [  432.362809] dss1_divert unhandled process

Trace 2, kernel 3.9.1
=====================
2013-05-08T09:01:38.852926+02:00 golem kernel: [    0.000000] Linux version 3.9.1-main (knut@golem.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #14 PREEMPT Wed May 8 08:30:54 CEST 2013
[...]
2013-05-08T09:02:00.545026+02:00 golem sudo:     root : TTY=tty1 ; PWD=/root ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 123456 0
2013-05-08T09:02:00.909859+02:00 golem kernel: [   36.521271] ------------[ cut here ]------------
2013-05-08T09:02:00.960447+02:00 golem sudo:     root : TTY=tty1 ; PWD=/root ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 1234567 0
2013-05-08T09:02:00.960865+02:00 golem kernel: [   36.524424] kernel BUG at kernel/timer.c:909!
2013-05-08T09:02:00.961026+02:00 golem kernel: [   36.524424] invalid opcode: 0000 [#1] PREEMPT 
2013-05-08T09:02:00.961168+02:00 golem kernel: [   36.524424] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat dss1_divert hisax isdn ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 ir_kbd_i2c binfmt_misc isl6421 cx24116 cx88_dvb videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_rc5_decoder rc_hauppauge snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_seq snd_timer snd_seq_device snd_mixer_oss tuner snd cx8800 cx8802 cx88xx v4l2_common videodev rc_core tveeprom videobuf_dma_sg videobuf_core btcx_risc soundcore snd_page_alloc
2013-05-08T09:02:00.961549+02:00 golem kernel: [   36.524424] Pid: 1756, comm: divertctrl Not tainted 3.9.1-main #14    /i915GMm-HFS
2013-05-08T09:02:00.961673+02:00 golem kernel: [   36.524424] EIP: 0060:[<c01322c4>] EFLAGS: 00010282 CPU: 0
2013-05-08T09:02:00.961788+02:00 golem kernel: [   36.524424] EIP is at add_timer+0xd/0x19
2013-05-08T09:02:00.961898+02:00 golem kernel: [   36.524424] EAX: f4557830 EBX: f455782c ECX: fffefeb2 EDX: 00000000
2013-05-08T09:02:00.962016+02:00 golem kernel: [   36.524424] ESI: f4557830 EDI: 000003e8 EBP: f4643b18 ESP: f4643b18
2013-05-08T09:02:00.962134+02:00 golem kernel: [   36.524424]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
2013-05-08T09:02:00.962249+02:00 golem kernel: [   36.524424] CR0: 8005003b CR2: b767c062 CR3: 35e47000 CR4: 000007f0
2013-05-08T09:02:00.962366+02:00 golem kernel: [   36.524424] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
2013-05-08T09:02:00.962484+02:00 golem kernel: [   36.524424] DR6: ffff0ff0 DR7: 00000400
2013-05-08T09:02:00.962592+02:00 golem kernel: [   36.524424] Process divertctrl (pid: 1756, ti=f4642000 task=f4640b20 task.ti=f4642000)
2013-05-08T09:02:00.964349+02:00 golem kernel: [   36.524424] Stack:
2013-05-08T09:02:00.964353+02:00 golem kernel: [   36.524424]  f4643b34 fa0327e4 fa042b00 00001b58 f4557800 fa029767 00000001 f4643b48
2013-05-08T09:02:00.964357+02:00 golem kernel: [   36.524424]  fa0297aa 00000000 00000002 f4557814 f4643b64 fa032657 c050ff9c 00000000
2013-05-08T09:02:00.964360+02:00 golem kernel: [   36.524424]  f4557800 00000009 00000000 f4643b7c fa029fbf f4544000 f4544000 00000246
2013-05-08T09:02:00.964362+02:00 golem kernel: [   36.524424] Call Trace:
2013-05-08T09:02:00.964365+02:00 golem kernel: [   36.524424]  [<fa0327e4>] FsmRestartTimer+0x60/0x6c [hisax]
2013-05-08T09:02:00.964368+02:00 golem kernel: [   36.524424]  [<fa029767>] ? l1b_activate+0x34/0x34 [hisax]
2013-05-08T09:02:00.964371+02:00 golem kernel: [   36.524424]  [<fa0297aa>] l1_power_up_s+0x43/0x5d [hisax]
2013-05-08T09:02:00.964374+02:00 golem kernel: [   36.524424]  [<fa032657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:02:00.964377+02:00 golem kernel: [   36.524424]  [<c050ff9c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
2013-05-08T09:02:00.964379+02:00 golem kernel: [   36.524424]  [<fa029fbf>] l1_msg+0x6b/0xd6 [hisax]
2013-05-08T09:02:00.964382+02:00 golem kernel: [   36.524424]  [<fa038723>] HFCPCI_l1hw+0x25c/0x352 [hisax]
2013-05-08T09:02:00.964385+02:00 golem kernel: [   36.524424]  [<fa029549>] ? l1_timer_deact+0x34/0x34 [hisax]
2013-05-08T09:02:00.964388+02:00 golem kernel: [   36.524424]  [<fa029564>] l1_activate_s+0x1b/0x1e [hisax]
2013-05-08T09:02:00.964391+02:00 golem kernel: [   36.524424]  [<fa032657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:02:00.964394+02:00 golem kernel: [   36.524424]  [<fa02995a>] dch_l2l1+0x9a/0x109 [hisax]
2013-05-08T09:02:00.964397+02:00 golem kernel: [   36.524424]  [<fa02b60d>] isdnl2_l3l2+0xed/0x145 [hisax]
2013-05-08T09:02:00.964399+02:00 golem kernel: [   36.524424]  [<fa02df49>] ? isdnl3_trans+0x14/0x14 [hisax]
2013-05-08T09:02:00.964402+02:00 golem kernel: [   36.524424]  [<fa02df6e>] lc_activate+0x25/0x28 [hisax]
2013-05-08T09:02:00.964405+02:00 golem kernel: [   36.524424]  [<fa032657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:02:00.964408+02:00 golem kernel: [   36.524424]  [<fa02e9aa>] l3_msg+0xc1/0xc4 [hisax]
2013-05-08T09:02:00.964411+02:00 golem kernel: [   36.524424]  [<fa036432>] l3dss1_cmd_global.part.12+0x1e8/0x1ff [hisax]
2013-05-08T09:02:00.964414+02:00 golem kernel: [   36.524424]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:02:00.988530+02:00 golem kernel: last message repeated 2 times
2013-05-08T09:02:00.964423+02:00 golem kernel: [   36.524424]  [<c0157b82>] ? debug_mutex_init+0x26/0x34
2013-05-08T09:02:00.964425+02:00 golem kernel: [   36.524424]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:02:00.988565+02:00 golem kernel: last message repeated 2 times
2013-05-08T09:02:00.964434+02:00 golem kernel: [   36.524424]  [<c0157b82>] ? debug_mutex_init+0x26/0x34
2013-05-08T09:02:00.964437+02:00 golem kernel: [   36.524424]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:02:00.964440+02:00 golem kernel: [   36.524424]  [<c0158acb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:02:00.964443+02:00 golem kernel: [   36.524424]  [<c0302cbf>] ? vgacon_doresize+0x196/0x1ef
2013-05-08T09:02:00.964446+02:00 golem kernel: [   36.524424]  [<c01d8d43>] ? inode_init_always+0x135/0x1e2
2013-05-08T09:02:00.964448+02:00 golem kernel: [   36.524424]  [<fa03646d>] l3dss1_cmd_global+0x24/0x85 [hisax]
2013-05-08T09:02:00.964451+02:00 golem kernel: [   36.524424]  [<fa032385>] HiSax_command+0x8f2/0x949 [hisax]
2013-05-08T09:02:00.964454+02:00 golem kernel: [   36.524424]  [<c02ddd18>] ? string.isra.4+0x30/0xa1
2013-05-08T09:02:00.964457+02:00 golem kernel: [   36.524424]  [<c02deaf0>] ? vsnprintf+0x74/0x27d
2013-05-08T09:02:00.964460+02:00 golem kernel: [   36.524424]  [<c02df1ac>] ? sprintf+0x17/0x19
2013-05-08T09:02:00.964463+02:00 golem kernel: [   36.524424]  [<f9ff73f7>] ? cf_command+0x223/0x280 [dss1_divert]
2013-05-08T09:02:00.964466+02:00 golem kernel: [   36.524424]  [<fa16a824>] isdn_command+0xbd/0xc5 [isdn]
2013-05-08T09:02:00.964468+02:00 golem kernel: [   36.524424]  [<f9ff7402>] cf_command+0x22e/0x280 [dss1_divert]
2013-05-08T09:02:00.964471+02:00 golem kernel: [   36.524424]  [<f9ff84ef>] isdn_divert_ioctl_unlocked.isra.0+0x1af/0x1d8 [dss1_divert]
2013-05-08T09:02:00.964474+02:00 golem kernel: [   36.524424]  [<f9ff853b>] isdn_divert_ioctl+0x23/0x35 [dss1_divert]
2013-05-08T09:02:00.964477+02:00 golem kernel: [   36.524424]  [<f9ff8518>] ? isdn_divert_ioctl_unlocked.isra.0+0x1d8/0x1d8 [dss1_divert]
2013-05-08T09:02:00.964480+02:00 golem kernel: [   36.524424]  [<c0209b71>] proc_reg_unlocked_ioctl+0x62/0x7c
2013-05-08T09:02:00.964483+02:00 golem kernel: [   36.524424]  [<c0209b0f>] ? proc_reg_mmap+0x75/0x75
2013-05-08T09:02:00.964486+02:00 golem kernel: [   36.524424]  [<c01d2e2c>] vfs_ioctl+0x20/0x2a
2013-05-08T09:02:00.964488+02:00 golem kernel: [   36.524424]  [<c01d387c>] do_vfs_ioctl+0x42d/0x46b
2013-05-08T09:02:00.964491+02:00 golem kernel: [   36.524424]  [<c05128e2>] ? __do_page_fault+0x3fb/0x480
2013-05-08T09:02:00.964494+02:00 golem kernel: [   36.524424]  [<c01ce6ea>] ? putname+0x22/0x2b
2013-05-08T09:02:00.964497+02:00 golem kernel: [   36.524424]  [<c01c5e08>] ? do_sys_open+0x174/0x17e
2013-05-08T09:02:00.964500+02:00 golem kernel: [   36.524424]  [<c01b8124>] ? sys_mprotect+0x3e/0x1be
2013-05-08T09:02:00.964502+02:00 golem kernel: [   36.524424]  [<c02e05a4>] ? trace_hardirqs_on_thunk+0xc/0x10
2013-05-08T09:02:00.964505+02:00 golem kernel: [   36.524424]  [<c01d38fb>] sys_ioctl+0x41/0x62
2013-05-08T09:02:00.964508+02:00 golem kernel: [   36.524424]  [<c05103a5>] syscall_call+0x7/0xb
2013-05-08T09:02:00.964511+02:00 golem kernel: [   36.524424] Code: 8b 3d 74 5a 77 c0 85 ff 0f 85 65 ff ff ff e9 74 ff ff ff 8b 45 e8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 3e 8d 74 26 00 83 38 00 74 02 <0f> 0b 8b 50 08 e8 99 fe ff ff 5d c3 55 89 e5 57 56 53 83 ec 0c
2013-05-08T09:02:00.964515+02:00 golem kernel: [   36.524424] EIP: [<c01322c4>] add_timer+0xd/0x19 SS:ESP 0068:f4643b18
2013-05-08T09:02:00.964529+02:00 golem kernel: [   36.877245] ---[ end trace f778d13fd0396fa7 ]---
2013-05-08T09:02:04.567380+02:00 golem kernel: [   40.528027] dss1_divert unhandled process

Trace 3, kernel 3.9.0
=====================
2013-05-08T09:03:51.932890+02:00 golem kernel: [    0.000000] Linux version 3.9.0-main (knut@golem.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #5 PREEMPT Mon Apr 29 10:00:01 CEST 2013
[...]
2013-05-08T09:04:02.933096+02:00 golem sudo:     root : TTY=tty1 ; PWD=/root ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 123456 0
2013-05-08T09:04:03.174028+02:00 golem kernel: [   26.212698] ------------[ cut here ]------------
2013-05-08T09:04:03.223535+02:00 golem sudo:     root : TTY=tty1 ; PWD=/root ; USER=root ; COMMAND=/usr/sbin/divertctrl wait interrogate HiSax cfu 1234567 0
2013-05-08T09:04:03.223939+02:00 golem kernel: [   26.215732] kernel BUG at kernel/timer.c:909!
2013-05-08T09:04:03.224101+02:00 golem kernel: [   26.216028] invalid opcode: 0000 [#1] PREEMPT 
2013-05-08T09:04:03.224215+02:00 golem kernel: [   26.216028] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat dss1_divert hisax isdn ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 binfmt_misc ir_kbd_i2c isl6421 cx24116 cx88_dvb videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_rc5_decoder rc_hauppauge snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_seq tuner snd_timer snd_seq_device snd_mixer_oss cx8802 cx8800 cx88xx snd v4l2_common videodev rc_core tveeprom videobuf_dma_sg btcx_risc videobuf_core soundcore snd_page_alloc
2013-05-08T09:04:03.224595+02:00 golem kernel: [   26.216028] Pid: 1749, comm: divertctrl Not tainted 3.9.0-main #5    /i915GMm-HFS
2013-05-08T09:04:03.224717+02:00 golem kernel: [   26.216028] EIP: 0060:[<c01322d4>] EFLAGS: 00010282 CPU: 0
2013-05-08T09:04:03.224831+02:00 golem kernel: [   26.216028] EIP is at add_timer+0xd/0x19
2013-05-08T09:04:03.224938+02:00 golem kernel: [   26.216028] EAX: f3453830 EBX: f345382c ECX: fffef4a1 EDX: 00000000
2013-05-08T09:04:03.225055+02:00 golem kernel: [   26.216028] ESI: f3453830 EDI: 000003e8 EBP: f5e75b18 ESP: f5e75b18
2013-05-08T09:04:03.225172+02:00 golem kernel: [   26.216028]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
2013-05-08T09:04:03.225285+02:00 golem kernel: [   26.216028] CR0: 8005003b CR2: b766d062 CR3: 35925000 CR4: 000007f0
2013-05-08T09:04:03.225401+02:00 golem kernel: [   26.216028] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
2013-05-08T09:04:03.225517+02:00 golem kernel: [   26.216028] DR6: ffff0ff0 DR7: 00000400
2013-05-08T09:04:03.225624+02:00 golem kernel: [   26.216028] Process divertctrl (pid: 1749, ti=f5e74000 task=f3622820 task.ti=f5e74000)
2013-05-08T09:04:03.227719+02:00 golem kernel: [   26.216028] Stack:
2013-05-08T09:04:03.227725+02:00 golem kernel: [   26.216028]  f5e75b34 fa0597e4 fa069b00 00001b58 f3453800 fa050767 00000001 f5e75b48
2013-05-08T09:04:03.227728+02:00 golem kernel: [   26.216028]  fa0507aa 00000000 00000002 f3453814 f5e75b64 fa059657 c050f53c 00000000
2013-05-08T09:04:03.227731+02:00 golem kernel: [   26.216028]  f3453800 00000009 00000000 f5e75b7c fa050fbf f3523000 f3523000 00000246
2013-05-08T09:04:03.227734+02:00 golem kernel: [   26.216028] Call Trace:
2013-05-08T09:04:03.227736+02:00 golem kernel: [   26.216028]  [<fa0597e4>] FsmRestartTimer+0x60/0x6c [hisax]
2013-05-08T09:04:03.227739+02:00 golem kernel: [   26.216028]  [<fa050767>] ? l1b_activate+0x34/0x34 [hisax]
2013-05-08T09:04:03.227742+02:00 golem kernel: [   26.216028]  [<fa0507aa>] l1_power_up_s+0x43/0x5d [hisax]
2013-05-08T09:04:03.227745+02:00 golem kernel: [   26.216028]  [<fa059657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:04:03.227748+02:00 golem kernel: [   26.216028]  [<c050f53c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
2013-05-08T09:04:03.227751+02:00 golem kernel: [   26.216028]  [<fa050fbf>] l1_msg+0x6b/0xd6 [hisax]
2013-05-08T09:04:03.227754+02:00 golem kernel: [   26.216028]  [<fa05f723>] HFCPCI_l1hw+0x25c/0x352 [hisax]
2013-05-08T09:04:03.227756+02:00 golem kernel: [   26.216028]  [<fa050549>] ? l1_timer_deact+0x34/0x34 [hisax]
2013-05-08T09:04:03.227759+02:00 golem kernel: [   26.216028]  [<fa050564>] l1_activate_s+0x1b/0x1e [hisax]
2013-05-08T09:04:03.227762+02:00 golem kernel: [   26.216028]  [<fa059657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:04:03.227765+02:00 golem kernel: [   26.216028]  [<fa05095a>] dch_l2l1+0x9a/0x109 [hisax]
2013-05-08T09:04:03.227767+02:00 golem kernel: [   26.216028]  [<fa05260d>] isdnl2_l3l2+0xed/0x145 [hisax]
2013-05-08T09:04:03.227770+02:00 golem kernel: [   26.216028]  [<fa054f49>] ? isdnl3_trans+0x14/0x14 [hisax]
2013-05-08T09:04:03.227773+02:00 golem kernel: [   26.216028]  [<fa054f6e>] lc_activate+0x25/0x28 [hisax]
2013-05-08T09:04:03.227776+02:00 golem kernel: [   26.216028]  [<fa059657>] FsmEvent+0x77/0xa8 [hisax]
2013-05-08T09:04:03.227779+02:00 golem kernel: [   26.216028]  [<fa0559aa>] l3_msg+0xc1/0xc4 [hisax]
2013-05-08T09:04:03.227782+02:00 golem kernel: [   26.216028]  [<fa05d432>] l3dss1_cmd_global.part.12+0x1e8/0x1ff [hisax]
2013-05-08T09:04:03.227784+02:00 golem kernel: [   26.216028]  [<c0158abb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:04:03.251524+02:00 golem kernel: last message repeated 2 times
2013-05-08T09:04:03.227793+02:00 golem kernel: [   26.216028]  [<c0157b72>] ? debug_mutex_init+0x26/0x34
2013-05-08T09:04:03.227796+02:00 golem kernel: [   26.216028]  [<c0158abb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:04:03.251560+02:00 golem kernel: last message repeated 2 times
2013-05-08T09:04:03.227804+02:00 golem kernel: [   26.216028]  [<c0157b72>] ? debug_mutex_init+0x26/0x34
2013-05-08T09:04:03.227807+02:00 golem kernel: [   26.216028]  [<c0158abb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:04:03.227810+02:00 golem kernel: [   26.216028]  [<c0158abb>] ? lockdep_init_map+0x382/0x397
2013-05-08T09:04:03.227813+02:00 golem kernel: [   26.216028]  [<c03018de>] ? fb_var_to_videomode+0x58/0xc1
2013-05-08T09:04:03.227815+02:00 golem kernel: [   26.216028]  [<c01d8d5b>] ? inode_init_always+0x135/0x1e2
2013-05-08T09:04:03.227818+02:00 golem kernel: [   26.216028]  [<fa05d46d>] l3dss1_cmd_global+0x24/0x85 [hisax]
2013-05-08T09:04:03.227821+02:00 golem kernel: [   26.216028]  [<fa059385>] HiSax_command+0x8f2/0x949 [hisax]
2013-05-08T09:04:03.227824+02:00 golem kernel: [   26.216028]  [<c02ddc20>] ? string.isra.4+0x30/0xa1
2013-05-08T09:04:03.227826+02:00 golem kernel: [   26.216028]  [<c02de9f8>] ? vsnprintf+0x74/0x27d
2013-05-08T09:04:03.227829+02:00 golem kernel: [   26.216028]  [<c02df0b4>] ? sprintf+0x17/0x19
2013-05-08T09:04:03.227832+02:00 golem kernel: [   26.216028]  [<f9efb3f7>] ? cf_command+0x223/0x280 [dss1_divert]
2013-05-08T09:04:03.227835+02:00 golem kernel: [   26.216028]  [<fa191824>] isdn_command+0xbd/0xc5 [isdn]
2013-05-08T09:04:03.227838+02:00 golem kernel: [   26.216028]  [<f9efb402>] cf_command+0x22e/0x280 [dss1_divert]
2013-05-08T09:04:03.227841+02:00 golem kernel: [   26.216028]  [<f9efc4ef>] isdn_divert_ioctl_unlocked.isra.0+0x1af/0x1d8 [dss1_divert]
2013-05-08T09:04:03.227844+02:00 golem kernel: [   26.216028]  [<f9efc53b>] isdn_divert_ioctl+0x23/0x35 [dss1_divert]
2013-05-08T09:04:03.227847+02:00 golem kernel: [   26.216028]  [<f9efc518>] ? isdn_divert_ioctl_unlocked.isra.0+0x1d8/0x1d8 [dss1_divert]
2013-05-08T09:04:03.227850+02:00 golem kernel: [   26.216028]  [<c0209b69>] proc_reg_unlocked_ioctl+0x62/0x7c
2013-05-08T09:04:03.227852+02:00 golem kernel: [   26.216028]  [<c0209b07>] ? proc_reg_mmap+0x75/0x75
2013-05-08T09:04:03.227855+02:00 golem kernel: [   26.216028]  [<c01d2e48>] vfs_ioctl+0x20/0x2a
2013-05-08T09:04:03.227858+02:00 golem kernel: [   26.216028]  [<c01d3898>] do_vfs_ioctl+0x42d/0x46b
2013-05-08T09:04:03.227861+02:00 golem kernel: [   26.216028]  [<c0511e82>] ? __do_page_fault+0x3fb/0x480
2013-05-08T09:04:03.227864+02:00 golem kernel: [   26.216028]  [<c01ce706>] ? putname+0x22/0x2b
2013-05-08T09:04:03.227866+02:00 golem kernel: [   26.216028]  [<c01c5e2c>] ? do_sys_open+0x174/0x17e
2013-05-08T09:04:03.227869+02:00 golem kernel: [   26.216028]  [<c01b8124>] ? mprotect_fixup+0x17f/0x1bd
2013-05-08T09:04:03.227872+02:00 golem kernel: [   26.216028]  [<c02e04b4>] ? trace_hardirqs_on_thunk+0xc/0x10
2013-05-08T09:04:03.227875+02:00 golem kernel: [   26.216028]  [<c01d3917>] sys_ioctl+0x41/0x62
2013-05-08T09:04:03.227877+02:00 golem kernel: [   26.216028]  [<c050f945>] syscall_call+0x7/0xb
2013-05-08T09:04:03.227881+02:00 golem kernel: [   26.216028] Code: 8b 3d b4 37 77 c0 85 ff 0f 85 65 ff ff ff e9 74 ff ff ff 8b 45 e8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 3e 8d 74 26 00 83 38 00 74 02 <0f> 0b 8b 50 08 e8 99 fe ff ff 5d c3 55 89 e5 57 56 53 83 ec 0c
2013-05-08T09:04:03.227884+02:00 golem kernel: [   26.216028] EIP: [<c01322d4>] add_timer+0xd/0x19 SS:ESP 0068:f5e75b18
2013-05-08T09:04:03.227898+02:00 golem kernel: [   26.443966] ---[ end trace 3a1f744f8905c0a4 ]---
2013-05-08T09:04:06.600235+02:00 golem kernel: [   29.863667] dss1_divert unhandled process

--------------070301080304050308010205--
