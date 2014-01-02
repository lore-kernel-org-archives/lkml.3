Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaABV45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:56:57 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:54354 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753274AbaABV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:56:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131223174634.GD25089@obsidianresearch.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<1387785725-24262-3-git-send-email-tinamdar@apm.com>
	<20131223174634.GD25089@obsidianresearch.com>
Date: Thu, 2 Jan 2014 13:56:51 -0800
Message-ID: <CACoXjcnPvgDX3s8OywLHP6Tu2OrpNzM1Phx+s3RLmKDgu3t8gA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] arm64: dts: APM X-Gene PCIe device tree nodes
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 9:46 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Dec 23, 2013 at 01:32:03PM +0530, Tanmay Inamdar wrote:
>> This patch adds the device tree nodes for APM X-Gene PCIe controller and
>> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts nodes
>> are added.
>
> Can you include an lspci dump for PCI DT bindings please? It is
> impossible to review otherwise..
>

On the X-Gene evaluation platform, there is only one PCIe port
enabled. Here is the 'lspci' dump

# lspci -vvv
00:00.0 Class 0604: Device 19aa:e008 (rev 04)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Region 0: Memory at <ignored> (64-bit, prefetchable)
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 00c00000-00cfffff
        Prefetchable memory behind bridge: 0000000000000000-0000000000bfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 16384 bytes, PhantFunc 1, Latency
L0s <1us, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend+
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #1, PowerLimit 10.000W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete+, EqualizationPhase1+
                         EqualizationPhase2+, EqualizationPhase3+,
LinkEqualizationRequest-
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP+ BadDLLP+ Rollover- Timeout+ NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [180 v1] #19
        Capabilities: [150 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>

01:00.0 Class 0200: Device 15b3:1003
        Subsystem: Device 15b3:0049
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 226
        Region 0: Memory at e000c00000 (64-bit, non-prefetchable) [size=1M]
        Region 2: Memory at e000000000 (64-bit, prefetchable) [size=8M]
        Expansion ROM at e000800000 [size=1M]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
                Product Name: CX312A - ConnectX-3 SFP+
                Read-only fields:
                        [PN] Part number: MCX312A-XCBT
                        [EC] Engineering changes: A5
                        [SN] Serial number: MT1338X00578
                        [V0] Vendor specific: PCIe Gen3 x8
                        [RV] Reserved: checksum good, 0 byte(s) reserved
                Read/write fields:
                        [V1] Vendor specific: N/A
                        [YA] Asset tag: N/A
                        [RW] Read-write area: 105 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 252 byte(s) free
                End
        Capabilities: [9c] MSI-X: Enable- Count=128 Masked-
                Vector table: BAR=0 offset=0007c000
                PBA: BAR=0 offset=0007d000
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<64ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #8, Speed 8GT/s, Width x8, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Alternative Routing-ID Interpretation (ARI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Capabilities: [148 v1] Device Serial Number f4-52-14-03-00-0b-dc-90
        Capabilities: [154 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [18c v1] #19
        Kernel driver in use: mlx4_core


> Regards,
> Jason
