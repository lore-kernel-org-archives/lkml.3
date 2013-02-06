Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3BFNeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:34:22 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60384 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3BFNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:34:20 -0500
Message-ID: <51125BD7.9060709@googlemail.com>
Date: Wed, 06 Feb 2013 13:34:15 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: kernel 3.6.7: sysfs: cannot create duplicate filename warnings
Content-Type: multipart/mixed;
 boundary="------------060002070306030708070208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060002070306030708070208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've been investigating problem with my Hauppauge WinTV HVR-1400 TV card 
(an expresscard) [1], and I've come across warnings produced when I 
unload and then reload the cx23885 driver.

Attached is the output from dmesg that shows the card being detected (by 
the PCI express hotplug driver) when it is inserted, the drivers being 
loaded and unloaded and, finally, the driver being reloaded and 
producing the warnings.

I get the same warning with 3.8.0-rc6+ (freshly pulled this morning).

I've searched Google and find thousands of hits going back over two 
years, but none of the first 20 pages of hits provided a solution.

Please let me know if I can provide any additional diagnostics, but cc 
me on any reply as I'm not subscribed.

Chris

[1] http://www.spinics.net/lists/linux-media/msg59468.html


--------------060002070306030708070208
Content-Type: text/plain; charset=us-ascii;
 name="hvr1400-sysfs-warning.dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hvr1400-sysfs-warning.dmesg.txt"

Plug in the hvr1400

[  165.300637] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[  165.401471] pci 0000:02:00.0: [14f1:8852] type 00 class 0x040000
[  165.401528] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x001fffff 64bit]
[  165.401678] pci 0000:02:00.0: supports D1 D2
[  165.401679] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[  165.409465] pci 0000:02:00.0: BAR 0: assigned [mem 0xf0e00000-0xf0ffffff 64bit]
[  165.409501] pcieport 0000:00:1c.3: PCI bridge to [bus 02-06]
[  165.409505] pcieport 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[  165.409510] pcieport 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[  165.409514] pcieport 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[  165.409530] pci 0000:02:00.0: no hotplug settings from platform

Load the drivers

[  211.641874] cx23885 driver version 0.0.3 loaded
[  211.641897] cx23885 0000:02:00.0: enabling device (0000 -> 0002)
[  211.642000] CORE cx23885[0]: subsystem: 0070:8010, board: Hauppauge WinTV-HVR1400 [card=9,autodetected]
[  211.781181] cx23885[0] - extra delay being applied for HVR1400
[  211.809194] tveeprom 7-0050: Hauppauge model 80019, rev B2F1, serial# 3758890
[  211.809197] tveeprom 7-0050: MAC address is 00:0d:fe:39:5b:2a
[  211.809198] tveeprom 7-0050: tuner model is Xceive XC3028L (idx 151, type 4)
[  211.809200] tveeprom 7-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[  211.809201] tveeprom 7-0050: audio processor is CX23885 (idx 39)
[  211.809202] tveeprom 7-0050: decoder processor is CX23885 (idx 33)
[  211.809203] tveeprom 7-0050: has radio
[  211.809204] cx23885[0]: hauppauge eeprom: model=80019
[  211.809205] cx23885_dvb_register() allocating 1 frontend(s)
[  211.809207] cx23885[0]: cx23885 based dvb card
[  211.915346] xc2028 8-0064: creating new instance
[  211.915349] xc2028 8-0064: type set to XCeive xc2028/xc3028 tuner
[  211.915353] DVB: registering new adapter (cx23885[0])
[  211.915357] cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  211.915576] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  211.915582] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xf0e00000
[  211.977653] xc2028 8-0064: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6

Unload the drivers

[  228.016560] xc2028 8-0064: destroying instance

Reload the drivers

[  240.384907] cx23885 driver version 0.0.3 loaded
[  240.385099] CORE cx23885[0]: subsystem: 0070:8010, board: Hauppauge WinTV-HVR1400 [card=9,autodetected]
[  240.524290] cx23885[0] - extra delay being applied for HVR1400
[  240.552265] tveeprom 7-0050: Hauppauge model 80019, rev B2F1, serial# 3758890
[  240.552267] tveeprom 7-0050: MAC address is 00:0d:fe:39:5b:2a
[  240.552268] tveeprom 7-0050: tuner model is Xceive XC3028L (idx 151, type 4)
[  240.552269] tveeprom 7-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[  240.552270] tveeprom 7-0050: audio processor is CX23885 (idx 39)
[  240.552271] tveeprom 7-0050: decoder processor is CX23885 (idx 33)
[  240.552272] tveeprom 7-0050: has radio
[  240.552273] cx23885[0]: hauppauge eeprom: model=80019
[  240.552275] cx23885_dvb_register() allocating 1 frontend(s)
[  240.552277] cx23885[0]: cx23885 based dvb card
[  240.626253] xc2028 8-0064: creating new instance
[  240.626255] xc2028 8-0064: type set to XCeive xc2028/xc3028 tuner
[  240.626258] DVB: registering new adapter (cx23885[0])
[  240.626263] cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  240.626316] xc2028 8-0064: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[  240.626366] ------------[ cut here ]------------
[  240.626371] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xae/0xe0()
[  240.626372] Hardware name: LIFEBOOK AH531
[  240.626373] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.3/0000:02:00.0/dvb/dvb0.frontend0'
[  240.626374] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.626391] Pid: 2361, comm: modprobe Not tainted 3.7.6 #29
[  240.626392] Call Trace:
[  240.626396]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.626398]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626400]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626402]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.626405]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626407]  [<c1118215>] ? create_dir+0x55/0xa0
[  240.626409]  [<c1118518>] ? sysfs_create_dir+0x78/0xd0
[  240.626413]  [<c1052688>] ? finish_task_switch+0x38/0xb0
[  240.626416]  [<c11778b3>] ? kobject_add_internal+0x83/0x200
[  240.626419]  [<c13fc64b>] ? __schedule+0x20b/0x750
[  240.626421]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.626424]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.626426]  [<c1052100>] ? complete_all+0x40/0x60
[  240.626428]  [<c13fcc2a>] ? preempt_schedule+0x2a/0x40
[  240.626430]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.626432]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.626433]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.626436]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.626439]  [<c1313c41>] ? dvb_register_frontend+0x101/0x160
[  240.626442]  [<f95d02b9>] ? videobuf_dvb_register_bus+0xa9/0x380 [videobuf_dvb]
[  240.626445]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.626447]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.626455]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.626457]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626460]  [<c104f51b>] ? up+0xb/0x40
[  240.626462]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626464]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626466]  [<c104f51b>] ? up+0xb/0x40
[  240.626468]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626471]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.626473]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.626479]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.626485]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.626489]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.626491]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626493]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.626495]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626497]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.626498]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.626500]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.626502]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626504]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.626505]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626507]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.626509]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626511]  [<c1278543>] ? driver_register+0x63/0x160
[  240.626513]  [<f9635000>] ? 0xf9634fff
[  240.626514]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.626516]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.626519]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.626523]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.626524] ---[ end trace d8cd91e5faa30281 ]---
[  240.626526] ------------[ cut here ]------------
[  240.626528] WARNING: at lib/kobject.c:196 kobject_add_internal+0x1ea/0x200()
[  240.626528] Hardware name: LIFEBOOK AH531
[  240.626529] kobject_add_internal failed for dvb0.frontend0 with -EEXIST, don't try to register things with the same name in the same directory.
[  240.626530] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.626542] Pid: 2361, comm: modprobe Tainted: G        W    3.7.6 #29
[  240.626542] Call Trace:
[  240.626544]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.626546]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626548]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626550]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.626552]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626554]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.626556]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.626558]  [<c1052100>] ? complete_all+0x40/0x60
[  240.626559]  [<c13fcc2a>] ? preempt_schedule+0x2a/0x40
[  240.626561]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.626563]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.626564]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.626566]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.626569]  [<c1313c41>] ? dvb_register_frontend+0x101/0x160
[  240.626571]  [<f95d02b9>] ? videobuf_dvb_register_bus+0xa9/0x380 [videobuf_dvb]
[  240.626573]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.626575]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.626579]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.626581]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626584]  [<c104f51b>] ? up+0xb/0x40
[  240.626586]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626588]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626590]  [<c104f51b>] ? up+0xb/0x40
[  240.626592]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626594]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.626596]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.626600]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.626605]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.626607]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.626609]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626611]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.626613]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626614]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.626616]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.626618]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.626619]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626621]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.626623]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626625]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.626626]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626628]  [<c1278543>] ? driver_register+0x63/0x160
[  240.626630]  [<f9635000>] ? 0xf9634fff
[  240.626631]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.626633]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.626635]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.626639]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.626640] ---[ end trace d8cd91e5faa30282 ]---
[  240.626641] dvb_register_device: failed to create device dvb0.frontend0 (-17)
[  240.626696] ------------[ cut here ]------------
[  240.626698] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xae/0xe0()
[  240.626699] Hardware name: LIFEBOOK AH531
[  240.626700] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.3/0000:02:00.0/dvb/dvb0.demux0'
[  240.626700] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.626712] Pid: 2361, comm: modprobe Tainted: G        W    3.7.6 #29
[  240.626713] Call Trace:
[  240.626715]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.626717]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626719]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626721]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.626723]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626725]  [<c1118215>] ? create_dir+0x55/0xa0
[  240.626727]  [<c1118518>] ? sysfs_create_dir+0x78/0xd0
[  240.626729]  [<c11778b3>] ? kobject_add_internal+0x83/0x200
[  240.626732]  [<c109a58f>] ? __alloc_pages_nodemask+0xdf/0x660
[  240.626734]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.626736]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.626738]  [<c1052100>] ? complete_all+0x40/0x60
[  240.626740]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.626741]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.626743]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.626745]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.626747]  [<c130cadd>] ? dvb_dmxdev_init+0xbd/0x100
[  240.626749]  [<f95d033b>] ? videobuf_dvb_register_bus+0x12b/0x380 [videobuf_dvb]
[  240.626751]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.626753]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.626757]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.626759]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626761]  [<c104f51b>] ? up+0xb/0x40
[  240.626763]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626765]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626767]  [<c104f51b>] ? up+0xb/0x40
[  240.626769]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626771]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.626773]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.626777]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.626781]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.626783]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.626785]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626787]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.626789]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626790]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.626792]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.626794]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.626796]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626797]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.626799]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626801]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.626802]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626804]  [<c1278543>] ? driver_register+0x63/0x160
[  240.626806]  [<f9635000>] ? 0xf9634fff
[  240.626807]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.626809]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.626811]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.626815]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.626816] ---[ end trace d8cd91e5faa30283 ]---
[  240.626816] ------------[ cut here ]------------
[  240.626818] WARNING: at lib/kobject.c:196 kobject_add_internal+0x1ea/0x200()
[  240.626819] Hardware name: LIFEBOOK AH531
[  240.626820] kobject_add_internal failed for dvb0.demux0 with -EEXIST, don't try to register things with the same name in the same directory.
[  240.626820] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.626831] Pid: 2361, comm: modprobe Tainted: G        W    3.7.6 #29
[  240.626832] Call Trace:
[  240.626834]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.626836]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626838]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626840]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.626842]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.626844]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.626845]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.626847]  [<c1052100>] ? complete_all+0x40/0x60
[  240.626849]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.626851]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.626852]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.626854]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.626856]  [<c130cadd>] ? dvb_dmxdev_init+0xbd/0x100
[  240.626858]  [<f95d033b>] ? videobuf_dvb_register_bus+0x12b/0x380 [videobuf_dvb]
[  240.626860]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.626862]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.626866]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.626868]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626870]  [<c104f51b>] ? up+0xb/0x40
[  240.626872]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626874]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626876]  [<c104f51b>] ? up+0xb/0x40
[  240.626878]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626880]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.626882]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.626885]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.626889]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.626891]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.626893]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626895]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.626897]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626898]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.626900]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.626902]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.626903]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626905]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.626907]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.626908]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.626910]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.626912]  [<c1278543>] ? driver_register+0x63/0x160
[  240.626913]  [<f9635000>] ? 0xf9634fff
[  240.626915]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.626916]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.626918]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.626922]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.626923] ---[ end trace d8cd91e5faa30284 ]---
[  240.626924] dvb_register_device: failed to create device dvb0.demux0 (-17)
[  240.626930] ------------[ cut here ]------------
[  240.626932] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xae/0xe0()
[  240.626932] Hardware name: LIFEBOOK AH531
[  240.626933] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.3/0000:02:00.0/dvb/dvb0.dvr0'
[  240.626934] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.626945] Pid: 2361, comm: modprobe Tainted: G        W    3.7.6 #29
[  240.626945] Call Trace:
[  240.626947]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.626949]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626951]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626953]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.626955]  [<c111805e>] ? sysfs_add_one+0xae/0xe0
[  240.626957]  [<c1118215>] ? create_dir+0x55/0xa0
[  240.626960]  [<c1118518>] ? sysfs_create_dir+0x78/0xd0
[  240.626962]  [<c11778b3>] ? kobject_add_internal+0x83/0x200
[  240.626964]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626966]  [<c104f51b>] ? up+0xb/0x40
[  240.626968]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.626969]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.626971]  [<c1052100>] ? complete_all+0x40/0x60
[  240.626973]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.626975]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.626976]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.626978]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.626980]  [<c130caf9>] ? dvb_dmxdev_init+0xd9/0x100
[  240.626982]  [<f95d033b>] ? videobuf_dvb_register_bus+0x12b/0x380 [videobuf_dvb]
[  240.626984]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.626986]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.626989]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.626991]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626994]  [<c104f51b>] ? up+0xb/0x40
[  240.626995]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.626997]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.626999]  [<c104f51b>] ? up+0xb/0x40
[  240.627001]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.627003]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.627005]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.627009]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.627012]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.627015]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.627016]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.627018]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.627020]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627022]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.627023]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.627025]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.627027]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627028]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.627030]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.627032]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.627033]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627035]  [<c1278543>] ? driver_register+0x63/0x160
[  240.627037]  [<f9635000>] ? 0xf9634fff
[  240.627038]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.627040]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.627041]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.627045]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.627046] ---[ end trace d8cd91e5faa30285 ]---
[  240.627047] ------------[ cut here ]------------
[  240.627049] WARNING: at lib/kobject.c:196 kobject_add_internal+0x1ea/0x200()
[  240.627050] Hardware name: LIFEBOOK AH531
[  240.627050] kobject_add_internal failed for dvb0.dvr0 with -EEXIST, don't try to register things with the same name in the same directory.
[  240.627051] Modules linked in: cx23885(+) tveeprom btcx_risc videobuf_dvb cx2341x videobuf_dma_sg videobuf_core dib7000p dibx000_common iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack usb_storage coretemp hwmon snd_hda_codec_hdmi snd_hda_codec_realtek r8169 snd_hda_intel snd_hda_codec snd_hwdep microcode [last unloaded: tveeprom]
[  240.627062] Pid: 2361, comm: modprobe Tainted: G        W    3.7.6 #29
[  240.627062] Call Trace:
[  240.627064]  [<c102f1d8>] ? warn_slowpath_common+0x78/0xb0
[  240.627066]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.627068]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.627070]  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
[  240.627072]  [<c1177a1a>] ? kobject_add_internal+0x1ea/0x200
[  240.627075]  [<c104f51b>] ? up+0xb/0x40
[  240.627077]  [<c1177e96>] ? kobject_add+0x36/0x80
[  240.627078]  [<c12758e3>] ? device_add+0xd3/0x650
[  240.627080]  [<c1052100>] ? complete_all+0x40/0x60
[  240.627082]  [<c127dd73>] ? device_pm_sleep_init+0x33/0x50
[  240.627083]  [<c1275f39>] ? device_create_vargs+0xc9/0xe0
[  240.627085]  [<c1275f7b>] ? device_create+0x2b/0x30
[  240.627087]  [<c130c670>] ? dvb_register_device+0x240/0x370
[  240.627089]  [<c130caf9>] ? dvb_dmxdev_init+0xd9/0x100
[  240.627091]  [<f95d033b>] ? videobuf_dvb_register_bus+0x12b/0x380 [videobuf_dvb]
[  240.627092]  [<c12e57f7>] ? xc2028_set_config+0x107/0x1c0
[  240.627094]  [<c12e7c80>] ? xc2028_set_params+0x220/0x220
[  240.627098]  [<f961c986>] ? dvb_register+0xf6/0x2190 [cx23885]
[  240.627100]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.627102]  [<c104f51b>] ? up+0xb/0x40
[  240.627104]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.627106]  [<c10302a0>] ? msg_print_text+0xc0/0x180
[  240.627108]  [<c104f51b>] ? up+0xb/0x40
[  240.627110]  [<c1030d7a>] ? console_unlock+0x33a/0x450
[  240.627112]  [<f95ac38f>] ? videobuf_queue_core_init+0xef/0x170 [videobuf_core]
[  240.627114]  [<f95b9040>] ? videobuf_queue_sg_init+0x40/0x50 [videobuf_dma_sg]
[  240.627117]  [<f961ed07>] ? cx23885_dvb_register+0x107/0x140 [cx23885]
[  240.627121]  [<f96265df>] ? cx23885_initdev+0x924/0xc5c [cx23885]
[  240.627123]  [<c1196ad1>] ? pci_device_probe+0x61/0x90
[  240.627125]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.627126]  [<c1277dc6>] ? driver_probe_device+0x56/0x1f0
[  240.627128]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627130]  [<c11965b7>] ? pci_match_device+0x97/0xb0
[  240.627132]  [<c1277fd9>] ? __driver_attach+0x79/0x80
[  240.627133]  [<c1276658>] ? bus_for_each_dev+0x38/0x70
[  240.627135]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627137]  [<c1277a06>] ? driver_attach+0x16/0x20
[  240.627138]  [<c1277f60>] ? driver_probe_device+0x1f0/0x1f0
[  240.627140]  [<c127766f>] ? bus_add_driver+0x15f/0x240
[  240.627142]  [<c1196a00>] ? pci_dev_put+0x20/0x20
[  240.627143]  [<c1278543>] ? driver_register+0x63/0x160
[  240.627145]  [<f9635000>] ? 0xf9634fff
[  240.627146]  [<c1001232>] ? do_one_initcall+0x112/0x160
[  240.627148]  [<c10c2d5e>] ? kfree+0x9e/0xd0
[  240.627150]  [<c10767ce>] ? sys_init_module+0xe4e/0x1a50
[  240.627154]  [<c13fe33e>] ? sysenter_do_call+0x12/0x26
[  240.627155] ---[ end trace d8cd91e5faa30286 ]---
[  240.627156] dvb_register_device: failed to create device dvb0.dvr0 (-17)
[  240.627160] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  240.627165] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xf0e00000


--------------060002070306030708070208--
