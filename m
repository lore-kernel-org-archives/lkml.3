Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaBIWIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:08:09 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38645 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaBIWHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:07:18 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Bastien Traverse <bastien.traverse@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        francis.moro@gmail.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Sun, 09 Feb 2014 23:07:14 +0100
Message-ID: <2182978.C0zdYi5cqX@al>
User-Agent: KMail/4.12.2 (Linux/3.13.2-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <52F7CC8B.1020209@gmail.com>
References: <52F2CC7B.80406@gmail.com> <2087423.Qy7HQIx1X6@vostro.rjw.lan> <52F7CC8B.1020209@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 February 2014 19:44:27 Bastien Traverse wrote:
> You'll find them attached, but I got a strange error when I wanted to
> run it as root:
> $ sudo lspci -vv > lspci_vv_before
> pcilib: sysfs_read_vpd: read failed: Connection timed out
> $ sudo -i
> # lspci -vv
> pcilib: sysfs_read_vpd: read failed: Connection timed out
> 
> So I only got the unpriviledge output.

This seems to be an issue of the rtsx driver / hardware, I also see it on
a small Shuttle computer that runs at work. (off-topic lspci post:)
02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device [10ec:5289] (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:5289]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 43
        Region 0: Memory at dfe00000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41c1
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
                Vector table: BAR=0 offset=00000000
                PBA: BAR=0 offset=00000000
        Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
                Not readable
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: rtsx_pci
        Kernel modules: rtsx_pci

> Some complementary lines from my journal:
> 
> kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> kernel: r8169 0000:03:00.2: can't disable ASPM; OS doesn't have ASPM control
> kernel: pcieport 0000:00:1c.3: driver skip pci_set_master, fix it! kernel:
> r8169 0000:03:00.2: irq 44 for MSI/MSI-X
> kernel: r8169 0000:03:00.2 eth0: RTL8411 at 0xffffc90016ed4000,
> 00:90:f5:d7:34:53, XID 08800800 IRQ 44
> kernel: r8169 0000:03:00.2 eth0: jumbo features [frames: 9200 bytes, tx
> checksumming: ko]
> kernel: rtsx_pci 0000:03:00.0: irq 45 for MSI/MSI-X
> kernel: rtsx_pci 0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1,
> pci->irq = 45
> ...
> 
> And one I thought of interest:
> 
> kernel: rtsx_pci 0000:03:00.0: vpd r/w failed.  This is likely a
> firmware bug on this device.  Contact the card vendor for a firmware update.

I think I have seen such an error before, but I cannot find it in the logs
that were obtained a while ago. Failure to read VPD should not cause issues.

> That came three times before suspend.
> 
> Only two lines about hotplug, none special.

I think this is relevant. See also my test with 3.13.2 and different
kernel configs[1]. A workaround that triggers a scan was also posted[2].

Peter

 [1]: http://lkml.org/lkml/2014/2/8/264
 [2]: http://lkml.org/lkml/2014/2/7/809

