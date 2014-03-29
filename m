Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaC2Rkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:40:55 -0400
Received: from exsmtp03.agrinet.ch ([81.221.254.202]:44058 "EHLO
	exsmtp03.agrinet.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2Rkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:40:53 -0400
X-IMP-FROM: _________<joel@weedlight.ch>
X-IMP-AUTH_USERNAME: <joel@weedlight.ch>
X-Original-IP: 178.192.189.9
Message-ID: <1396114850.4053.8.camel@debian>
Subject: Re: vmlinuz-3.12.13-rt21 freezed by application
From: =?ISO-8859-1?Q?Jo=EBl_Kr=E4hemann?= <joel@weedlight.ch>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sat, 29 Mar 2014 18:40:50 +0100
In-Reply-To: <1396109648.3443.15.camel@debian>
References: <1396109648.3443.15.camel@debian>
Content-Type: multipart/mixed; boundary="=-XUbS9ElkMYHm+/6PuTry"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XUbS9ElkMYHm+/6PuTry
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Same effect with vmlinuz-3.12.14-rt23 even with WindowMaker.

The fan turns on on no reaction of the OS without any special realtime
privileges. The threads run at priority 0 and can't switch to TTY[0-6].

It's a recent mac book pro output of `lspci -v` attached.

I have programmed a thread wrapper AgsThread with glib-object using
pthreads. I'm syncing a tree and having a thread pool which adds threads
to the tree at runtime.

Finally my question, what is the state of realtime kernel thread safety?
My application runs more or less stable with default debian kernel
configuration. But getting real bad performance.


On Sat, 2014-03-29 at 17:14 +0100, Jo=EBl Kr=E4hemann wrote:
> Hi, my application freezed recent kernel:
>=20
> vmlinuz-3.12.13-rt21
>=20
> http://sourceforge.net/p/ags/blog/2014/03/warning-freezed-gnulinux/
>=20
>=20
> Now I'm compiling vmlinuz-3.12.14-rt23 but as fully tickles
>=20
>=20


--=-XUbS9ElkMYHm+/6PuTry
Content-Disposition: attachment; filename="lspci.txt"
Content-Type: text/plain; name="lspci.txt"; charset="us-ascii"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
	Subsystem: Apple Inc. Device 00f7
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c0000000-c10fffff
	Prefetchable memory behind bridge: 0000000090000000-00000000a1ffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:01.1 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=6b, sec-latency=0
	I/O behind bridge: 00004000-00006fff
	Memory behind bridge: c1d00000-ce0fffff
	Prefetchable memory behind bridge: 00000000ce100000-00000000da1fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:01.2 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: c1b00000-c1bfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 51
	Memory at c1c00000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, fast devsel, latency 0, IRQ 53
	Memory at c1c17100 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>
	Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at c1c16c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, fast devsel, latency 0, IRQ 54
	Memory at c1c10000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: c1a00000-c1afffff
	Prefetchable memory behind bridge: 00000000c1800000-00000000c18fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: c1900000-c19fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 22
	Memory at c1c16800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 52
	I/O ports at 3088 [size=8]
	I/O ports at 309c [size=4]
	I/O ports at 3080 [size=8]
	I/O ports at 3098 [size=4]
	I/O ports at 3060 [size=32]
	Memory at c1c16000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
	Subsystem: Intel Corporation Device 7270
	Flags: medium devsel, IRQ 18
	Memory at c1c17000 (64-bit, non-prefetchable) [size=256]
	I/O ports at efa0 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation GK107M [GeForce GT 650M Mac Edition] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Apple Inc. Device 00f2
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at c0000000 (32-bit, non-prefetchable) [size=16M]
	Memory at 90000000 (64-bit, prefetchable) [size=256M]
	Memory at a0000000 (64-bit, prefetchable) [size=32M]
	I/O ports at 2000 [size=128]
	Expansion ROM at c1000000 [disabled] [size=512K]
	Capabilities: <access denied>
	Kernel driver in use: nouveau

01:00.1 Audio device: NVIDIA Corporation GK107 HDMI Audio Controller (rev a1)
	Subsystem: Apple Inc. Device 00f2
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at c1080000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

03:00.0 Ethernet controller: Broadcom Corporation Device 16a3 (rev 10)
	Subsystem: Broadcom Corporation Device 16b4
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at c1800000 (64-bit, prefetchable) [size=64K]
	Memory at c1810000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at c1830000 [disabled] [size=2K]
	Capabilities: <access denied>

03:00.1 SD Host controller: Broadcom Corporation BCM57765/57785 SDXC/MMC Card Reader (rev 10) (prog-if 01)
	Subsystem: Broadcom Corporation Device 96bc
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at c1820000 (64-bit, prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci

04:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)
	Subsystem: Apple Inc. AirPort Extreme
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at c1900000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: bcma-pci-bridge

05:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=05, secondary=06, subordinate=6b, sec-latency=0
	I/O behind bridge: 00004000-00005fff
	Memory behind bridge: c1d00000-ca0fffff
	Prefetchable memory behind bridge: 00000000ce100000-00000000d61fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

06:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=06, secondary=07, subordinate=07, sec-latency=0
	Memory behind bridge: c1f00000-c1ffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

06:03.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 2
	Flags: bus master, fast devsel, latency 0
	Bus: primary=06, secondary=08, subordinate=38, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: c2000000-c60fffff
	Prefetchable memory behind bridge: 00000000ce100000-00000000d21fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

06:04.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 3
	Flags: bus master, fast devsel, latency 0
	Bus: primary=06, secondary=39, subordinate=69, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: c6100000-ca0fffff
	Prefetchable memory behind bridge: 00000000d2200000-00000000d61fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

06:05.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 4
	Flags: bus master, fast devsel, latency 0
	Bus: primary=06, secondary=6a, subordinate=6a, sec-latency=0
	Memory behind bridge: c1e00000-c1efffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

06:06.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 5
	Flags: bus master, fast devsel, latency 0
	Bus: primary=06, secondary=6b, subordinate=6b, sec-latency=0
	Memory behind bridge: c1d00000-c1dfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

07:00.0 System peripheral: Intel Corporation DSL3510 Thunderbolt Port [Cactus Ridge] (rev 03)
	Subsystem: Device 2222:1111
	Physical Slot: 1
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at c1f00000 (32-bit, non-prefetchable) [size=256K]
	Memory at c1f40000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

08:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] (prog-if 00 [Normal decode])
	Physical Slot: 3-1
	Flags: bus master, fast devsel, latency 0
	Bus: primary=08, secondary=09, subordinate=0a, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: c2000000-c20fffff
	Prefetchable memory behind bridge: 00000000ce100000-00000000ce1fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

09:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Controller [Cactus Ridge] (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=09, secondary=0a, subordinate=0a, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: c2000000-c20fffff
	Prefetchable memory behind bridge: 00000000ce100000-00000000ce1fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

0a:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe
	Subsystem: Apple Inc. Device 00f6
	Physical Slot: 9
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at ce100000 (64-bit, prefetchable) [size=64K]
	Memory at ce110000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at ce120000 [disabled] [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: tg3

--=-XUbS9ElkMYHm+/6PuTry--

