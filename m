Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3BJNXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 08:23:53 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38227 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786Ab3BJNXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 08:23:52 -0500
Message-ID: <1360502649.3834.5.camel@palomino.walls.org>
Subject: Re: possible recursive locking: find_ref_lock() /
 v4l2_ctrl_add_handler()
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 10 Feb 2013 08:24:09 -0500
In-Reply-To: <201302101154.57033.hverkuil@xs4all.nl>
References: <511777A3.6000506@t-online.de>
	 <201302101154.57033.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-10_04:2013-02-08,2013-02-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1211240000 definitions=main-1302100100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-10 at 11:54 +0100, Hans Verkuil wrote:
> On Sun February 10 2013 11:34:11 Knut Petersen wrote:
> > Maybe somebody could have at that old locking warning:
> 
> It's a false warning. If someone can point me to some documentation on how to
> tell lockdep that it isn't a deadlock, then that would be appreciated.

Hi Hans,

Here you go, an old patch for you:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/27027

Be warned, if lockdep has a limit on the number of classes it can
handle, then my patch could be a problem with a large number of drivers
with v4l2_ctrl_handlers loaded. I must emphasize, that is a new lock
classes per driver instance, not per hardware device instance ... IIRC.

FYI, here's some context that led up to me making the patch:
http://www.gossamer-threads.com/lists/ivtv/devel/41525#41525

Regards,
Andy

> Regards,
> 
> 	Hans
> 
> > 
> > [    9.761427] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
> > [    9.782848] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
> > [    9.794205] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
> > [    9.879194] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
> > [    9.914871] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
> > [    9.932037] cx88[0]: TV tuner type -1, Radio tuner type -1
> > [    9.953646] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
> > [    9.981718] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> > [    9.996493] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> > [   10.003354] input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> > [   10.007987] input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> > [   10.450310] tveeprom 9-0050: Hauppauge model 69100, rev B4C3, serial# 7900937
> > [   10.453751] tveeprom 9-0050: MAC address is 00:0d:fe:78:8f:09
> > [   10.457134] tveeprom 9-0050: tuner model is Conexant CX24118A (idx 123, type 4)
> > [   10.460547] tveeprom 9-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
> > [   10.463936] tveeprom 9-0050: audio processor is None (idx 0)
> > [   10.467320] tveeprom 9-0050: decoder processor is CX880 (idx 20)
> > [   10.470648] tveeprom 9-0050: has no radio, has IR receiver, has no IR transmitter
> > [   10.474038] cx88[0]: hauppauge eeprom: model=69100
> > [   10.508060] Registered IR keymap rc-hauppauge
> > [   10.518107] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0/input12
> > [   10.526485] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0
> > [   10.530869] cx88[0]/2: cx2388x 8802 Driver Manager
> > [   10.534533] cx88[0]/2: found at 0000:05:05.2, rev: 5, irq: 17, latency: 32, mmio: 0xd2000000
> > [   10.541221] cx88[0]/0: found at 0000:05:05.0, rev: 5, irq: 17, latency: 32, mmio: 0xd0000000
> > [   10.545197] IR RC5(x) protocol handler initialized
> > [   10.557935]
> > [   10.560012] =============================================
> > [   10.560012] [ INFO: possible recursive locking detected ]
> > [   10.560012] 3.8.0-rc7-main #20 Not tainted
> > [   10.560012] ---------------------------------------------
> > [   10.560012] modprobe/469 is trying to acquire lock:
> > [   10.560012]  (hdl->lock){+.+...}, at: [<f85604f6>] find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]
> > [   10.560012] but task is already holding lock:
> > [   10.560012]  (hdl->lock){+.+...}, at: [<f85622d3>] v4l2_ctrl_add_handler+0x35/0x91 [videodev]
> > [   10.560012]
> > [   10.560012] other info that might help us debug this:
> > [   10.560012]  Possible unsafe locking scenario:
> > [   10.560012]
> > [   10.560012]        CPU0
> > [   10.560012]        ----
> > [   10.560012]   lock(hdl->lock);
> > [   10.560012]   lock(hdl->lock);
> > [   10.560012]
> > [   10.560012]  *** DEADLOCK ***
> > [   10.560012]
> > [   10.560012]  May be due to missing lock nesting notation
> > [   10.560012]
> > [   10.560012] 3 locks held by modprobe/469:
> > [   10.560012]  #0:  (&__lockdep_no_validate__){......}, at: [<c03cbcfc>] __driver_attach+0x31/0x6b
> > [   10.560012]  #1:  (&__lockdep_no_validate__){......}, at: [<c03cbd08>] __driver_attach+0x3d/0x6b
> > [   10.560012]  #2:  (hdl->lock){+.+...}, at: [<f85622d3>] v4l2_ctrl_add_handler+0x35/0x91 [videodev]
> > [   10.560012]
> > [   10.560012] stack backtrace:
> > [   10.560012] Pid: 469, comm: modprobe Not tainted 3.8.0-rc7-main #20
> > [   10.560012] Call Trace:
> > [   10.560012]  [<c01272cb>] ? console_unlock+0x34b/0x374
> > [   10.560012]  [<c015b25a>] __lock_acquire+0x1314/0x138a
> > [   10.560012]  [<c015bc94>] ? mark_held_locks+0xa1/0xc8
> > [   10.560012]  [<f85604f6>] ? find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]  [<c015b703>] lock_acquire+0xaf/0xcd
> > [   10.560012]  [<f85604f6>] ? find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]  [<f85604f6>] ? find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]  [<c04f8ae0>] mutex_lock_nested+0x3a/0x266
> > [   10.560012]  [<f85604f6>] ? find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]  [<c04f8cc8>] ? mutex_lock_nested+0x222/0x266
> > [   10.560012]  [<c04f8cf1>] ? mutex_lock_nested+0x24b/0x266
> > [   10.560012]  [<f85604f6>] find_ref_lock+0x1f/0x39 [videodev]
> > [   10.560012]  [<f8560db7>] handler_new_ref+0x38/0x143 [videodev]
> > [   10.560012]  [<f856230b>] v4l2_ctrl_add_handler+0x6d/0x91 [videodev]
> > [   10.560012]  [<f85c2961>] cx8800_initdev+0x329/0x673 [cx8800]
> > [   10.560012]  [<c04fd581>] ? sub_preempt_count+0x90/0x9d
> > [   10.560012]  [<c04faa54>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
> > [   10.560012]  [<c03d0acd>] ? __pm_runtime_resume+0x40/0x48
> > [   10.560012]  [<c02e6ca4>] pci_device_probe+0x5f/0x96
> > [   10.560012]  [<c03cbbe7>] driver_probe_device+0x8f/0x173
> > [   10.560012]  [<c03cbd1a>] __driver_attach+0x4f/0x6b
> > [   10.560012]  [<c03ca895>] bus_for_each_dev+0x44/0x66
> > [   10.560012]  [<c03cb82f>] driver_attach+0x1c/0x21
> > [   10.560012]  [<c03cbccb>] ? driver_probe_device+0x173/0x173
> > [   10.560012]  [<c03cb4a8>] bus_add_driver+0x9d/0x1c3
> > [   10.560012]  [<c03cbf73>] driver_register+0x77/0xe2
> > [   10.560012]  [<c02dac08>] ? __raw_spin_lock_init+0x26/0x49
> > [   10.560012]  [<c02e6d84>] __pci_register_driver+0x4a/0x4d
> > [   10.560012]  [<f85ca000>] ? 0xf85c9fff
> > [   10.560012]  [<f85ca026>] cx8800_init+0x26/0x1000 [cx8800]
> > [   10.560012]  [<c0101093>] do_one_initcall+0x75/0x11e
> > [   10.560012]  [<f85ca000>] ? 0xf85c9fff
> > [   10.560012]  [<f85ca000>] ? 0xf85c9fff
> > [   10.560012]  [<c01638ed>] load_module+0x1669/0x198d
> > [   10.560012]  [<c0163c96>] sys_init_module+0x85/0x87
> > [   10.560012]  [<c04fae5d>] syscall_call+0x7/0xb
> > [   10.749996] cx88[0]/0: registered device video0 [v4l2]
> > [   10.754891] cx88[0]/0: registered device vbi0
> > [   10.759328] lirc_dev: IR Remote Control driver registered, major 250
> > [   10.763449] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
> > [   10.765473] IR LIRC bridge handler initialized
> > [   10.778474] cx88/2: cx2388x dvb driver version 0.0.9 loaded
> > [   10.780512] cx88/2: registering cx8802 driver, type: dvb access: shared
> > [   10.785004] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
> > [   10.787046] cx88[0]/2: cx2388x based DVB/ATSC card
> > [   10.794436] cx8802_alloc_frontends() allocating 1 frontend(s)
> > [   10.812315] DVB: registering new adapter (cx88[0])
> > [   10.814427] cx88-mpeg driver manager 0000:05:05.2: DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
> > 
> > 
> > Affected kernels
> > =============
> > at least 3.6.*, 3.7.*, 3.8.-rc*
> > 
> > Hardware / Software
> > ================
> > opensuse 12.1 running on an AOpen i915GMm-hfs, Pentium M Dothan, 2GB system.
> > 
> > DVB-S hardware
> > =============
> > Hauppauge WinTV Nova HD-S2:
> > 
> > 05:05.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
> >          Subsystem: Hauppauge computer works Inc. Device 6906
> >          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >          Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
> >          Interrupt: pin A routed to IRQ 17
> >          Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=16M]
> >          Capabilities: [44] Vital Product Data
> >                  Unknown large resource type 04, will not decode more.
> >          Capabilities: [4c] Power Management version 2
> >                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> >          Kernel driver in use: cx8800
> > 
> > 05:05.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
> >          Subsystem: Hauppauge computer works Inc. Device 6906
> >          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >          Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
> >          Interrupt: pin A routed to IRQ 12
> >          Region 0: Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
> >          Capabilities: [4c] Power Management version 2
> >                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 
> > 05:05.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
> >          Subsystem: Hauppauge computer works Inc. Device 6906
> >          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >          Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
> >          Interrupt: pin A routed to IRQ 17
> >          Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
> >          Capabilities: [4c] Power Management version 2
> >                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> >          Kernel driver in use: cx88-mpeg driver manager
> > 
> > 05:05.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)
> >          Subsystem: Hauppauge computer works Inc. Device 6906
> >          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >          Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
> >          Interrupt: pin A routed to IRQ 12
> >          Region 0: Memory at d3000000 (32-bit, non-prefetchable) [size=16M]
> >          Capabilities: [4c] Power Management version 2
> >                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 
> > 
> > cu,
> >   Knut
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


