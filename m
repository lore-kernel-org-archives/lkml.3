Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaBHOrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 09:47:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56635 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751378AbaBHOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 09:47:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Sat, 08 Feb 2014 16:01:36 +0100
Message-ID: <6111963.dPYocWnfhd@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <8389318.FWd8nDZBjU@al>
References: <52F2CC7B.80406@gmail.com> <2082735.jaKtCS1gqS@vostro.rjw.lan> <8389318.FWd8nDZBjU@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 02:43:03 PM Peter Wu wrote:
> On Friday 07 February 2014 00:48:14 Rafael J. Wysocki wrote:
> > On Friday, February 07, 2014 12:27:03 AM you wrote:
> > [...]
> > 
> > > [   49.170694] video LNXVIDEO:01: Restoring backlight state
> > > [   49.644845] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> > > [   49.646671] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> > > [   49.671645] jme 0000:04:00.5 eth0: Link is down
> > 
> > Well, this means that Ethernet device is present after the resume.
> 
> Right, but it is gone when I check it (lspci). Here is the original
> journal with dates and machine name stripped from the left (2 seconds):

[...]

> --- lspci-nnvvv.txt     2014-02-06 17:11:02.867233563 +0100
> +++ lspci-nnvvv2.txt    2014-02-06 17:11:22.603425311 +0100
> @@ -86,17 +86,17 @@
>  00:1c.1 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 [8086:3b44] (rev 05) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: fd400000-fd4fffff
>         Prefetchable memory behind bridge: 00000000c0000000-00000000c01fffff
> -       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> +       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
>  
>  00:1c.2 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 [8086:3b46] (rev 05) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> @@ -200,60 +200,16 @@
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at fc000000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: <access denied>
>         Kernel driver in use: xhci_hcd
>         Kernel modules: xhci_hcd
>  
> -04:00.0 System peripheral [0880]: JMicron Technology Corp. SD/MMC Host Controller [197b:2382] (rev 80)
> -       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
> -       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> -       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> -       Latency: 0, Cache Line Size: 64 bytes
> -       Interrupt: pin B routed to IRQ 18
> -       Region 0: Memory at fd404000 (32-bit, non-prefetchable) [size=256]
> -       Capabilities: <access denied>
> -       Kernel driver in use: sdhci-pci
> -       Kernel modules: sdhci_pci
> -
> -04:00.2 SD Host controller [0805]: JMicron Technology Corp. Standard SD Host Controller [197b:2381] (rev 80) (prog-if 01)
> -       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
> -       Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> -       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> -       Interrupt: pin B routed to IRQ 18
> -       Region 0: Memory at fd405000 (32-bit, non-prefetchable) [size=256]
> -       Capabilities: <access denied>
> -       Kernel modules: sdhci_pci
> -
> -04:00.3 System peripheral [0880]: JMicron Technology Corp. MS Host Controller [197b:2383] (rev 80)
> -       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
> -       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> -       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> -       Latency: 0, Cache Line Size: 64 bytes
> -       Interrupt: pin C routed to IRQ 19
> -       Region 0: Memory at fd406000 (32-bit, non-prefetchable) [size=256]
> -       Capabilities: <access denied>
> -       Kernel driver in use: jmb38x_ms
> -       Kernel modules: jmb38x_ms
> -
> -04:00.5 Ethernet controller [0200]: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller [197b:0250] (rev 03)
> -       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
> -       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> -       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> -       Latency: 0, Cache Line Size: 64 bytes
> -       Interrupt: pin B routed to IRQ 50
> -       Region 0: Memory at fd400000 (32-bit, non-prefetchable) [size=16K]
> -       Region 2: I/O ports at 4400 [size=128]
> -       Region 3: I/O ports at 4000 [size=256]
> -       Capabilities: <access denied>
> -       Kernel driver in use: jme
> -       Kernel modules: jme
> -
>  05:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6200 [8086:422c] (rev 35)
>         Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN [8086:1301]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 49
>         Region 0: Memory at fd500000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: <access denied>
> 
> 
> I forgot to mention a workaround, by triggering a rescan, the
> devices become alive again. Here is a log from 3.12.7 (different
> from the above):
> 
>     sudo tee /sys/devices/pci0000:00/0000:00:1c.1/rescan <<<1
> 
> The journal following the above command (duration of 2 seconds):

OK

It looks like we fail to resume the device, then, for some reason.

That may be a PCIe link issue or something similar.

Is this a regression for you?  If so, what's the last kernel that didn't
have this problem?  Does 3.13.y (as released by Greg, without and distro
"improvements") have it too?

Rafael

