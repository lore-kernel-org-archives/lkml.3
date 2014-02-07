Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBGNnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:43:13 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55561 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaBGNnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:43:10 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Fri, 07 Feb 2014 14:43:03 +0100
Message-ID: <8389318.FWd8nDZBjU@al>
User-Agent: KMail/4.12.2 (Linux/3.13.1-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <2082735.jaKtCS1gqS@vostro.rjw.lan>
References: <52F2CC7B.80406@gmail.com> <1396879.yH0LySDBlU@al> <2082735.jaKtCS1gqS@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 00:48:14 Rafael J. Wysocki wrote:
> On Friday, February 07, 2014 12:27:03 AM you wrote:
> [...]
> 
> > [   49.170694] video LNXVIDEO:01: Restoring backlight state
> > [   49.644845] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> > [   49.646671] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> > [   49.671645] jme 0000:04:00.5 eth0: Link is down
> 
> Well, this means that Ethernet device is present after the resume.

Right, but it is gone when I check it (lspci). Here is the original
journal with dates and machine name stripped from the left (2 seconds):

systemd[1]: Stopping Sleep.
systemd[1]: Stopped target Sleep.
systemd[1]: Starting Suspend.
systemd[1]: Reached target Suspend.
systemd-logind[284]: Operation finished.
NetworkManager[276]: <info> wake requested (sleeping: yes  enabled: yes)
NetworkManager[276]: <info> waking up and re-enabling...
NetworkManager[276]: <info> WWAN now enabled by management service
NetworkManager[276]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
NetworkManager[276]: <info> (eth0): bringing up device.
kernel: ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
kernel: jme 0000:04:00.5: irq 50 for MSI/MSI-X
dbus[285]: [system] Successfully activated service 'org.freedesktop.UPower'
systemd[1]: Started Daemon for power management.
NetworkManager[276]: <info> (eth0): preparing device.
NetworkManager[276]: <info> (eth0): deactivating device (reason 'managed') [2]
NetworkManager[276]: <info> NetworkManager state is now DISCONNECTED
NetworkManager[276]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
NetworkManager[276]: <info> (wlan0): bringing up device.
kernel: jme 0000:04:00.5 eth0: Link is down
kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
kernel: iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
kernel: iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
NetworkManager[276]: <info> (wlan0): preparing device.
NetworkManager[276]: <info> (wlan0): deactivating device (reason 'managed') [2]
kernel: IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
NetworkManager[276]: <info> (wlan0) supports 5 scan SSIDs
NetworkManager[276]: <info> (wlan0): supplicant interface state: starting -> ready
NetworkManager[276]: <info> (wlan0): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
NetworkManager[276]: <warn> Trying to remove a non-existant call id.
NetworkManager[276]: <info> (wlan0): supplicant interface state: ready -> disconnected
NetworkManager[276]: <info> (wlan0) supports 5 scan SSIDs
kernel: xhci_hcd 0000:02:00.0: no hotplug settings from platform
kernel: iwlwifi 0000:05:00.0: no hotplug settings from platform
NetworkManager[276]: <info> (eth0): device state change: unavailable -> unmanaged (reason 'removed') [20 10 36]
NetworkManager[276]: <info> (eth0): cleaning up...
NetworkManager[276]: <warn> (2) failed to find interface name for index
NetworkManager[276]: (nm-system.c:766):nm_system_iface_get_flags: runtime check failed: (iface != NULL)
NetworkManager[276]: <error> [1391703079.229919] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to get interface link object

> > [   49.671717] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [   49.674119] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
> > [   49.681037] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
> > [   49.778035] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > [   49.806241] xhci_hcd 0000:02:00.0: no hotplug settings from platform
> > [   49.859417] iwlwifi 0000:05:00.0: no hotplug settings from platform
> > [   56.264694] wlan0: authenticate with [STRIPPED]
> > [   56.277969] wlan0: send auth to [STRIPPED] (try 1/3)
> > [   56.282076] wlan0: authenticated
> > [   56.283879] wlan0: associate with [STRIPPED] (try 1/3)
> > [   56.297196] wlan0: RX AssocResp from [STRIPPED] (capab=0x411 status=0
> > aid=6) [   56.303746] wlan0: associated
> > [   56.303826] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> 
> Can you check the lspci differences between before/after the suspend-resume
> cycle?

See below. The MAbort+ looks suspicious. 00:1c.1 is the parent of the
devices on bus 4.

(`lspci -nnvt` differences:)

-             +-1c.1-[04]--+-00.0  JMicron Technology Corp. SD/MMC Host Controller [197b:2382]
-             |            +-00.2  JMicron Technology Corp. Standard SD Host Controller [197b:2381]
-             |            +-00.3  JMicron Technology Corp. MS Host Controller [197b:2383]
-             |            \-00.5  JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller [197b:0250]
+             +-1c.1-[04]--


--- lspci-nnvvv.txt     2014-02-06 17:11:02.867233563 +0100
+++ lspci-nnvvv2.txt    2014-02-06 17:11:22.603425311 +0100
@@ -86,17 +86,17 @@
 00:1c.1 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 [8086:3b44] (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: fd400000-fd4fffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000c01fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel driver in use: pcieport
        Kernel modules: shpchp
 
 00:1c.2 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 [8086:3b46] (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
@@ -200,60 +200,16 @@
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc000000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_hcd
 
-04:00.0 System peripheral [0880]: JMicron Technology Corp. SD/MMC Host Controller [197b:2382] (rev 80)
-       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
-       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 64 bytes
-       Interrupt: pin B routed to IRQ 18
-       Region 0: Memory at fd404000 (32-bit, non-prefetchable) [size=256]
-       Capabilities: <access denied>
-       Kernel driver in use: sdhci-pci
-       Kernel modules: sdhci_pci
-
-04:00.2 SD Host controller [0805]: JMicron Technology Corp. Standard SD Host Controller [197b:2381] (rev 80) (prog-if 01)
-       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
-       Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Interrupt: pin B routed to IRQ 18
-       Region 0: Memory at fd405000 (32-bit, non-prefetchable) [size=256]
-       Capabilities: <access denied>
-       Kernel modules: sdhci_pci
-
-04:00.3 System peripheral [0880]: JMicron Technology Corp. MS Host Controller [197b:2383] (rev 80)
-       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
-       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 64 bytes
-       Interrupt: pin C routed to IRQ 19
-       Region 0: Memory at fd406000 (32-bit, non-prefetchable) [size=256]
-       Capabilities: <access denied>
-       Kernel driver in use: jmb38x_ms
-       Kernel modules: jmb38x_ms
-
-04:00.5 Ethernet controller [0200]: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller [197b:0250] (rev 03)
-       Subsystem: CLEVO/KAPOK Computer Device [1558:7130]
-       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-       Latency: 0, Cache Line Size: 64 bytes
-       Interrupt: pin B routed to IRQ 50
-       Region 0: Memory at fd400000 (32-bit, non-prefetchable) [size=16K]
-       Region 2: I/O ports at 4400 [size=128]
-       Region 3: I/O ports at 4000 [size=256]
-       Capabilities: <access denied>
-       Kernel driver in use: jme
-       Kernel modules: jme
-
 05:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6200 [8086:422c] (rev 35)
        Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN [8086:1301]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 49
        Region 0: Memory at fd500000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>


I forgot to mention a workaround, by triggering a rescan, the
devices become alive again. Here is a log from 3.12.7 (different
from the above):

    sudo tee /sys/devices/pci0000:00/0000:00:1c.1/rescan <<<1

The journal following the above command (duration of 2 seconds):

kernel: pci 0000:04:00.0: [197b:2382] type 00 class 0x088000
kernel: pci 0000:04:00.0: reg 0x10: [mem 0x00000000-0x000000ff]
kernel: pci 0000:04:00.2: [197b:2381] type 00 class 0x080501
kernel: pci 0000:04:00.2: reg 0x10: [mem 0x00000000-0x000000ff]
kernel: pci 0000:04:00.3: [197b:2383] type 00 class 0x088000
kernel: pci 0000:04:00.3: reg 0x10: [mem 0x00000000-0x000000ff]
kernel: pci 0000:04:00.5: [197b:0250] type 00 class 0x020000
kernel: pci 0000:04:00.5: reg 0x10: [mem 0x00000000-0x00003fff]
kernel: pci 0000:04:00.5: reg 0x18: [io  0x0000-0x007f]
kernel: pci 0000:04:00.5: reg 0x1c: [io  0x0000-0x00ff]
kernel: pci 0000:04:00.5: PME# supported from D0 D3hot D3cold
sudo[11341]: pam_unix(sudo:session): session closed for user root
kernel: i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
kernel: pci 0000:04:00.5: BAR 0: assigned [mem 0xfd400000-0xfd403fff]
kernel: pci 0000:04:00.0: BAR 0: assigned [mem 0xfd404000-0xfd4040ff]
kernel: pci 0000:04:00.2: BAR 0: assigned [mem 0xfd404100-0xfd4041ff]
kernel: pci 0000:04:00.3: BAR 0: assigned [mem 0xfd404200-0xfd4042ff]
kernel: pci 0000:04:00.5: BAR 3: assigned [io  0x4000-0x40ff]
kernel: pci 0000:04:00.5: BAR 2: assigned [io  0x4400-0x447f]
kernel: pci 0000:00:1e.0: PCI bridge to [bus 06]
kernel: sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 80)
kernel: sdhci-pci 0000:04:00.0: enabling device (0000 -> 0002)
kernel: mmc0: SDHCI controller on PCI [0000:04:00.0] using ADMA
kernel: sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 80)
kernel: sdhci-pci 0000:04:00.2: enabling device (0000 -> 0002)
kernel: sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
kernel: jmb38x_ms 0000:04:00.3: enabling device (0000 -> 0002)
kernel: jme 0000:04:00.5: can't disable ASPM; OS doesn't have ASPM control
kernel: jme 0000:04:00.5: enabling device (0000 -> 0003)
kernel: jme 0000:04:00.5 eth0: JMC250 Gigabit Ethernet chiprev:23 pcirev:3 macaddr:[STRIPPED]
NetworkManager[326]: <warn> failed to allocate link cache: (-26) Protocol mismatch
NetworkManager[326]: <info> (eth0): carrier is OFF
NetworkManager[326]: <info> (eth0): new Ethernet device (driver: 'jme' ifindex: 9)
NetworkManager[326]: <info> (eth0): exported as /org/freedesktop/NetworkManager/Devices/6
NetworkManager[326]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
NetworkManager[326]: <info> (eth0): bringing up device.
kernel: jme 0000:04:00.5: irq 51 for MSI/MSI-X
kernel: jme 0000:04:00.5 eth0: Link is down
kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
NetworkManager[326]: <info> (eth0): preparing device.
NetworkManager[326]: <info> (eth0): deactivating device (reason 'managed') [2]

Not sure what the integrated graphics device at 00:02.0 shows up here,
but ok. This trace is shown every time the rescan is triggered (manually)
after resume.

Some times, the "enabling device" lines are not shown, and the messages
start with the following instead:

kernel: pci 0000:04:00.0: [197b:2382] type 00 class 0x088000
kernel: pci 0000:04:00.0: reg 0x10: [mem 0xfd404000-0xfd4040ff]
kernel: pci 0000:04:00.2: [197b:2381] type 00 class 0x080501
kernel: pci 0000:04:00.2: reg 0x10: [mem 0xfd404100-0xfd4041ff]
kernel: pci 0000:04:00.3: [197b:2383] type 00 class 0x088000
kernel: pci 0000:04:00.3: reg 0x10: [mem 0xfd404200-0xfd4042ff]
kernel: pci 0000:04:00.5: [197b:0250] type 00 class 0x020000
kernel: pci 0000:04:00.5: reg 0x10: [mem 0xfd400000-0xfd403fff]
kernel: pci 0000:04:00.5: reg 0x18: [io  0x4400-0x447f]
kernel: pci 0000:04:00.5: reg 0x1c: [io  0x4000-0x40ff]

I do not know if it is relevant, but this is taken from the logs where the
OS is booting:

kernel: pci 0000:04:00.0: [197b:2382] type 00 class 0x088000
kernel: pci 0000:04:00.0: reg 0x10: [mem 0xfd404000-0xfd4040ff]
kernel: pci 0000:04:00.2: [197b:2381] type 00 class 0x080501
kernel: pci 0000:04:00.2: reg 0x10: [mem 0xfd405000-0xfd4050ff]
kernel: pci 0000:04:00.3: [197b:2383] type 00 class 0x088000
kernel: pci 0000:04:00.3: reg 0x10: [mem 0xfd406000-0xfd4060ff]
kernel: pci 0000:04:00.5: [197b:0250] type 00 class 0x020000
kernel: pci 0000:04:00.5: reg 0x10: [mem 0xfd400000-0xfd403fff]
kernel: pci 0000:04:00.5: reg 0x18: [io  0x4400-0x447f]
kernel: pci 0000:04:00.5: reg 0x1c: [io  0x4000-0x40ff]
kernel: pci 0000:04:00.5: PME# supported from D0 D3hot D3cold
kernel: pci 0000:00:1c.1: PCI bridge to [bus 04]
kernel: pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
kernel: pci 0000:00:1c.1:   bridge window [mem 0xfd400000-0xfd4fffff]

Peter

