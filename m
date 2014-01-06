Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaAFMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:34:35 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:59183 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaAFMed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:34:33 -0500
Message-ID: <52CAA2D4.2040103@compulab.co.il>
Date: Mon, 06 Jan 2014 14:34:28 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Oliver Neukum <oneukum@suse.de>,
        dashing.meng@gmail.com, Niklas Schnelle <niklas@komani.de>,
        Giorgos <ganastasiouGR@gmail.com>, art1@vhex.net
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos> <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos> <52B69925.8030409@compulab.co.il> <20140103000334.GE9621@xanatos>
In-Reply-To: <20140103000334.GE9621@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

On 01/03/2014 02:03 AM, Sarah Sharp wrote:
> Denis, do all of Compulab's Haswell systems reboot on shutdown?  Are
> they all running a Phoenix BIOS?  Can you send me the output of `sudo
> lspci -vvv -s` for the xHCI host?

oem@oem-Intense-PC2 ~ $ sudo lspci -vvv -s 00:14.0
00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev 04) (prog-if 30 [XHCI])
	Subsystem: Intel Corporation Device 7270
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 59
	Region 0: Memory at f0620000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee0200c  Data: 41b1
	Kernel driver in use: xhci_hcd

> Basically, I'm trying to find a common variable to key off.  I suspect
> BIOS vendor is probably the right thing, instead of system vendor.

By the way the quirk introduced by commit e95829f474f0db3a4d940cae1423783edd966027 "xhci: Switch PPT
ports to EHCI on shutdown." works for Lynx Point as well at least on Intense-PC2. I mean we can add
XHCI_SPURIOUS_REBOOT flag that invokes usb_disable_xhci_ports().

May be this solution works for HP and other systems without side effects?

Denis
