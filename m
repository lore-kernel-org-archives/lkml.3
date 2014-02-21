Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaBUOsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:48:05 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46217 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaBUOsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140220174503.GB19893@obsidianresearch.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
	<CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
	<20140219003523.GJ29304@obsidianresearch.com>
	<CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
	<20140220174503.GB19893@obsidianresearch.com>
Date: Fri, 21 Feb 2014 20:18:00 +0530
X-Google-Sender-Auth: Lbi2QrO7KILxnS9g73WsKdJan4g
Message-ID: <CA+mB=1L+QM2cKq==mwYesp=E7S2N-xTiN7AoBvbzAO2UMn0qVQ@mail.gmail.com>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:15 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Feb 20, 2014 at 12:39:48PM +0530, Srikanth Thokala wrote:
>
>> > These should use the standard ranges mechanism for translations and
>> > apertures.
>>
>> This AXI PCIe bridge IP do have two kind of BARs AXI-to-PCIe BAR and
>> PCIe-to-AXI BAR.  The former specifies the AXI Base address and are the
>> memory windows, these are listed in the 'ranges' DT property.  The latter
>> BAR specifies the addresses that PCI Express should respond to/is
>
> The PCIe-to-AXI window should be setup by the driver automatically to
> span all system memory, it doesn't need to be in DT.
>
> The AXI-to-PCIe is the host bridge aperture and it should be in the DT
> ranges.

Ok.

>
>> tallowed to write to and these addresses written to configuration space
>> during the initialization.
>
> Hopefully this was done in a conformant way, please provide a lspci
> -vv next round please..

Here is the information,

# /opt/lspci  -vv
00:00.0 Class 0604: Device 10ee:7081
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00000000-00000fff
        Memory behind bridge: 00000000-000fffff
        Prefetchable memory behind bridge: 00000000-000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [60] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 1
                        ExtTag+ RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s,
Exit Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [128 v1] Vendor Specific Information: ID=0001
Rev=0 Len=038 <?>
        Capabilities: [200 v1] Vendor Specific Information: ID=0002
Rev=0 Len=038 <?>

01:00.0 Class 0200: Device 14e4:1677 (rev 11)
        Subsystem: Device 14e4:1677
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 91
        Region 0: Memory at 60000000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at 60010000 [disabled] [size=64K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
                Product Name: HPQ 10/100/1000 Copper Based Gigabit Adapter
                Read-only fields:
                        [PN] Part number: BCM95751A519
                        [EC] Engineering changes: 112791-10
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 34 65 34
                        [RV] Reserved: checksum good, 26 byte(s) reserved
                Read/write fields:
                        [YA] Asset tag: XYZ01234567
                        [RW] Read-write area: 107 byte(s) free
                End
        Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: 08b2110000004608  Data: 5e08
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Exit Latency L0s <2us, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [13c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: tg3

>
>> > Also, IMHO, only root ports should be supported in a host bridge
>> > driver. A PCI end point is something entirely different.
>>
>> We are not supporting end point in this driver.  This is a soft IP
>> and can be configurable as a Root Port/End point while creating a HW
>> design in the FPGA.  So, the driver use this DT property to first
>> check if it is configured for Root Port and bail out if it is not.
>
> This is something that should be handled via the compatible string, not
> special properties. Root port and End port will have different
> drivers, so they must have different compatible strings.
>
> There is nothing wrong with dumping core generator configuration
> properties into the DT (as a form of documentation), but you must
> still use the standard techniques and properties whenever possible.

Ok, I agree and will correct them in my next version.

Thanks
Srikanth

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
