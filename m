Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaAISZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:25:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaAISZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:25:16 -0500
Message-ID: <1389291911.3209.234.camel@bling.home>
Subject: Re: [PATCH] pci/iov: VFs are never multifunction
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        sathya.perla@emulex.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ajit.khaparde@emulex.com, Don Dutile <ddutile@redhat.com>,
        subbu.seetharaman@emulex.com, Myron Stowe <myron.stowe@redhat.com>
Date: Thu, 09 Jan 2014 11:25:11 -0700
In-Reply-To: <CAErSpo4Asnx4JiZvppZLUzxmVymz0t-fHXRFMr81-Qz31XyR+g@mail.gmail.com>
References: <20140109153513.21446.31778.stgit@bling.home>
	 <CAErSpo4Asnx4JiZvppZLUzxmVymz0t-fHXRFMr81-Qz31XyR+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 11:08 -0700, Bjorn Helgaas wrote:
> On Thu, Jan 9, 2014 at 8:36 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Per the SR-IOV spec rev 1.1:
> >
> > 3.4.1.9 Header Type (Offset 0Eh)
> >
> > "... For VFs, this register must be RO Zero."
> >
> > Unfortunately some devices get this wrong, ex. Emulex OneConnect 10Gb
> > NIC.  When they do it makes us handle ACS testing and therefore IOMMU
> > groups as if they were actual multifunction devices and require ACS
> > capabilities to make sure there's no peer-to-peer between functions.
> > VFs are never traditional multifunction devices, so simply clear this
> > bit before we get any further into setup.
> 
> This seems reasonable.  Do you have "lspci -vvxxxx" output for this
> device?  I'd like to save it for future reference.

Sure, here's a VF:

09:04.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)
	Subsystem: Emulex Corporation Device e722
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: [virtual] Memory at df980000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [48] MSI-X: Enable+ Count=2 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [c0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <16us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <2us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b8] Vital Product Data
		Product Name: O�L\x00O102-NM, 10GBIT/S ETHERNET ADAPTER, PCIE, 2P, 10GBASE-SR OPTICAL, NIC VF
		Read-only fields:
			[PN] Part number: OCe11102-NM
			[SN] Serial number: BK20210736
			[V0] Vendor specific: BK20210736
			[VB] Vendor specific: PW=12W; PCIe 2.0 x8 5GT/s
			[V1] Vendor specific: Emulex OneConnect OCe11102-NM 2NM 2t PCIe 10GbE CNA
			[V2] Vendor specific: OCe11102-NM
			[V4] Vendor specific: 0
			[RV] Reserved: checksum bad, 29 byte(s) reserved
		End
	Capabilities: [100 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [12c v1] Transaction Processing Hints
		No steering table available
	Kernel driver in use: vfio-pci
00: ff ff ff ff 04 00 10 00 01 00 00 02 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 df 10 22 e7
30: 00 00 00 00 48 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 11 c0 01 80 00 20 00 00
50: 00 30 00 00 00 26 c0 90 41 01 01 c0 41 06 00 ff
60: fc ff f4 00 00 00 00 00 0f 4c a7 09 bf 05 ff ff
70: e0 e0 ff ff ff ff 08 7c 00 00 00 00 00 c0 00 00
80: 11 10 00 00 11 10 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00
b0: ff ff ff ff ff ff ff ff 03 00 fc 80 00 00 00 78
c0: 10 b8 02 00 02 89 64 10 2e 20 00 00 82 5c 42 00
d0: 40 00 82 10 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 20 00 00 00

> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/iov.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 1fe2d6f..e2fbb67 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -84,6 +84,7 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
> >         virtfn->dev.parent = dev->dev.parent;
> >         virtfn->physfn = pci_dev_get(dev);
> >         virtfn->is_virtfn = 1;
> > +       virtfn->multifunction = 0;
> >
> >         for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
> >                 res = dev->resource + PCI_IOV_RESOURCES + i;
> >



