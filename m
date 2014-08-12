Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaHLJBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:01:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45379 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHLJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:01:44 -0400
Date: Tue, 12 Aug 2014 02:01:38 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Thunderbolt driver hotplug not working correctly
Message-ID: <20140812085944.GA25906@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

I'm trying out the new Thunderbolt driver in Linus' tree and I'm
noticing device hotplug isn't quite working correctly.

I've got a Haswell 2013 MacBook Pro Retina and the Apple-vended
Thunderbolt Ethernet adapter, which uses the tg3 driver.

Here's what dmesg says when I unplug:

[ 1866.359118] thunderbolt 0000:08:00.0: resetting error on 0:3.
[ 1866.359150] thunderbolt 0000:08:00.0: 0:3: unplugged

When I re-plug the device:

[ 1872.481675] thunderbolt 0000:08:00.0: resetting error on 0:3.
[ 1872.481695] thunderbolt 0000:08:00.0: 0:3: hotplug: scanning
[ 1872.481764] thunderbolt 0000:08:00.0: 0:3: is connected, link is up (state: 2)
[ 1872.482078] thunderbolt 0000:08:00.0: initializing Switch at 0x3 (depth: 1, up port: 1)
[ 1872.482084] thunderbolt 0000:08:00.0: old switch config:
[ 1872.482089] thunderbolt 0000:08:00.0:  Switch: 8086:1549 (Revision: 0, TB Version: 1)
[ 1872.482092] thunderbolt 0000:08:00.0:   Max Port Number: 2
[ 1872.482094] thunderbolt 0000:08:00.0:   Config:
[ 1872.482098] thunderbolt 0000:08:00.0:    Upstream Port Number: 0 Depth: 0 Route String: 0x0 Enabled: 0, PlugEventsDelay: 10ms
[ 1872.482102] thunderbolt 0000:08:00.0:    unknown1: 0x0 unknown4: 0x0
[ 1872.496213] thunderbolt 0000:08:00.0: 3: reading drom (length: 0x7b)
[ 1872.821969] thunderbolt 0000:08:00.0: 3: uid: 0x10002014eed70
[ 1872.822067] thunderbolt 0000:08:00.0:  Port 0: 8086:1549 (Revision: 0, TB Version: 1, Type: Port (0x1))
[ 1872.822069] thunderbolt 0000:08:00.0:   Max hop id (in/out): 7/7
[ 1872.822071] thunderbolt 0000:08:00.0:   Max counters: 8
[ 1872.822072] thunderbolt 0000:08:00.0:   NFC Credits: 0x700000
[ 1872.822566] thunderbolt 0000:08:00.0:  Port 1: 8086:1549 (Revision: 0, TB Version: 1, Type: Port (0x1))
[ 1872.822567] thunderbolt 0000:08:00.0:   Max hop id (in/out): 8/8
[ 1872.822569] thunderbolt 0000:08:00.0:   Max counters: 4
[ 1872.822570] thunderbolt 0000:08:00.0:   NFC Credits: 0x3c00000
[ 1872.822666] thunderbolt 0000:08:00.0:  Port 2: 8086:1549 (Revision: 0, TB Version: 1, Type: PCIe (0x100102))
[ 1872.822667] thunderbolt 0000:08:00.0:   Max hop id (in/out): 8/8
[ 1872.822668] thunderbolt 0000:08:00.0:   Max counters: 2
[ 1872.822670] thunderbolt 0000:08:00.0:   NFC Credits: 0x700000
[ 1872.822982] thunderbolt 0000:08:00.0: 3: hotplug: activating pcie devices
[ 1872.823576] thunderbolt 0000:08:00.0: 0:6 <-> 3:2 (PCI): activating
[ 1872.823580] thunderbolt 0000:08:00.0: activating path from 0:6 to 3:2
[ 1872.823582] thunderbolt 0000:08:00.0: 3:1: Writing hop 1, index 8
[ 1872.823583] thunderbolt 0000:08:00.0: 3:1:  Hop through port 2 to hop 8 (enabled)
[ 1872.823585] thunderbolt 0000:08:00.0: 3:1:   Weight: 1 Priority: 3 Credits: 16 Drop: 0
[ 1872.823587] thunderbolt 0000:08:00.0: 3:1:    Counter enabled: 0 Counter index: 2047
[ 1872.823589] thunderbolt 0000:08:00.0: 3:1:   Flow Control (In/Eg): 1/0 Shared Buffer (In/Eg): 0/0
[ 1872.823591] thunderbolt 0000:08:00.0: 3:1:   Unknown1: 0x0 Unknown2: 0x0 Unknown3: 0x0
[ 1872.823664] thunderbolt 0000:08:00.0: 0:6: Writing hop 0, index 8
[ 1872.823666] thunderbolt 0000:08:00.0: 0:6:  Hop through port 3 to hop 8 (enabled)
[ 1872.823667] thunderbolt 0000:08:00.0: 0:6:   Weight: 1 Priority: 3 Credits: 7 Drop: 0
[ 1872.823669] thunderbolt 0000:08:00.0: 0:6:    Counter enabled: 0 Counter index: 2047
[ 1872.823670] thunderbolt 0000:08:00.0: 0:6:   Flow Control (In/Eg): 1/1 Shared Buffer (In/Eg): 0/0
[ 1872.823672] thunderbolt 0000:08:00.0: 0:6:   Unknown1: 0x0 Unknown2: 0x0 Unknown3: 0x0
[ 1872.823764] thunderbolt 0000:08:00.0: path activation complete
[ 1872.823765] thunderbolt 0000:08:00.0: activating path from 3:2 to 0:6
[ 1872.823767] thunderbolt 0000:08:00.0: 0:3: Writing hop 1, index 8
[ 1872.823768] thunderbolt 0000:08:00.0: 0:3:  Hop through port 6 to hop 8 (enabled)
[ 1872.823770] thunderbolt 0000:08:00.0: 0:3:   Weight: 1 Priority: 3 Credits: 16 Drop: 0
[ 1872.823771] thunderbolt 0000:08:00.0: 0:3:    Counter enabled: 0 Counter index: 2047
[ 1872.823773] thunderbolt 0000:08:00.0: 0:3:   Flow Control (In/Eg): 1/0 Shared Buffer (In/Eg): 0/0
[ 1872.823774] thunderbolt 0000:08:00.0: 0:3:   Unknown1: 0x0 Unknown2: 0x0 Unknown3: 0x0
[ 1872.823864] thunderbolt 0000:08:00.0: 3:2: Writing hop 0, index 8
[ 1872.823865] thunderbolt 0000:08:00.0: 3:2:  Hop through port 1 to hop 8 (enabled)
[ 1872.823867] thunderbolt 0000:08:00.0: 3:2:   Weight: 1 Priority: 3 Credits: 7 Drop: 0
[ 1872.823868] thunderbolt 0000:08:00.0: 3:2:    Counter enabled: 0 Counter index: 2047
[ 1872.823870] thunderbolt 0000:08:00.0: 3:2:   Flow Control (In/Eg): 1/1 Shared Buffer (In/Eg): 0/0
[ 1872.823871] thunderbolt 0000:08:00.0: 3:2:   Unknown1: 0x0 Unknown2: 0x0 Unknown3: 0x0
[ 1872.823963] thunderbolt 0000:08:00.0: path activation complete


And the tg3 driver didn't notice anything happened at all during that
process, so I did an rmmod/modprobe:

[ 1894.412903] tg3 0000:0b:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not clear MAC_TX_MODE=ffffffff
[ 1894.795333] cfg80211: Calling CRDA to update world regulatory domain
[ 1895.295757] tg3.c:v3.137 (May 11, 2014)
[ 1895.315622] tg3 0000:0b:00.0: Refused to change power state, currently in D3
[ 1895.463145] tg3 0000:0b:00.0: phy probe failed, err -19
[ 1895.463485] tg3 0000:0b:00.0: Problem fetching invariants of chip, aborting

Uh oh.

Here's the diff in 'lspci -nnvv' between unplug/replug:

--- before      2014-08-12 01:46:09.313859543 -0700
+++ after       2014-08-12 01:46:30.493241976 -0700
@@ -814,89 +814,89 @@
 07:03.0 PCI bridge [0604]: Intel Corporation Device [8086:156d] (prog-if 00 [Normal decode])
        Physical Slot: 2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 128 bytes
        Bus: primary=07, secondary=09, subordinate=39, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: c2000000-c5ffffff
        Prefetchable memory behind bridge: 00000000ce000000-00000000d20fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00378  Data: 0000
        Capabilities: [ac] Subsystem: Device [2222:1111]
        Capabilities: [c0] Express (v2) Downstream Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #3, PowerLimit 0.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
-                       Changed: MRL- PresDet- LinkState-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+                       Changed: MRL- PresDet+ LinkState+
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
-               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled ARIFwd-
+               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [100 v1] Device Serial Number 2e-dc-31-20-d3-f1-0c-00
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [300 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
-                       Status: NegoPending- InProgress-
+                       Status: NegoPending+ InProgress-
        Capabilities: [400 v1] Power Budgeting <?>
        Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=050 <?>
        Kernel driver in use: pcieport

@@ -1122,193 +1122,16 @@
        Kernel driver in use: thunderbolt
        Kernel modules: thunderbolt
 
-09:00.0 PCI bridge [0604]: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] [8086:1549] (prog-if 00 [Normal decode])
-       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 128 bytes
-       Bus: primary=09, secondary=0a, subordinate=0b, sec-latency=0
-       I/O behind bridge: 00003000-00003fff
-       Memory behind bridge: c2000000-c24fffff
-       Prefetchable memory behind bridge: 00000000ce000000-00000000ce0fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
-       BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
-               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
-       Capabilities: [80] Power Management version 3
-               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
-               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
-       Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
-               Address: 00000000fee003f8  Data: 0000
-       Capabilities: [c0] Express (v2) Upstream Port, MSI 00
-               DevCap: MaxPayload 128 bytes, PhantFunc 0
-                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ SlotPowerLimit 0.000W
-               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
-                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
-                       MaxPayload 128 bytes, MaxReadReq 512 bytes
-               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
-               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s unlimited, L1 unlimited
-                       ClockPM+ Surprise- LLActRep- BwNot-
-               LnkCtl: ASPM Disabled; Disabled- CommClk+
-                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
-               DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported
-               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
-               LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
-                        Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
-                        Compliance De-emphasis: -6dB
-               LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
-                        EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
-       Capabilities: [100 v1] Device Serial Number 01-00-00-00-00-c9-a0-00
-       Capabilities: [200 v1] Advanced Error Reporting
-               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
-               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
-               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
-               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
-       Capabilities: [300 v1] Virtual Channel
-               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
-               Arb:    Fixed- WRR32- WRR64- WRR128-
-               Ctrl:   ArbSelect=Fixed
-               Status: InProgress-
-               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
-                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
-                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
-                       Status: NegoPending- InProgress-
-       Capabilities: [400 v1] Power Budgeting <?>
-       Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=01c <?>
+09:00.0 PCI bridge [0604]: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] [8086:1549] (rev ff) (prog-if ff)
+       !!! Unknown header type 7f
        Kernel driver in use: pcieport
 
-0a:00.0 PCI bridge [0604]: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] [8086:1549] (prog-if 00 [Normal decode])
-       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 128 bytes
-       Bus: primary=0a, secondary=0b, subordinate=0b, sec-latency=0
-       I/O behind bridge: 00003000-00003fff
-       Memory behind bridge: c2000000-c24fffff
-       Prefetchable memory behind bridge: 00000000ce000000-00000000ce0fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
-       BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
-               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
-       Capabilities: [80] Power Management version 3
-               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
-               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
-       Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
-               Address: 00000000fee00418  Data: 0000
-       Capabilities: [c0] Express (v2) Downstream Port (Slot+), MSI 00
-               DevCap: MaxPayload 128 bytes, PhantFunc 0
-                       ExtTag+ RBE+
-               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
-                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
-                       MaxPayload 128 bytes, MaxReadReq 512 bytes
-               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s unlimited, L1 unlimited
-                       ClockPM- Surprise- LLActRep+ BwNot+
-               LnkCtl: ASPM Disabled; Disabled- CommClk+
-                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
-               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
-                       Slot #9, PowerLimit 0.000W; Interlock- NoCompl-
-               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
-                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
-                       Changed: MRL- PresDet- LinkState-
-               DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
-               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
-               LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
-                        Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
-                        Compliance De-emphasis: -6dB
-               LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
-                        EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
-       Capabilities: [100 v1] Device Serial Number 01-00-00-00-00-c9-a0-00
-       Capabilities: [200 v1] Advanced Error Reporting
-               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
-               CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
-               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
-               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
-       Capabilities: [300 v1] Virtual Channel
-               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
-               Arb:    Fixed- WRR32- WRR64- WRR128-
-               Ctrl:   ArbSelect=Fixed
-               Status: InProgress-
-               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
-                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
-                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
-                       Status: NegoPending- InProgress-
-       Capabilities: [400 v1] Power Budgeting <?>
-       Capabilities: [500 v1] Vendor Specific Information: ID=1234 Rev=1 Len=01c <?>
+0a:00.0 PCI bridge [0604]: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] [8086:1549] (rev ff) (prog-if ff)
+       !!! Unknown header type 7f
        Kernel driver in use: pcieport
 
-0b:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe [14e4:1682]
-       Subsystem: Apple Inc. Device [106b:00f6]
-       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 128 bytes
-       Interrupt: pin A routed to IRQ 16
-       Region 0: Memory at ce000000 (64-bit, prefetchable) [size=64K]
-       Region 2: Memory at ce010000 (64-bit, prefetchable) [size=64K]
-       Expansion ROM at c2000000 [disabled] [size=64K]
-       Capabilities: [48] Power Management version 3
-               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
-               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
-       Capabilities: [50] Vital Product Data
-               Product Name: Thunderbolt Ethernet
-               Read-only fields:
-                       [PN] Part number: BCM957762
-                       [EC] Engineering changes: 106679-15
-                       [SN] Serial number: 0123456789
-                       [MN] Manufacture ID: 31 34 65 34
-                       [RV] Reserved: checksum good, 53 byte(s) reserved
-               Read/write fields:
-                       [YA] Asset tag: XYZ01234567
-                       [RW] Read-write area: 107 byte(s) free
-               End
-       Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
-               Address: 0000000000000000  Data: 0000
-       Capabilities: [a0] MSI-X: Enable+ Count=6 Masked-
-               Vector table: BAR=2 offset=00000000
-               PBA: BAR=2 offset=00000120
-       Capabilities: [ac] Express (v2) Endpoint, MSI 00
-               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
-                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
-               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
-                       RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
-                       MaxPayload 128 bytes, MaxReadReq 4096 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <2us, L1 <64us
-                       ClockPM+ Surprise- LLActRep- BwNot-
-               LnkCtl: ASPM Disableparentd; RCB 64 bytes Disabled- CommClk+
-                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
-               DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Not Supported
-               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
-               LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
-                        Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
-                        Compliance De-emphasis: -6dB
-               LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
-                        EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
-       Capabilities: [100 v1] Advanced Error Reporting
-               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
-               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
-               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
-               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
-               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
-       Capabilities: [13c v1] Device Serial Number 00-00-a8-20-66-3c-64-4a
-       Capabilities: [150 v1] Power Budgeting <?>
-       Capabilities: [160 v1] Virtual Channel
-               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
-               Arb:    Fixed- WRR32- WRR64- WRR128-
-               Ctrl:   ArbSelect=Fixed
-               Status: InProgress-
-               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
-                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
-                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
-                       Status: NegoPending- InProgress-
-       Capabilities: [1b0 v1] Latency Tolerance Reporting
-               Max snoop latency: 0ns
-               Max no snoop latency: 0ns
+0b:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe [14e4:1682] (rev ff) (prog-if ff)
+       !!! Unknown header type 7f
        Kernel driver in use: tg3
        Kernel modules: tg3


So now I've got 3 confused devices that have fallen off the bus.

If I ask the surviving parent bridge (07:03.0) to rescan for devices via
sysfs, this is what I get in dmesg:

[ 3985.833685] pcieport 0000:09:00.0: bridge configuration invalid ([bus ff-ff]), reconfiguring
[ 3985.833739] pcieport 0000:07:00.0: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
[ 3985.833743] pcieport 0000:07:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 08] add_size 200000
[ 3985.833767] pcieport 0000:07:04.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[ 3985.833770] pcieport 0000:07:04.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[ 3985.833771] pcieport 0000:07:04.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[ 3985.833784] pcieport 0000:07:06.0: bridge window [io  0x1000-0x0fff] to [bus 6c] add_size 1000
[ 3985.833786] pcieport 0000:07:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 6c] add_size 200000
[ 3985.833788] pcieport 0000:07:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 6c] add_size 200000
[ 3985.833792] pcieport 0000:07:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[ 3985.833794] pcieport 0000:07:04.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[ 3985.833796] pcieport 0000:07:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[ 3985.833797] pcieport 0000:07:06.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[ 3985.833799] pcieport 0000:07:06.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[ 3985.833801] pcieport 0000:07:00.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[ 3985.833802] pcieport 0000:07:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[ 3985.833804] pcieport 0000:07:06.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[ 3985.833810] pcieport 0000:07:00.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833811] pcieport 0000:07:00.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833814] pcieport 0000:07:04.0: BAR 14: no space for [mem size 0x00200000]
[ 3985.833815] pcieport 0000:07:04.0: BAR 14: failed to assign [mem size 0x00200000]
[ 3985.833818] pcieport 0000:07:04.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833820] pcieport 0000:07:04.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833821] pcieport 0000:07:06.0: BAR 14: no space for [mem size 0x00200000]
[ 3985.833823] pcieport 0000:07:06.0: BAR 14: failed to assign [mem size 0x00200000]
[ 3985.833825] pcieport 0000:07:06.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833827] pcieport 0000:07:06.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833829] pcieport 0000:07:00.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833831] pcieport 0000:07:00.0: BAR 13: failed to assign [io  size 0x1000]
[ 3985.833832] pcieport 0000:07:04.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833834] pcieport 0000:07:04.0: BAR 13: failed to assign [io  size 0x1000]
[ 3985.833835] pcieport 0000:07:06.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833837] pcieport 0000:07:06.0: BAR 13: failed to assign [io  size 0x1000]
[ 3985.833840] pcieport 0000:07:06.0: BAR 14: no space for [mem size 0x00200000]
[ 3985.833841] pcieport 0000:07:06.0: BAR 14: failed to assign [mem size 0x00200000]
[ 3985.833844] pcieport 0000:07:06.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833845] pcieport 0000:07:06.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833847] pcieport 0000:07:06.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833848] pcieport 0000:07:06.0: BAR 13: failed to assign [io  size 0x1000]
[ 3985.833850] pcieport 0000:07:04.0: BAR 14: no space for [mem size 0x00200000]
[ 3985.833852] pcieport 0000:07:04.0: BAR 14: failed to assign [mem size 0x00200000]
[ 3985.833854] pcieport 0000:07:04.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833856] pcieport 0000:07:04.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833858] pcieport 0000:07:04.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833859] pcieport 0000:07:04.0: BAR 13: failed to assign [io  size 0x1000]
[ 3985.833862] pcieport 0000:07:00.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[ 3985.833863] pcieport 0000:07:00.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[ 3985.833865] pcieport 0000:07:00.0: BAR 13: no space for [io  size 0x1000]
[ 3985.833866] pcieport 0000:07:00.0: BAR 13: failed to assign [io  size 0x1000]

Hrm. Any idea what to do here? I also tried some 'setpci' hackery on the
surviving bridge with a secondary bus reset and a link retrain. Neither
seems to have any effect.

- Steven
