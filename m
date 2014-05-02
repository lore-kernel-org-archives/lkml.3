Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaEBQky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:40:54 -0400
Received: from mail.tpi.com ([74.45.170.26]:36812 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaEBQkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:40:52 -0400
Message-ID: <5363CA91.7070203@canonical.com>
Date: Fri, 02 May 2014 10:40:49 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: daniel.vetter@ffwll.ch
CC: airlied@redhat.com, dan.carpenter@oracle.com, alexdeucher@gmail.com,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Subject: Lenovo x120e resume regression in 3.15-rc1 bisected to 'drm/crtc-helpers:
 fix dpms on logic'
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------040002000407030706010001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040002000407030706010001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I've bisected a resume regression on a Lenovo x120e to
177cf92de4aa97ec1435987e91696ed8b5023130 (drm/crtc-helpers: fix dpms on
logic). Everything works fine with this patch reverted on top of
3.15-rc3. I realize it is correcting a coding error that has been in
place since 3.11, but it is also causing this laptop to resume to a
black screen wherein the platform appears to be locked up (no console,
no network). See attached bisect log and lspci. The BIOS version is 1.15.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------040002000407030706010001
Content-Type: text/plain; charset=UTF-8;
 name="BISECT_LOG"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="BISECT_LOG"

# bad: [c9eaa447e77efe77b7fa4c953bd62de8297fd6c5] Linux 3.15-rc1
# good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
git bisect start 'v3.15-rc1' 'v3.14' '--' 'drivers/gpu/'
# good: [e19b9137142988bec5a76c5f8bdf12a77ea802b0] Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next
git bisect good e19b9137142988bec5a76c5f8bdf12a77ea802b0
# good: [0d3215e3857ab679f74c9b26b7e711955c9d0438] drm/ttm: Add a ttm_ref_object_exists function
git bisect good 0d3215e3857ab679f74c9b26b7e711955c9d0438
# good: [efbc20abd826033859cc28d1442e48640cf09045] drm/i915: don't read pp_ctrl_reg if we're suspended
git bisect good efbc20abd826033859cc28d1442e48640cf09045
# bad: [14c6d5bdf759274868c6a3534e56f1991118df63] Merge tag 'vmwgfx-next-2014-04-04' of git://people.freedesktop.org/~thomash/linux into drm-next
git bisect bad 14c6d5bdf759274868c6a3534e56f1991118df63
# bad: [a8947f576728a66bd3aac629bd8ca021a010c808] drm/radeon: fix endian swap on hawaii clear state buffer setup
git bisect bad a8947f576728a66bd3aac629bd8ca021a010c808
# good: [2d82d188b2cb11b6b221eb84dda2344ef3cd1bb4] drm/msm: Switch to universal plane API's
git bisect good 2d82d188b2cb11b6b221eb84dda2344ef3cd1bb4
# bad: [2844ea3f252331cc0ecf3ae74f6226db2f580f8a] Merge branch 'primary-plane' of git://people.freedesktop.org/~robclark/linux into drm-next
git bisect bad 2844ea3f252331cc0ecf3ae74f6226db2f580f8a
# bad: [177cf92de4aa97ec1435987e91696ed8b5023130] drm/crtc-helpers: fix dpms on logic
git bisect bad 177cf92de4aa97ec1435987e91696ed8b5023130
# good: [41ccec352f3c823931a7d9d2a9c7880c14d7415a] drm/qxl: unset a pointer in sync_obj_unref
git bisect good 41ccec352f3c823931a7d9d2a9c7880c14d7415a
# first bad commit: [177cf92de4aa97ec1435987e91696ed8b5023130] drm/crtc-helpers: fix dpms on logic

--------------040002000407030706010001
Content-Type: text/plain; charset=UTF-8;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.txt"

00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Complex [1022:1510]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Complex [1022:1510]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64

00:01.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler [Radeon HD 6310] [1002:9802] (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 4000 [size=256]
	Region 2: Memory at f0200000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: radeon

00:01.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler HDMI Audio [1002:1314]
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler HDMI Audio [1002:1314]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 45
	Region 0: Memory at f0244000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:06.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Port [1022:1514] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f0300000-f03fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:11.0 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] [1002:4391] (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 4118 [size=8]
	Region 1: I/O ports at 4124 [size=4]
	Region 2: I/O ports at 4110 [size=8]
	Region 3: I/O ports at 4120 [size=4]
	Region 4: I/O ports at 4100 [size=16]
	Region 5: Memory at f024a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397] (prog-if 10 [OHCI])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0249000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396] (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f024a500 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397] (prog-if 10 [OHCI])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0248000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396] (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f024a400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller [1002:4385] (rev 42)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.2 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA) [1002:4383] (rev 40)
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0240000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller [1002:439d] (rev 40)
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge [1002:4384] (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:15.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) [1002:43a0] (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:15.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1) [1002:43a1] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f0100000-f01fffff
	Prefetchable memory behind bridge: 00000000f0400000-00000000f05fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 0 [1022:1700] (rev 43)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 1 [1022:1701]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 2 [1022:1702]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 3 [1022:1703]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: k10temp

00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 4 [1022:1704]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 6 [1022:1718]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 5 [1022:1716]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 7 [1022:1719]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 03)
	Subsystem: Lenovo Device [17aa:21df]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: I/O ports at 3000 [size=256]
	Region 2: Memory at f0004000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]
	Expansion ROM at f0020000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: r8169

04:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8195]
	Physical Slot: 0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at f0100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: rtl8192ce


--------------040002000407030706010001--
