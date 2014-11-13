Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaKMKGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:06:19 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51657 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaKMKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:06:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAPkZ-dgP-GckqgGE2ziLE_DBof+nc_1t=3q9p2oARa=ZALnuaw@mail.gmail.com>
References: <CAPkZ-dgP-GckqgGE2ziLE_DBof+nc_1t=3q9p2oARa=ZALnuaw@mail.gmail.com>
Date: Thu, 13 Nov 2014 15:36:15 +0530
Message-ID: <CAPkZ-djFtAt4QhpUbUa9E__O8NFt0sjY+bS3VR5FR_FOPOhYmg@mail.gmail.com>
Subject: Fwd: Oops in hrtime
From: Ram Thombare <coolnick70@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guys,

I am trying to root cause an oops on 3.0.35 kernel,  killing a process
in whose context a call being made.
Interestingly it is happening for sleep sys call in hrtimer.

00:31:59.689 kernel[] Alert (: ) [ 1919.340296] Unable to handle
kernel paging request at virtual address 646f4d20
00:31:59.689 kernel[] Alert (: ) [ 1919.340317] pgd = ba080000
00:31:59.689 kernel[] Alert (: ) [ 1919.340327] [646f4d20] *pgd=00000000
00:31:59.689 kernel[] Fatal (: ) [ 1919.340348] Internal error: Oops:
5 [#1] PREEMPT SMP
00:31:59.689 kernel[] Debug (: ) [ 1919.345325] Modules linked in:
nls_iso8859_1 nls_cp437 wl12xx_sdio wl12xx mac80211 cfg80211 compat
asix usbnet fec smsc xt_limit xt_tcpudp nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables
i2c_session snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi usbhid
hid mx6_bt_rfkill rfkill leds_gpio rtc_snvs mxc_asrc
snd_soc_imx_wl1285q snd_soc_imx_tlv320aic310x snd_soc_imx_mx2
snd_soc_wl1285q snd_soc_tlv320aic310x ipv6 mxs_viim usb_oc mmc_block
sdhci_platform sdhci mmc_core galcore serio
com.jci.cpp.drivers.GpioChip uinput cmu_io dsrc_acm evdev
com.jci.cpp.drivers.Log spidev relfs reliance(P) relos ffxblk
flashfx(P) ffxos com.jci.cpp.drivers.lvds_drv com_jci_cpp_nvram
com_jci
00:31:59.689 kernel[] Debug (: ) [ 1919.409104] CPU: 0    Tainted: P
         (3.0.35 #1)
00:31:59.706 kernel[] Debug (: ) [ 1919.414435] PC is at
lock_hrtimer_base.clone.14+0x28/0x58
00:31:59.706 kernel[] Debug (: ) [ 1919.419844] LR is at
hrtimer_try_to_cancel+0x28/0x13c
00:31:59.706 kernel[] Debug (: ) [ 1919.424906] pc : [<8009a8a0>]
lr : [<8009a964>]    psr: 20000013
00:31:59.706 kernel[] Debug (: ) [ 1919.424912] sp : ba073e98  ip :
ba073eb8  fp : ba073eb4
00:31:59.706 kernel[] Debug (: ) [ 1919.436406] r10: 8010b1a0  r9 :
ba073f10  r8 : 8007cea0
00:31:59.706 kernel[] Debug (: ) [ 1919.441638] r7 : bfb8f640  r6 :
646f4d20  r5 : ba073ebc  r4 : bfb83f24
00:31:59.706 kernel[] Debug (: ) [ 1919.448174] r3 : 00000000  r2 :
00000001  r1 : ba073ebc  r0 : bfb83f24
00:31:59.706 kernel[] Debug (: ) [ 1919.454711] Flags: nzCv  IRQs on
FIQs on  Mode SVC_32  ISA ARM  Segment user
00:31:59.706 kernel[] Debug (: ) [ 1919.461855] Control: 10c53c7d
Table: 4a08004a  DAC: 00000015
00:31:59.706 kernel[] Fatal (: ) [ 1919.467609] Process LVDS_IntMon
(pid: 61, stack limit = 0xba0722f0)
00:31:59.710 kernel[] Fatal (: ) [ 1919.473884] Stack: (0xba073e98 to
0xba074000)
00:31:59.710 kernel[] Fatal (: ) [ 1919.478249] 3e80:
                                    00000000 bfb83f00
00:31:59.710 kernel[] Fatal (: ) [ 1919.486439] 3ea0: 804d04b0
bfb83f00 ba073edc ba073eb8 8009a964 8009a884 ba072000 000f4240
00:31:59.710 kernel[] Fatal (: ) [ 1919.494628] 3ec0: bfb83f00
804d04b0 bfb83f00 bfb8f640 ba073ef4 ba073ee0 8009aa98 8009a948
00:31:59.710 kernel[] Fatal (: ) [ 1919.502818] 3ee0: 00000000
000f4240 ba073f24 ba073ef8 80351344 8009aa84 0000c350 00000001
00:31:59.710 kernel[] Fatal (: ) [ 1919.511007] 3f00: 00000001
00000000 0000c350 ba073f88 00000001 00100590 ba073f84 ba073f28
00:31:59.710 kernel[] Fatal (: ) [ 1919.519196] 3f20: 8009b9c4
803512bc ba073f28 00000000 00000000 00000000 e08ea6df 000001be
00:31:59.710 kernel[] Fatal (: ) [ 1919.527385] 3f40: e08de38f
000001be 8009a13c 8c0083b8 00000000 00000000 00000000 8004600c
00:31:59.710 kernel[] Fatal (: ) [ 1919.535574] 3f60: 00000000
00000001 2ad1b684 000000a2 80046284 ba072000 ba073fa4 ba073f88
00:31:59.710 kernel[] Fatal (: ) [ 1919.543763] 3f80: 8009baf0
8009b918 00000000 000f4240 800461d8 000454ac 00000000 ba073fa8
00:31:59.746 kernel[] Fatal (: ) [ 1919.551952] 3fa0: 80046000
8009ba5c 000454ac 00000001 2ad1ab30 00000000 2ad1b4f4 00000000
00:31:59.746 kernel[] Fatal (: ) [ 1919.560141] 3fc0: 000454ac
00000001 2ad1b684 000000a2 00000000 2ab2d4c0 7eedad48 2ad1ac64
00:31:59.746 kernel[] Fatal (: ) [ 1919.568330] 3fe0: 00000000
2ad1ab28 2aca6bdc 2ac67224 80000010 2ad1ab30 19c6b019 4126a03c
00:31:59.746 kernel[] Debug (: ) [ 1919.576513] Backtrace:
00:31:59.746 kernel[] Debug (: ) [ 1919.578988] [<8009a878>]
(lock_hrtimer_base.clone.14+0x0/0x58) from [<8009a964>]
(hrtimer_try_to_cancel+0x28/0x13c)
00:31:59.746 kernel[] Debug (: ) [ 1919.589432]  r6:bfb83f00
r5:804d04b0 r4:bfb83f00 r3:00000000
00:31:59.746 kernel[] Debug (: ) [ 1919.595165] [<8009a93c>]
(hrtimer_try_to_cancel+0x0/0x13c) from [<8009aa98>]
(hrtimer_cancel+0x20/0x30)
00:31:59.746 kernel[] Debug (: ) [ 1919.604565]  r7:bfb8f640
r6:bfb83f00 r5:804d04b0 r4:bfb83f00
00:31:59.746 kernel[] Debug (: ) [ 1919.610306] [<8009aa78>]
(hrtimer_cancel+0x0/0x30) from [<80351344>] (do_nanosleep+0x94/0xe8)
00:31:59.746 kernel[] Debug (: ) [ 1919.618838]  r4:000f4240 r3:00000000
00:31:59.749 kernel[] Debug (: ) [ 1919.622456] [<803512b0>]
(do_nanosleep+0x0/0xe8) from [<8009b9c4>]
(hrtimer_nanosleep+0xb8/0x144)
00:31:59.749 kernel[] Debug (: ) [ 1919.631335]  r8:00100590
r7:00000001 r6:ba073f88 r5:0000c350 r4:00000000
00:31:59.749 kernel[] Debug (: ) [ 1919.638125] [<8009b90c>]
(hrtimer_nanosleep+0x0/0x144) from [<8009baf0>]
(sys_nanosleep+0xa0/0xbc)
00:31:59.749 kernel[] Debug (: ) [ 1919.647091]  r9:ba072000
r8:80046284 r7:000000a2 r6:2ad1b684 r5:00000001
00:31:59.749 kernel[] Debug (: ) [ 1919.653686] r4:00000000
00:31:59.749 kernel[] Debug (: ) [ 1919.656349] [<8009ba50>]
(sys_nanosleep+0x0/0xbc) from [<80046000>] (ret_fast_syscall+0x0/0x48)
00:31:59.749 kernel[] Debug (: ) [ 1919.665055]  r4:000454ac
00:31:59.749 kernel[] Fatal (: ) [ 1919.667612] Code: e1a05001
e5946000 e3560000 0a00000a (e5960000)
00:31:59.749 kernel[] Warn (: ) [ 1919.730410] ---[ end trace
f8bf088220f93213 ]---

Seems it happened while accessing "cpu_base" below.
raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);

Can anyone please share idea how to root cause such issues.

Thanks,
