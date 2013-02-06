Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3BFSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:09:26 -0500
Received: from meriadoc.sigma-star.at ([178.63.61.2]:44213 "EHLO
	meriadoc.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3BFSJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:09:23 -0500
Date: Wed, 6 Feb 2013 19:09:08 +0100
From: Richard Weinberger <richard@sigma-star.at>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gstir <david@sigma-star.at>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DMAR faults from unrelated device when vfio is used
Message-ID: <20130206190908.79073124@spider.haslach.nod.at>
In-Reply-To: <1360096613.11144.612.camel@bling.home>
References: <1359972630.2498.21.camel@riven-lux.site>
	<1359992968.11144.414.camel@bling.home>
	<1360071110.6200.19.camel@riven-lux.site>
	<1360078648.11144.558.camel@bling.home>
	<1360096613.11144.612.camel@bling.home>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Tue, 05 Feb 2013 13:36:53 -0700
schrieb Alex Williamson <alex.williamson@redhat.com>:
> > Ugh, the infamous and useless error 10.  It could be anything.
> > I've got a system with onboard usb3, let me see what windows does
> > with it here first.  Thanks,
> 
> Well, I've got an Etron USB3 HBA and (un)fortunately it works just
> fine with a Win7 guest.  There's really nothing special about USB
> controllers from a PCI device assignment perspective.  Have you tried
> the latest upstream qemu bits?  Thanks,

USB3 does also not work within a Linux guest.
xhci in debug mode gives a bit more infos.

[    1.157888] xhci_hcd 0000:00:07.0: xHCI Host Controller
[    1.157899] xhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 4
[    1.157948] xhci_hcd 0000:00:07.0: // Halt the HC
[    1.157957] xhci_hcd 0000:00:07.0: Resetting HCD
[    1.157962] xhci_hcd 0000:00:07.0: // Reset the HC
[    1.158111] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    1.158125] xhci_hcd 0000:00:07.0: Wait for controller to be ready for doorbell rings
[    1.158130] xhci_hcd 0000:00:07.0: Reset complete
[    1.158133] xhci_hcd 0000:00:07.0: Enabling 64-bit DMA addresses.
[    1.158135] xhci_hcd 0000:00:07.0: Calling HCD init
[    1.158136] xhci_hcd 0000:00:07.0: xhci_init
[    1.158137] xhci_hcd 0000:00:07.0: xHCI doesn't need link TRB QUIRK
[    1.158640] xhci_hcd 0000:00:07.0: Finished xhci_init
[    1.158642] xhci_hcd 0000:00:07.0: Called HCD init
[    1.158698] xhci_hcd 0000:00:07.0: irq 11, io mem 0xfebf4000
[    1.158699] xhci_hcd 0000:00:07.0: xhci_run
[    1.159578] xhci_hcd 0000:00:07.0: irq 40 for MSI/MSI-X
[    1.159697] xhci_hcd 0000:00:07.0: irq 41 for MSI/MSI-X
[    1.159720] xhci_hcd 0000:00:07.0: irq 42 for MSI/MSI-X
[    1.159736] xhci_hcd 0000:00:07.0: irq 43 for MSI/MSI-X
[    1.159752] xhci_hcd 0000:00:07.0: irq 44 for MSI/MSI-X
[    1.179682] xhci_hcd 0000:00:07.0: Setting event ring polling timer
[    1.179686] xhci_hcd 0000:00:07.0: Command ring memory map follows:
[    1.179693] xhci_hcd 0000:00:07.0: ERST memory map follows:
[    1.179695] xhci_hcd 0000:00:07.0: Event ring:
[    1.179702] xhci_hcd 0000:00:07.0: ERST deq = 64'h36820400
[    1.179703] xhci_hcd 0000:00:07.0: // Set the interrupt modulation register
[    1.179710] xhci_hcd 0000:00:07.0: // Enable interrupts, cmd = 0x4.
[    1.179715] xhci_hcd 0000:00:07.0: // Enabling event ring interrupter ffffc90000e68620 by writing 0x2 to irq_pending
[    1.179737] xhci_hcd 0000:00:07.0: Finished xhci_run for USB2 roothub
[    1.179752] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    1.179753] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.179755] usb usb4: Product: xHCI Host Controller
[    1.179756] usb usb4: Manufacturer: Linux 3.8.0-rc6-2.10-desktop xhci_hcd
[    1.179757] usb usb4: SerialNumber: 0000:00:07.0
[    1.179967] xHCI xhci_add_endpoint called for root hub
[    1.179971] xHCI xhci_check_bandwidth called for root hub
[    1.180081] hub 4-0:1.0: USB hub found
[    1.180094] hub 4-0:1.0: 2 ports detected
[    1.180200] xhci_hcd 0000:00:07.0: xHCI Host Controller
[    1.180206] xhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 5
[    1.180214] xhci_hcd 0000:00:07.0: Enabling 64-bit DMA addresses.
[    1.180219] xhci_hcd 0000:00:07.0: // Turn on HC, cmd = 0x5.
[    1.245201] xhci_hcd 0000:00:07.0: Host took too long to start, waited 16000 microseconds.

This one looks interesting.

[    1.245414] xhci_hcd 0000:00:07.0: // Halt the HC
[    1.245424] xhci_hcd 0000:00:07.0: startup error -19
[    1.245551] xhci_hcd 0000:00:07.0: USB bus 5 deregistered
[    1.245556] xhci_hcd 0000:00:07.0: remove, state 1
[    1.245560] usb usb4: USB disconnect, device number 1
[    1.245608] xHCI xhci_drop_endpoint called for root hub
[    1.245609] xHCI xhci_check_bandwidth called for root hub
[    1.245684] xhci_hcd 0000:00:07.0: // Halt the HC
[    1.245695] xhci_hcd 0000:00:07.0: // Reset the HC
[    1.245741] xhci_hcd 0000:00:07.0: Wait for controller to be ready for doorbell rings
[    1.256413] xhci_hcd 0000:00:07.0: // Disabling event ring interrupts
[    1.256427] xhci_hcd 0000:00:07.0: cleaning up memory
[    1.256440] xhci_hcd 0000:00:07.0: xhci_stop completed - status = 1
[    1.256446] xhci_hcd 0000:00:07.0: USB bus 4 deregistered
[    1.258194] ata_piix 0000:00:01.1: version 2.13

Within the guest lscpi -vv gives:

00:07.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04) (prog-if 30 [XHCI])
        Subsystem: Intel Corporation Device 2008
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at febf4000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [90] MSI-X: Enable- Count=8 Masked-
                Vector table: BAR=0 offset=00001000
                PBA: BAR=0 offset=00001080
        Capabilities: [a0] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Is there anything else we can do?

Thanks,
//richard
