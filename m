Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab3FNCMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:12:25 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:56035 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3FNCMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
Date: Fri, 14 Jun 2013 08:06:46 +0600
Message-ID: <CAN_LGv2HxTB_8Oo8CB2mgKKL2n-P7b7a3NySTL7zhGpDE9-PkQ@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/14 Yinghai Lu <yinghai@kernel.org>:
> the 3) is about pci resource allocation?
> because pcibios_add_bus is called too early?

(3) is https://bugzilla.kernel.org/show_bug.cgi?id=56531

> If that is case, we should have something like attached patch for it.

It does not even compile because the argument of pci_bus_add_devices()
points to a const struct. You can't increment a member of it. And even
if you remove the const from both the declaration and the definition
of that function, the patch doesn't help at all.

Here is /proc/ioports with the fixed-up patch:

0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00e1-00e1 : #ENUM hotswap signal register
  00f0-00ff : fpu
  03c0-03df : vga+
  0400-0453 : pnp 00:04
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:06
  0458-047f : pnp 00:04
    0460-047f : iTCO_wdt
  0500-057f : pnp 00:04
  0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-100f : pnp 00:04
  164e-164f : pnp 00:04
  2000-2000 : pnp 00:04
  2004-2004 : pnp 00:04
  3000-5fff : PCI Bus 0000:08
  6000-6fff : PCI Bus 0000:05
    6000-60ff : 0000:05:00.0
      6000-60ff : r8169
  7000-7fff : PCI Bus 0000:04
  8000-8fff : PCI Bus 0000:03
  9000-9fff : PCI Bus 0000:02
  a000-a03f : 0000:00:02.0
  a040-a05f : 0000:00:1f.3
  a060-a07f : 0000:00:1f.2
    a060-a07f : ahci
  a080-a087 : 0000:00:1f.2
    a080-a087 : ahci
  a088-a08f : 0000:00:1f.2
    a088-a08f : ahci
  a090-a093 : 0000:00:1f.2
    a090-a093 : ahci
  a094-a097 : 0000:00:1f.2
    a094-a097 : ahci
  ffff-ffff : pnp 00:04
    ffff-ffff : pnp 00:04

And /proc/iomem:

00000000-00000fff : reserved
00001000-0008f3ff : System RAM
0008f400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cffff : Video ROM
000d0000-000da3ff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-9ae3efff : System RAM
  01000000-0166bfff : Kernel code
  0166c000-01cbca3f : Kernel data
  01dba000-026b8fff : Kernel bss
9ae3f000-9aebefff : reserved
9aebf000-9afbefff : ACPI Non-volatile Storage
9afbf000-9affefff : ACPI Tables
9afff000-9affffff : System RAM
9b000000-9f9fffff : reserved
9fa00000-feafffff : PCI Bus 0000:00
  9fa00000-9fa00fff : pnp 00:09
  a0000000-afffffff : 0000:00:02.0
  b0000000-cfffffff : PCI Bus 0000:08
    b0000000-c06fffff : PCI Bus 0000:0a
      b0000000-b01fffff : PCI Bus 0000:0b
      b0200000-b03fffff : PCI Bus 0000:0b
      b0400000-b05fffff : PCI Bus 0000:0c
      b0600000-b07fffff : PCI Bus 0000:0c
  d0000000-d03fffff : 0000:00:02.0
  d0400000-d13fffff : PCI Bus 0000:02
  d1400000-d23fffff : PCI Bus 0000:03
  d2400000-d33fffff : PCI Bus 0000:04
  d3400000-d43fffff : PCI Bus 0000:05
    d3400000-d3403fff : 0000:05:00.0
      d3400000-d3403fff : r8169
    d3404000-d3404fff : 0000:05:00.0
      d3404000-d3404fff : r8169
  d4400000-d53fffff : PCI Bus 0000:08
  d5400000-d63fffff : PCI Bus 0000:05
  d6400000-d73fffff : PCI Bus 0000:04
    d6400000-d6401fff : 0000:04:00.0
      d6400000-d6401fff : xhci_hcd
  d7400000-d83fffff : PCI Bus 0000:03
    d7400000-d7400fff : 0000:03:00.0
      d7400000-d7400fff : rtsx_pci
  d8400000-d93fffff : PCI Bus 0000:02
    d8400000-d8401fff : 0000:02:00.0
      d8400000-d8401fff : iwlwifi
  d9400000-d9403fff : 0000:00:1b.0
    d9400000-d9403fff : ICH HD audio
  d9404000-d940400f : 0000:00:16.0
    d9404000-d940400f : mei_me
  d9405000-d94050ff : 0000:00:1f.3
  d9407000-d94077ff : 0000:00:1f.2
    d9407000-d94077ff : ahci
  d9408000-d94083ff : 0000:00:1d.0
    d9408000-d94083ff : ehci_hcd
  d9409000-d94093ff : 0000:00:1a.0
    d9409000-d94093ff : ehci_hcd
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:09
feb00000-feb03fff : reserved
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:09
  fed18000-fed18fff : pnp 00:09
  fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:09
    fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffd80000-ffffffff : reserved
100000000-25fdfffff : System RAM
25fe00000-25fffffff : RAM buffer

You can compare them with other files from
https://bugzilla.kernel.org/show_bug.cgi?id=56531

--
Alexander E. Patrakov
