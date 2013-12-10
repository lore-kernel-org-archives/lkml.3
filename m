Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3LJSw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:52:56 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:34925 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3LJSwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:52:54 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-mmc@vger.kernel.org
Subject: Toshiba TC6371AF PCI SD card controller (SD TypA) driver
Date: Tue, 10 Dec 2013 19:52:04 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2482
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312101952.05713.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a nice small Toshiba Portege R100 laptop with this unsupported SD card
controller:

02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA Controller [1179:0805] (rev 05)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 255
        Region 0: Memory at dfd01000 (32-bit, non-prefetchable) [disabled] [size=512]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+


Richard Betts posted a non-working driver for this chip at:
http://osdir.com/ml/linux.drivers.sdhci.devel/2008-07/msg00002.html

I've installed old Debian (etch) and compiled the toshsd driver with old 
kernel 2.6.20 - and it really does not work - as promised :)

The comments are useful - seems that the chip internals are same as in ASIC3, 
now supported by tmio_mmc driver. But it's a MFD, not a PCI driver. I wonder 
how hard would be to modify tmio_mmc driver to use with a new "glue" PCI 
driver for this chip.

The registers in toshsd.h seem to match TC6371AF chip - datasheet is available 
e.g. at:
http://www.alldatasheet.com/datasheet-pdf/pdf/169239/TOSHIBA/TC6371AF.html
Only the PCI ID is a bit different (0x0805 instead of 0x0803).

More registers are described in TC6380AF datasheet, although it's not a PCI 
device:
http://www.datasheetarchive.com/dl/Datasheet-029/DSA00512912.pdf

-- 
Ondrej Zary
