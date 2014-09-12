Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaILWGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:06:15 -0400
Received: from services.gouders.net ([141.101.32.176]:53960 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaILWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:06:13 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 12 Sep 2014 14:49:34 -0700")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 13 Sep 2014 00:05:00 +0200
Message-ID: <ghoaukcx6b.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Sep 12, 2014 at 1:54 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> On Fri, Sep 12, 2014 at 1:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>> Dirk Gouders <dirk@gouders.net> writes:
>> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>>            +-03.0  Broadcom BCM5785 [HT1000] USB
>>            +-03.1  Broadcom BCM5785 [HT1000] USB
>>            +-03.2  Broadcom BCM5785 [HT1000] USB
>>            +-06.0-[03]--
>>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>            +-0a.0-[05]--
>>            +-0b.0-[06]--
>
> what is "lspci -tv" and "lspci -vvxxx" look like before your patch that cut down
> end bus to 07 ...?

Rebooted with 3.16 kernel:

# lspci -tv

-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-08.0-[05]--
           +-09.0-[06]--
           +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
           +-0b.0-[08]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control

# lspci -vvxxx
00:01.0 PCI bridge: Broadcom BCM5785 [HT1000] PCI/PCI-X Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=64
	I/O behind bridge: 00007000-00008fff
	Memory behind bridge: ff100000-ff1fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [90] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
		Status: Dev=00:01.0 64bit- 133MHz- SCD- USC- SCO- SRD-
		Upstream: Capacity=0 CommitmentLimit=0
		Downstream: Capacity=0 CommitmentLimit=0
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=1 UnitCnt=3 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config 0: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Link Control 1: CFlE- CST- CFE- <LkFail- Init- EOC+ TXO+ <CRCErr=0
		Link Config 1: MLWI=8bit MLWO=8bit LWI=N/C LWO=N/C
		Revision ID: 0.00
	Capabilities: [d8] Subsystem: Device 0000:0000
00: 66 11 36 00 07 00 10 08 00 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 01 02 40 71 81 00 24
20: 10 ff 10 ff f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 90 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 00 00 00 01 01 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c0 74 00 c0
60: c5 60 30 18 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 01 04 08 00 01 08 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 07 a0 c3 00 08 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 08 d8 61 00 20 00 00 00 c0 00 00 77 00 05 75 00
c0: 02 00 35 00 00 00 00 00 00 00 00 00 0c 05 03 03
d0: 00 00 00 00 e0 0f 04 00 0d 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 80 00 40 00 04 00 00 00 00 00 00 00 00 00

00:02.0 Host bridge: Broadcom BCM5785 [HT1000] Legacy South Bridge
	Subsystem: Broadcom Device 0201
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
00: 66 11 05 02 07 01 00 02 00 00 00 06 00 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 01 02
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: a0 28 12 04 00 ff 00 00 07 00 00 00 10 04 10 04
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 8f c1 f3 1d 00 00 00 40 36 01 00 01
70: 0b 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00
80: 80 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 81 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 IDE interface: Broadcom BCM5785 [HT1000] IDE (prog-if 8a [Master SecP PriP])
	Subsystem: Broadcom BCM5785 [HT1000] IDE
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374
	Region 4: I/O ports at ffa0 [size=16]
	Kernel driver in use: pata_serverworks
00: 66 11 14 02 05 00 00 02 00 8a 01 01 10 40 80 00
10: f1 01 00 00 f5 03 00 00 71 01 00 00 75 03 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 66 11 14 02
30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
40: 5d 5d 5d 5d ff ff ff ff f0 f1 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 0f 04 03 00 00 00 00 00
60: 00 00 00 00 01 07 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.2 ISA bridge: Broadcom BCM5785 [HT1000] LPC
	Subsystem: Broadcom Device 0230
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 66 11 34 02 07 01 00 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 30 02
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 0c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 11
90: 40 00 06 ff 00 ff 00 00 00 00 00 00 7c 64 00 00
a0: 00 00 00 00 03 03 02 ff 00 0a 00 0a ff ff 0f 00
b0: 03 a9 00 04 09 00 00 00 20 00 80 00 80 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.0 USB controller: Broadcom BCM5785 [HT1000] USB (rev 01) (prog-if 10 [OHCI])
	Subsystem: Broadcom BCM5785 [HT1000] USB
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ff6e8000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d400 [size=256]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Kernel driver in use: ohci-pci
00: 66 11 23 02 17 01 b0 02 01 10 03 0c 10 40 80 00
10: 00 80 6e ff 01 d4 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 23 02
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 00 00
40: 80 ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 00
e0: 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.1 USB controller: Broadcom BCM5785 [HT1000] USB (rev 01) (prog-if 10 [OHCI])
	Subsystem: Broadcom BCM5785 [HT1000] USB
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ff6e9000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d800 [size=256]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Kernel driver in use: ohci-pci
00: 66 11 23 02 17 01 b0 02 01 10 03 0c 10 40 00 00
10: 00 90 6e ff 01 d8 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 23 02
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 00 00
40: 80 ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 00
e0: 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.2 USB controller: Broadcom BCM5785 [HT1000] USB (rev 01) (prog-if 20 [EHCI])
	Subsystem: Broadcom BCM5785 [HT1000] USB
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ff6ea000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at e800 [size=256]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Kernel driver in use: ehci-pci
00: 66 11 23 02 17 01 b0 02 01 20 03 0c 10 40 00 00
10: 00 a0 6e ff 01 e8 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 23 02
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 00 00
40: 80 ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 00 00 00 20 00 00 00 20 00 00 00 20 00 00
70: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 c0 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 7e
e0: 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:06.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-X bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [90] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
		Status: Dev=00:06.0 64bit- 133MHz- SCD- USC- SCO- SRD-
		Upstream: Capacity=0 CommitmentLimit=0
		Downstream: Capacity=0 CommitmentLimit=0
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=6 UnitCnt=6 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config 0: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 0.00
00: 66 11 30 01 06 00 10 00 a3 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 40 f1 01 00 22
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 90 00 00 00 00 00 00 00 60 00 04 02
40: 00 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 ca 53 00 c0
60: 05 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 00 00 20 03 00 00 00 01 04 08 00 00 08 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 07 a0 c3 00 30 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 08 00 c6 00 20 00 11 11 20 00 00 00 00 06 75 00
c0: 02 05 35 00 00 00 00 00 00 00 00 00 0c 56 03 03
d0: 00 00 00 00 e0 0f 04 00 00 00 00 00 00 00 00 00
e0: 00 00 00 07 00 00 00 00 00 ff ca 20 00 00 00 00
f0: 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00

00:07.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-X bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=64
	Memory behind bridge: ff200000-ff2fffff
	Prefetchable memory behind bridge: 00000000cfd00000-00000000cfdfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [90] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
		Status: Dev=00:07.0 64bit- 133MHz- SCD- USC- SCO- SRD-
		Upstream: Capacity=0 CommitmentLimit=0
		Downstream: Capacity=0 CommitmentLimit=0
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
00: 66 11 30 01 06 00 10 00 a3 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 40 f1 01 00 24
20: 20 ff 20 ff d1 cf d1 cf 00 00 00 00 00 00 00 00
30: 00 00 00 00 90 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 00 00 00 00 00 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c8 00 00 c0
60: 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 00 00 20 01 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 07 a0 c3 00 38 00 00 00 00 00 00 00 00 00 00 00
a0: 08 00 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 08 00 c0 00 00 00 11 00 00 00 00 00 00 00 75 00
c0: 02 00 35 00 00 00 00 00 00 00 00 00 0c 00 03 03
d0: 00 00 00 00 e0 0f 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 ff 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:08.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-Express Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag- RBE-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x8, ASPM L0s L1, Exit Latency L0s <4us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport
00: 66 11 32 01 06 00 10 00 a3 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 40 f1 01 00 02
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 01 00 00 00 00 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0
60: 01 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 09 8f 84 34 00 00 00 00 01 00 00 00 00 00
80: 01 00 00 00 20 10 70 2b 72 0a 18 00 01 00 00 fb
90: 90 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 10 00 41 00 82 09 00 00 00 00 00 00 81 6c 02 01
c0: 08 00 81 00 00 00 08 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-Express Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=64
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag- RBE-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <4us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport
00: 66 11 32 01 06 00 10 00 a3 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 06 06 40 f1 01 00 02
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 01 00 00 00 00 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0
60: 01 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 09 8f 84 34 00 00 00 00 01 00 00 00 00 00
80: 01 00 00 00 20 10 70 2b 72 0a 18 00 01 00 00 fb
90: 90 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 10 00 41 00 82 09 00 00 00 00 00 00 41 6c 02 02
c0: 08 00 01 00 00 00 10 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0a.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-Express Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=64
	I/O behind bridge: 00009000-0000bfff
	Memory behind bridge: ff300000-ff5fffff
	Prefetchable memory behind bridge: 00000000cfe00000-00000000cfefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag- RBE-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x8, ASPM L0s L1, Exit Latency L0s <4us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport
00: 66 11 32 01 07 00 10 00 a3 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 07 07 40 91 b1 00 22
20: 30 ff 50 ff e1 cf e1 cf 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 01 00 00 00 00 00 0c 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0
60: 01 00 08 01 00 00 00 00 00 00 00 01 00 00 00 00
70: 24 00 09 0f 84 34 00 00 00 00 01 00 00 00 00 00
80: 01 00 00 00 20 10 70 2b 72 0a 18 00 02 60 00 fb
90: 90 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 10 00 41 00 82 09 00 00 00 00 00 00 81 6c 02 03
c0: 08 00 81 00 00 00 18 00 00 00 48 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0b.0 PCI bridge: Broadcom BCM5780 [HT2000] PCI-Express Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=64
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [a0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [b0] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag- RBE-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Exit Latency L0s <4us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport
00: 66 11 32 01 06 00 10 00 a3 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 08 08 40 f1 01 00 02
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 60 00 04 00
40: 00 00 00 00 01 00 00 00 00 00 00 20 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0
60: 01 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
70: 00 00 09 87 84 34 00 00 00 00 01 00 00 00 00 00
80: 01 00 00 00 20 10 70 2b 72 0a 18 00 01 00 00 fb
90: 90 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 b0 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
b0: 10 00 41 00 82 09 00 00 00 00 00 00 41 6c 02 04
c0: 08 00 01 00 00 00 20 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0c.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] ES1000 (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] ES1000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at e000 [size=256]
	Region 2: Memory at ff6f0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at ff6c0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
00: 02 10 5e 51 87 01 90 02 02 00 00 03 10 40 00 00
10: 08 00 00 d8 01 e0 00 00 00 00 6f ff 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 5e 51
30: 00 00 6c ff 50 00 00 00 00 00 00 00 0b 01 08 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 5e 51
50: 01 00 02 06 00 00 00 00 02 50 20 00 00 02 00 2f
60: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=N/C DwFcInEn- LWO=N/C DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 200MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 05 00 04 04 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 10 00 01 00 e4 00 00 00 00 c9 0e 0f 3c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 a0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
90: 56 04 51 02 00 00 ff 00 07 00 00 00 00 00 00 00
a0: 08 c0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
b0: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
c0: 08 00 01 21 d0 00 11 77 22 00 75 80 02 00 00 00
d0: 52 14 51 02 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 7f 00 03 00 00 01 01 00 ff 01
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 80 00 00 70 ff 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 01 00 00 00 01 10 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 ee e0 07 00 ee e0 07
80: 00 50 00 00 00 00 00 00 35 33 72 13 20 0a 10 00
90: 00 8c 8a 08 08 0b 5b 3e 00 00 00 00 06 08 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: e3 41 8f d6 36 00 00 00 fc d7 3d 36 00 ee 01 de
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: fa 00 92 2d 40 c7 04 78 7b 37 8b 14 98 22 01 12
e0: 78 00 49 b1 40 77 80 12 ba 05 c7 08 1c b0 00 08
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 00 00 40 00 50 00 00 00 00 00 00 00 00 00
50: f8 ff ff 7f 00 00 00 00 00 00 00 00 c0 d6 5d 3a
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 12 51 11 80 10 50 00 38 00 08 1b 22 00 00
80: 00 00 07 23 13 21 13 00 00 00 00 00 00 00 00 00
90: 02 00 00 00 64 00 00 00 f0 03 a0 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 3e 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 07 07 e2 04 10 27 00 20 00 25 00 00
e0: 00 00 00 00 20 09 64 00 1b 01 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=N/C DwFcInEn- LWO=N/C DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 200MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=N/C DwFcInEn- LWO=N/C DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 200MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 04 04 01 00 01 01 05 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 11 00 01 00 e4 00 00 00 00 c9 0e 0f 14 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 a0 01 21 d0 00 11 77 22 00 75 80 02 00 00 00
90: 30 1c 00 04 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 c0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
b0: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
c0: 08 00 01 21 d0 00 11 77 22 00 75 80 02 00 00 00
d0: 00 76 34 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 7f 00 03 00 00 01 01 00 ff 01
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 80 00 00 70 ff 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 01 00 00 00 01 20 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 de e0 0f 00 de e0 0f
80: 00 50 00 00 00 00 00 00 35 33 72 13 20 0a 10 00
90: 00 8c 83 08 08 0b 5b 3e 00 00 00 00 06 08 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: ac 7a 2c d5 36 00 00 00 fb d0 03 38 01 9c 80 08
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 00 66 00 06 0b 81 30 00 c0 42 0c 06 00 14
e0: 91 60 00 a4 00 c2 01 00 32 20 60 85 4c 02 01 82
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 00 00 40 00 50 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 90 61 00
60: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 12 51 11 80 10 50 00 38 00 08 1b 22 00 00
80: 00 00 07 23 13 21 13 00 00 00 00 00 00 00 00 00
90: 02 00 00 00 64 00 00 00 30 00 aa 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 3f 00 00 20 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 07 07 e2 04 10 27 00 20 00 25 00 00
e0: 00 00 00 00 20 08 61 00 1b 01 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:0d.0 PCI bridge: Broadcom BCM5785 [HT1000] PCI/PCI-X Bridge (rev c0) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [90] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=conv
		Status: Dev=01:0d.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
		Upstream: Capacity=8 CommitmentLimit=8
		Downstream: Capacity=8 CommitmentLimit=8
	Capabilities: [88] Subsystem: Device cf33:2db6
00: 66 11 04 01 16 00 30 02 c0 00 04 06 10 40 01 00
10: 00 00 00 00 00 00 00 00 01 02 02 40 f1 01 20 22
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 90 00 00 00 00 00 00 00 00 00 04 02
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 c0 13 00 c0
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 04 00 00 00 00 00 00 0d 00 00 00 33 cf b6 2d
90: 07 88 03 00 68 01 03 00 08 00 08 00 08 00 08 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:0e.0 IDE interface: Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 8080 [size=8]
	Region 1: I/O ports at 8000 [size=4]
	Region 2: I/O ports at 7c00 [size=8]
	Region 3: I/O ports at 7880 [size=4]
	Region 4: I/O ports at 7800 [size=16]
	Region 5: Memory at ff1fe000 (32-bit, non-prefetchable) [size=8K]
	Expansion ROM at ff1c0000 [disabled] [size=128K]
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=8
		Status: Dev=01:0e.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
	Capabilities: [90] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Kernel driver in use: sata_svw
00: 66 11 4b 02 07 01 10 02 00 8f 01 01 00 40 80 00
10: 81 80 00 00 01 80 00 00 01 7c 00 00 81 78 00 00
20: 01 78 00 00 00 e0 1f ff 00 00 00 00 66 11 4b 02
30: 00 00 1c ff 60 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 07 90 40 00 70 01 03 0a 00 00 00 00 00 00 00 00
70: 28 00 00 00 00 00 00 00 84 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 01 a0 02 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:0e.1 IDE interface: Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 8c00 [size=8]
	Region 1: I/O ports at 8880 [size=4]
	Region 2: I/O ports at 8800 [size=8]
	Region 3: I/O ports at 8480 [size=4]
	Region 4: I/O ports at 8400 [size=16]
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=8
		Status: Dev=01:0e.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
	Capabilities: [90] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
00: 66 11 4b 02 07 01 30 02 00 8f 01 01 00 40 80 00
10: 01 8c 00 00 81 88 00 00 01 88 00 00 81 84 00 00
20: 01 84 00 00 00 00 00 00 00 00 00 00 66 11 4b 02
30: 00 00 00 00 60 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 07 90 40 00 70 01 03 0a 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 01 a0 02 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet (rev 03)
	Subsystem: Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (16000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 64
	Region 0: Memory at ff2d0000 (64-bit, non-prefetchable) [size=64K]
	Region 2: Memory at ff2c0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=1
		Status: Dev=04:04.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
		Read-only fields:
			[PN] Part number: BCM95780
			[EC] Engineering changes: 106679-15
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum bad, 28 byte(s) reserved
		Read/write fields:
			[YA] Asset tag: XYZ01234567
			[RW] Read-write area: 107 byte(s) free
		End
	Capabilities: [58] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4161
	Kernel driver in use: tg3
00: e4 14 6a 16 06 01 b0 02 03 00 00 02 10 40 80 00
10: 04 00 2d ff 00 00 00 00 04 00 2c ff 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 e4 14 6a 16
30: 00 00 94 01 40 00 00 00 00 00 00 00 05 01 40 00
40: 07 48 00 00 20 04 43 04 01 50 02 c0 00 21 00 64
50: 03 58 fc 80 00 00 00 78 05 00 87 00 0c 10 e0 fe
60: 00 00 00 00 61 41 00 00 98 02 03 80 00 40 14 76
70: ea 10 00 00 c7 00 00 80 00 00 00 00 00 00 00 00
80: e4 14 6a 16 0e 00 00 40 34 00 13 04 82 50 08 04
90: 09 ba 00 01 00 00 00 e6 00 00 00 00 76 00 00 00
a0: 00 00 00 00 ae 01 00 00 00 00 00 00 a2 01 00 00
b0: 00 00 00 00 00 00 00 97 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet (rev 03)
	Subsystem: Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (16000ns min), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 27
	Region 0: Memory at ff2f0000 (64-bit, non-prefetchable) [size=64K]
	Region 2: Memory at ff2e0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=1
		Status: Dev=04:04.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
		Read-only fields:
			[PN] Part number: BCM95780
			[EC] Engineering changes: 106679-15
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum bad, 28 byte(s) reserved
		Read/write fields:
			[YA] Asset tag: XYZ01234567
			[RW] Read-write area: 107 byte(s) free
		End
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 180e811b201ebbc4  Data: 85c0
	Kernel driver in use: tg3
00: e4 14 6a 16 06 01 b0 02 03 00 00 02 10 40 80 00
10: 04 00 2f ff 00 00 00 00 04 00 2e ff 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 e4 14 6a 16
30: 00 00 00 00 40 00 00 00 00 00 00 00 09 02 40 00
40: 07 48 02 00 21 04 43 04 01 50 02 c0 00 20 00 64
50: 03 58 fc 80 00 00 00 78 05 00 86 00 c4 bb 1e 20
60: 1b 81 0e 18 c0 85 00 00 9a 02 03 80 00 40 14 76
70: 8a 12 00 00 c7 00 00 00 00 00 00 00 00 00 00 00
80: e4 14 6a 16 d7 6b c5 3f 34 00 00 00 fe 50 08 04
90: 01 ba 00 09 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

07:00.0 Fibre Channel: LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter (rev 01)
	Subsystem: LSI Logic / Symbios Logic Device 5010
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: I/O ports at b000 [size=256]
	Region 1: Memory at ff5fc000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at ff5e0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at ff400000 [disabled] [size=1M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [98] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
		Vector table: BAR=1 offset=00002000
		PBA: BAR=1 offset=00003000
00: 00 10 46 06 07 01 10 40 01 00 04 0c 10 00 00 00
10: 01 b0 00 00 04 c0 5f ff 00 00 00 00 04 00 5e ff
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 10 50
30: 00 00 40 ff 50 00 00 00 00 00 00 00 03 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 68 02 06 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 07 00 00 10 98 01 00 25 00 00 00
70: 10 28 0a 00 81 0c 00 00 00 00 81 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 05 b0 80 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 00 00 00 01 20 00 00 01 30 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

