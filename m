Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3HYPps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:45:48 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:42513 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3HYPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:45:46 -0400
Message-ID: <521A269D.3020909@t-online.de>
Date: Sun, 25 Aug 2013 17:45:33 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [REGRESSION 3.11-rc] wm8775 9-001b: I2C: cannot write ??? to register
 R??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: E1C9DkZHQhSGUs7-M6TZfZptAHVWgCoR2ebY4Oko-rq+SOUkCk358iewFDnzT9qZIR
X-TOI-MSGID: bd1d9a44-d37f-484d-8cf2-fa28dd104401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting current git kernel dmesg shows a set of new  warnings:

     "wm8775 9-001b: I2C: cannot write ??? to register R??"

Nevertheless, the hardware seems to work fine.

This is a new problem, introduced after kernel 3.10.
If necessary I can bisect.

dmesg snippet:

[   11.841431] Linux video capture interface: v2.00
[   11.972078] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[   11.998497] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[   12.035020] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[   12.227528] Adding 7119316k swap on /dev/sda3.  Priority:-1 extents:1 across:7119316k SS
[   12.707144] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   12.709339] tveeprom 9-0050: Hauppauge model 69100, rev B4C3, serial# 7900937
[   12.713245] tveeprom 9-0050: MAC address is 00:0d:fe:78:8f:09
[   12.716836] tveeprom 9-0050: tuner model is Conexant CX24118A (idx 123, type 4)
[   12.720783] tveeprom 9-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[   12.727678] tveeprom 9-0050: audio processor is None (idx 0)
[   12.731462] tveeprom 9-0050: decoder processor is CX880 (idx 20)
[   12.736219] tveeprom 9-0050: has no radio, has IR receiver, has no IR transmitter
[   12.741662] cx88[0]: hauppauge eeprom: model=69100
[   12.749368] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=3 (0x14/0x17/0x16/0x0/0x0) type:line
[   12.749375] ALSA sound/pci/hda/hda_auto_parser.c:397 speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   12.749380] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x19/0x0/0x0/0x0/0x0)
[   12.749384] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   12.749388] ALSA sound/pci/hda/hda_auto_parser.c:405 dig-out=0x1e/0x0
[   12.749391] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   12.749396] ALSA sound/pci/hda/hda_auto_parser.c:410      Rear Mic=0x18
[   12.749400] ALSA sound/pci/hda/hda_auto_parser.c:410      Front Mic=0x1b
[   12.749404] ALSA sound/pci/hda/hda_auto_parser.c:410 Line=0x1a
[   12.749408] ALSA sound/pci/hda/patch_realtek.c:490 realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
[   12.749412] ALSA sound/pci/hda/patch_realtek.c:573 realtek: Enable default setup for auto mode as fallback
[   12.753148] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[   12.768712] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   12.774247] input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   12.778535] input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   12.782526] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   12.786746] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   12.791001] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   12.796098] Registered IR keymap rc-hauppauge
[   12.803188] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0/input12
[   12.809256] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0
[   12.864326] IR RC5(x) protocol handler initialized
[   12.871896] cx88[0]/2: cx2388x 8802 Driver Manager
[   12.876574] cx88[0]/2: found at 0000:05:05.2, rev: 5, irq: 17, latency: 32, mmio: 0xd2000000
[   12.881395] lirc_dev: IR Remote Control driver registered, major 250
[   12.887849] cx88[0]/0: found at 0000:05:05.0, rev: 5, irq: 17, latency: 32, mmio: 0xd0000000
[   12.894323] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
[   12.904754] IR LIRC bridge handler initialized
[   12.926877] wm8775 9-001b: chip found @ 0x36 (cx88[0])
[   12.935488] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   12.942346] cx88/2: registering cx8802 driver, type: dvb access: shared
[   12.948247] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   12.956345] cx88[0]/2: cx2388x based DVB/ATSC card
[   12.966600] cx8802_alloc_frontends() allocating 1 frontend(s)
[   12.971340] wm8775 9-001b: I2C: cannot write 000 to register R23
[   13.001070] DVB: registering new adapter (cx88[0])
[   13.008323] cx88-mpeg driver manager 0000:05:05.2: DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[   13.045893] wm8775 9-001b: I2C: cannot write 000 to register R7
[   13.057800] wm8775 9-001b: I2C: cannot write 021 to register R11
[   13.076171] wm8775 9-001b: I2C: cannot write 102 to register R12
[   13.086551] wm8775 9-001b: I2C: cannot write 000 to register R13
[   13.094695] wm8775 9-001b: I2C: cannot write 1d4 to register R14
[   13.112437] wm8775 9-001b: I2C: cannot write 1d4 to register R15
[   13.122719] wm8775 9-001b: I2C: cannot write 1bf to register R16
[   13.136414] wm8775 9-001b: I2C: cannot write 185 to register R17
[   13.146144] wm8775 9-001b: I2C: cannot write 0a2 to register R18
[   13.152412] wm8775 9-001b: I2C: cannot write 005 to register R19
[   13.167831] wm8775 9-001b: I2C: cannot write 07a to register R20
[   13.174097] wm8775 9-001b: I2C: cannot write 102 to register R21
[   13.184269] wm8775 9-001b: I2C: cannot write 0c2 to register R21
[   13.195566] wm8775 9-001b: I2C: cannot write 1cf to register R14
[   13.201645] wm8775 9-001b: I2C: cannot write 1cf to register R15
[   13.211898] wm8775 9-001b: I2C: cannot write 0c2 to register R21
[   13.217832] wm8775 9-001b: I2C: cannot write 1cf to register R14
[   13.226794] wm8775 9-001b: I2C: cannot write 1cf to register R15
[   13.240810] wm8775 9-001b: I2C: cannot write 0c2 to register R21
[   13.249220] wm8775 9-001b: I2C: cannot write 1cf to register R14
[   13.256881] wm8775 9-001b: I2C: cannot write 1cf to register R15
[   13.274529] cx88[0]/0: registered device video0 [v4l2]
[   13.279167] cx88[0]/0: registered device vbi0


Hardware:
========

Hauppauge WinTV Nova HD-S2,
installed on AOpen i915GMm-hfs mobo,
2GB RAM, 2GHz Pentium-M Dothan

lspci -vv::

05:05.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
         Subsystem: Hauppauge computer works Inc. Device 6906
         Flags: bus master, medium devsel, latency 32, IRQ 17
         Memory at d0000000 (32-bit, non-prefetchable) [size=16M]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: cx8800

05:05.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
         Subsystem: Hauppauge computer works Inc. Device 6906
         Flags: bus master, medium devsel, latency 32, IRQ 12
         Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
         Capabilities: [4c] Power Management version 2

05:05.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
         Subsystem: Hauppauge computer works Inc. Device 6906
         Flags: bus master, medium devsel, latency 32, IRQ 17
         Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: cx88-mpeg driver manager

05:05.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)
         Subsystem: Hauppauge computer works Inc. Device 6906
         Flags: bus master, medium devsel, latency 32, IRQ 12
         Memory at d3000000 (32-bit, non-prefetchable) [size=16M]
         Capabilities: [4c] Power Management version 2

cu,
  Knut
