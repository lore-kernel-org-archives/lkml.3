Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbbAILtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:49:21 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38506 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376AbbAILtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:49:19 -0500
From: "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>
To: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Subject: unload Audio drivers while playback stream is active case kernel
 crash
Thread-Topic: unload Audio drivers while playback stream is active case
 kernel crash
Thread-Index: AdAsAkP1BeegHPxWQP2d6MzZJ6iyyA==
Date: Fri, 9 Jan 2015 11:49:17 +0000
Message-ID: <857E9EDCA6C0904DB3357321AA9123EB0108B669D9@NA-MBX-01.mgc.mentorg.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.34.91.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Community

Sorry previous email doesn't have formatted crash log.

I am using i.MX6Q sabreSD board, which have imx_wm892 machine driver, wm8962 codec and SSI CPU DAI,

I got Kernel crash when unloading audio drivers (playback stream is active)

modprobe -r snd_soc_imx_wm8962
modprobe -r snd_soc_fsl_ssi
modprobe -r snd_soc_wm8962

#########################
[   31.363894] wm8962 0-001a: Failed to read DSPCLK: -1
[   31.386320] wm8962 0-001a: Failed to read DCS status: -1
[   31.417252] Unable to handle kernel NULL pointer dereference at virtual address 0000001c
[   31.425380] pgd = 80004000
[   31.428154] [0000001c] *pgd=00000000
[   31.431796] Internal error: Oops: 17 [#1] SMP ARM
[   31.436527] Modules linked in: snd_soc_imx_audmux snd_soc_wm8962 snd_soc_fsl_ssi imx_pcm_fiq evbug]
[   31.448764] CPU: 3 PID: 380 Comm: kworker/3:3 Not tainted 3.19.0-rc3-00069-g11c8f01-dirty #8
[   31.457210] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   31.463763] Workqueue: events_power_efficient close_delayed_work
[   31.469792] task: be20ce00 ti: bbe20000 task.ti: bbe20000
[   31.475202] PC is at soc_dapm_dai_stream_event+0x14/0xac
[   31.480522] LR is at snd_soc_dapm_stream_event+0x64/0x90
[   31.485842] pc : [<8052b298>]    lr : [<8052e5cc>]    psr: 60000013
[   31.485842] sp : bbe21e38  ip : bbe21e50  fp : bbe21e4c
[   31.497324] r10: 00000001  r9 : 00000000  r8 : bd449ccc
[   31.502555] r7 : 00000000  r6 : 00000002  r5 : 00000002  r4 : 00000000
[   31.509087] r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000000
[   31.515622] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   31.522936] Control: 10c5387d  Table: 4d42004a  DAC: 00000015
[   31.528689] Process kworker/3:3 (pid: 380, stack limit = 0xbbe20238)
[   31.535048] Stack: (0xbbe21e38 to 0xbbe22000)
[   31.539412] 1e20:                                                       00000000 ba945810
[   31.547599] 1e40: bbe21e74 bbe21e50 8052e5cc 8052b290 00000000 ba945dd4 ba94581c ba945810
[   31.555785] 1e60: bbe21eb0 be7c0c00 bbe21e94 bbe21e78 80530038 8052e574 8052ffec bd585680
[   31.563971] 1e80: ba945dd4 be7bd380 bbe21eec bbe21e98 8003ef74 8052fff8 00000001 00000000
[   31.572158] 1ea0: 8003ef08 8003f294 00000000 00000000 811d1670 80b33330 00000000 808b61c0
[   31.580344] 1ec0: 806bac24 bd585680 be7bd3b0 809c7882 bd585698 00000008 be7bd380 be7bd380
[   31.588529] 1ee0: bbe21f24 bbe21ef0 8003f388 8003edec bdad17c0 bd585680 8003f228 00000000
[   31.596715] 1f00: bdad17c0 bd585680 8003f228 00000000 00000000 00000000 bbe21fac bbe21f28
[   31.604902] 1f20: 800446cc 8003f234 bbe21f44 00000000 80062798 bd585680 00000000 00000000
[   31.613087] 1f40: dead4ead ffffffff ffffffff 809c9f34 00000000 00000000 80838390 bbe21f5c
[   31.621275] 1f60: bbe21f5c 00000000 00000000 dead4ead ffffffff ffffffff 809c9f34 00000000
[   31.629461] 1f80: 00000000 80838390 bbe21f88 bbe21f88 bdad17c0 800445f0 00000000 00000000
[   31.637648] 1fa0: 00000000 bbe21fb0 8000ed68 800445fc 00000000 00000000 00000000 00000000
[   31.645834] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   31.654019] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   31.662200] Backtrace: 
[   31.664680] [<8052b284>] (soc_dapm_dai_stream_event) from [<8052e5cc>] (snd_soc_dapm_stream_event+)
[   31.674512]  r5:ba945810 r4:00000000
[   31.678134] [<8052e568>] (snd_soc_dapm_stream_event) from [<80530038>] (close_delayed_work+0x4c/0x)
[   31.687358]  r8:be7c0c00 r7:bbe21eb0 r6:ba945810 r5:ba94581c r4:ba945dd4 r3:00000000
[   31.695206] [<8052ffec>] (close_delayed_work) from [<8003ef74>] (process_one_work+0x194/0x40c)
[   31.703821]  r6:be7bd380 r5:ba945dd4 r4:bd585680 r3:8052ffec
[   31.709558] [<8003ede0>] (process_one_work) from [<8003f388>] (worker_thread+0x160/0x48c)
[   31.717739]  r10:be7bd380 r9:be7bd380 r8:00000008 r7:bd585698 r6:809c7882 r5:be7bd3b0
[   31.725659]  r4:bd585680
[   31.728220] [<8003f228>] (worker_thread) from [<800446cc>] (kthread+0xdc/0xf8)
[   31.735447]  r10:00000000 r9:00000000 r8:00000000 r7:8003f228 r6:bd585680 r5:bdad17c0
[   31.743365]  r4:00000000
[   31.745931] [<800445f0>] (kthread) from [<8000ed68>] (ret_from_fork+0x14/0x2c)
[   31.753158]  r7:00000000 r6:00000000 r5:800445f0 r4:bdad17c0
[   31.758895] Code: e92dd830 e24cb004 e3510000 e1a05002 (0590401c) 
[   31.765088] ---[ end trace c7913ba4763772ee ]---

Seems it's because when playback stream is active
soc_cleanup_card_resources()
  -> snd_card_free()
Will trigger soc_pcm_close() which will queue close_delayed_work(), and then when close_delayed_work() is scheduled the necessary resource has already been released.

I tried to set rtd->pmdown_time to 0 in soc_cleanup_card_resources() to avoid any new delayed_work be queued.
BUT when unload audio drivers, I got another kernel crash

#########################
[   28.234740] Unable to handle kernel paging request at virtual address 6faaaf90
[   28.242075] pgd = bbde0000
[   28.244818] [6faaaf90] *pgd=00000000
[   28.248511] Internal error: Oops: 5 [#1] SMP ARM
[   28.253155] Modules linked in: snd_soc_imx_wm8962(-) snd_soc_imx_audmux snd_soc_wm8962 snd_soc_fsl]
[   28.267055] CPU: 1 PID: 188 Comm: pulseaudio Not tainted 3.19.0-rc3-00069-g11c8f01-dirty #7
[   28.275435] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   28.281991] task: bc3e1d40 ti: bbc1e000 task.ti: bbc1e000
[   28.287431] PC is at dapm_seq_insert+0x34/0xf4
[   28.291902] LR is at dapm_power_widgets+0x234/0x798
[   28.296809] pc : [<8052ad74>]    lr : [<8052d090>]    psr: 600f0113
[   28.296809] sp : bbc1fdd0  ip : 809bdd90  fp : bbc1fdec
[   28.308308] r10: bbc3bb90  r9 : bc0405c4  r8 : bc0405ac
[   28.313554] r7 : bbc1fe24  r6 : 809bdd90  r5 : bbc3b480  r4 : bbc3b134
[   28.320093] r3 : bbc3b0c0  r2 : 00000000  r1 : bbc1fe1c  r0 : bbc3bb40
[   28.326628] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   28.333771] Control: 10c5387d  Table: 4bde004a  DAC: 00000015
[   28.339524] Process pulseaudio (pid: 188, stack limit = 0xbbc1e238)
[   28.345797] Stack: (0xbbc1fdd0 to 0xbbc20000)
[   28.350162] fdc0:                                     00000000 bbc3bb40 bbc3bba4 bbc1fe24
[   28.358349] fde0: bbc1fe5c bbc1fdf0 8052d090 8052ad4c 80062798 8006259c bbc1fe5c 00000002
[   28.366535] fe00: bc04046c bc0405bc bbc1fe1c bbc1fe14 bbc1fe44 bbc1fe14 bbc1fe14 bbc3b134
[   28.374721] fe20: bbc3b134 bbc1fe24 bbc1fe24 bbc3bb40 00000004 00000001 bd916010 00000002
[   28.382907] fe40: 00000000 bc0404cc 00000000 bd91601c bbc1fe84 bbc1fe60 8052e5f4 8052ce68
[   28.391093] fe60: 00000000 bd916010 00000000 bc2c5a00 bbebb800 bdbe720c bbc1feac bbc1fe88
[   28.399279] fe80: 805317cc 8052e57c bc2c5a00 bc2c5a00 bc3d9b80 bbdf7640 bc2c4ae8 00000008
[   28.407465] fea0: bbc1fec4 bbc1feb0 8051b610 80531664 bc2c4a00 bc2c5a00 bbc1feec bbc1fec8
[   28.415651] fec0: 8051b6a0 8051b5c0 8051b664 bbdf75c0 809bd508 bc3d9b80 bdba8f30 bdba8f30
[   28.423837] fee0: bbc1ff0c bbc1fef0 8050eb2c 8051b670 bc3d9b80 bdba8f30 bd9b9850 bb8f75c0
[   28.432023] ff00: bbc1ff4c bbc1ff10 800ef5bc 8050ea50 00000000 00000000 80042d68 bc3d9b88
[   28.440208] ff20: bc3d9b80 bc3e20f0 00000000 809c9f14 bc3e1d40 00000000 bbc1e000 00000000
[   28.448393] ff40: bbc1ff5c bbc1ff50 800ef760 800ef538 bbc1ff84 bbc1ff60 80042ec0 800ef75c
[   28.456579] ff60: bc3d9b80 8000ee64 bbc1ffb0 00000000 00000006 8000ee64 bbc1ffac bbc1ff88
[   28.464765] ff80: 80011884 80042e14 8000ecac 00000004 00000000 0116aa50 0116ab58 0118e100
[   28.472950] ffa0: 00000000 bbc1ffb0 8000ecf8 800117dc 00000000 76fcf084 76fcf4c0 725fcc94
[   28.481136] ffc0: 0116aa50 0116ab58 0118e100 00000006 01118168 4ce839e4 00000000 00000000
[   28.489322] ffe0: 00000000 7e957978 4e1e6d24 4e1e6d34 800f0010 00000016 4eff6821 4eff6c21
[   28.497501] Backtrace: 
[   28.499980] [<8052ad40>] (dapm_seq_insert) from [<8052d090>] (dapm_power_widgets+0x234/0x798)
[   28.508509]  r7:bbc1fe24 r6:bbc3bba4 r5:bbc3bb40 r4:00000000
[   28.514251] [<8052ce5c>] (dapm_power_widgets) from [<8052e5f4>] (snd_soc_dapm_stream_event+0x84/0x)
[   28.523473]  r10:bd91601c r9:00000000 r8:bc0404cc r7:00000000 r6:00000002 r5:bd916010
[   28.531393]  r4:00000001
[   28.533959] [<8052e570>] (snd_soc_dapm_stream_event) from [<805317cc>] (soc_pcm_close+0x174/0x28c)
[   28.542920]  r8:bdbe720c r7:bbebb800 r6:bc2c5a00 r5:00000000 r4:bd916010 r3:00000000
[   28.550764] [<80531658>] (soc_pcm_close) from [<8051b610>] (snd_pcm_release_substream+0x5c/0xb0)
[   28.559552]  r10:00000008 r8:bc2c4ae8 r7:bbdf7640 r6:bc3d9b80 r5:bc2c5a00 r4:bc2c5a00
[   28.567479] [<8051b5b4>] (snd_pcm_release_substream) from [<8051b6a0>] (snd_pcm_release+0x3c/0x88)
[   28.576440]  r5:bc2c5a00 r4:bc2c4a00
[   28.580062] [<8051b664>] (snd_pcm_release) from [<8050eb2c>] (snd_disconnect_release+0xe8/0xf8)
[   28.588764]  r8:bdba8f30 r7:bdba8f30 r6:bc3d9b80 r5:809bd508 r4:bbdf75c0 r3:8051b664
[   28.596604] [<8050ea44>] (snd_disconnect_release) from [<800ef5bc>] (__fput+0x90/0x1d4)
[   28.604611]  r7:bb8f75c0 r6:bd9b9850 r5:bdba8f30 r4:bc3d9b80
[   28.610345] [<800ef52c>] (__fput) from [<800ef760>] (____fput+0x10/0x14)
[   28.617050]  r10:00000000 r9:bbc1e000 r8:00000000 r7:bc3e1d40 r6:809c9f14 r5:00000000
[   28.624968]  r4:bc3e20f0
[   28.627535] [<800ef750>] (____fput) from [<80042ec0>] (task_work_run+0xb8/0xe8)
[   28.634865] [<80042e08>] (task_work_run) from [<80011884>] (do_work_pending+0xb4/0xd4)
[   28.642786]  r8:8000ee64 r7:00000006 r6:00000000 r5:bbc1ffb0 r4:8000ee64 r3:bc3d9b80
[   28.650624] [<800117d0>] (do_work_pending) from [<8000ecf8>] (work_pending+0xc/0x20)
[   28.658371]  r6:0118e100 r5:0116ab58 r4:0116aa50
[   28.663047] Code: e5905000 e3520000 e24c6070 01a0600c (e7965105) 
[   28.669220] ---[ end trace 69b76cbdebd80b05 ]---

>From the backtrace, seems it's because
when soc_pcm_close() is called, it will power widget due to stream event, but at that time, all widgets have already been freed by soc_remove_dai_links()

Currently I am out of idea how to fix this issue, As I think this is a generic issue not i.MX platform specific, Someone in community may has already find this issue,

Could anyone give some inputs/suggestion to fix this issue?


Regards & Thanks,
Jiada
