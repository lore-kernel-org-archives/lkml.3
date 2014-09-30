Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaI3RBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:01:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43621 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaI3RBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:01:05 -0400
Date: Tue, 30 Sep 2014 18:01:01 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH v9 0/4] APM X-Gene PCIe host controller
Message-ID: <20140930170101.GW841@e106497-lin.cambridge.arm.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
 <CACVXFVNEFSMjA=h_pyNF1AyYX4C336iM9nkYY=ocGQxjGpDCJA@mail.gmail.com>
 <CACoXjc=eA0nnK2_dRxktFeSKsfV6fQr=mDfN09sbe34H4GADrA@mail.gmail.com>
 <CACVXFVMWTeOnVMp2SCzjhPEc1M=zTLg4O8yFhv_jDPYn_6DfeQ@mail.gmail.com>
 <20140930165353.GC5625@google.com>
MIME-Version: 1.0
In-Reply-To: <20140930165353.GC5625@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 30 Sep 2014 17:01:02.0453 (UTC) FILETIME=[1D933A50:01CFDCD0]
X-MC-Unique: 114093018010300301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 05:53:53PM +0100, Bjorn Helgaas wrote:
> On Mon, Sep 22, 2014 at 09:23:51AM +0800, Ming Lei wrote:
> > Hi Tanmay,
> > 
> > On Sat, Sep 20, 2014 at 1:15 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > > Hi Ming Lei,
> > >
> > > On Thu, Sep 18, 2014 at 8:08 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> > >> Hi Tanmay,
> > >>
> > >> On Wed, Sep 17, 2014 at 6:33 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > >>> This patch adds support for AppliedMicro X-Gene PCIe host controller. The
> > >>> driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
> > >>> cards.
> > >>>
> > >>> X-Gene PCIe controller driver has depedency on the pcie arm64 arch support.
> > >>> Liviu Dudau from ARM has sent a patch set for pcie arm64 arch support and
> > >>> support for creating generic pcie bridge from device tree. Liviu's patches
> > >>> are available here
> > >>> https://lkml.org/lkml/2014/9/8/333
> > >>>
> > >>> If someone wishes to test PCIe on X-Gene with this patch set, above mentioned
> > >>> patches from Liviu must be applied before the patches in this patch set. Also
> > >>> please use latest xgene u-boot firmware.
> > >>>
> > >>> changes since V8:
> > >>> 1. Add 'dma-coherent' attribute in device node.
> > >>
> > >>
> > >> I just tested your V9 patches plus Liviu's V10 PCI/ARM64 patches
> > >> against 3.17-rc5 on Mustang, and the following failure is triggered:
> > >>
> > >> [    1.190131] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit
> > >> Ethernet Driver bnx2x 1.78.19-0 (2014/02/10)
> > >> [    1.200249] tg3.c:v3.137 (May 11, 2014)
> > >> [    1.204087] ------------[ cut here ]------------
> > >> [    1.208682] WARNING: CPU: 1 PID: 1 at drivers/pci/pci.c:131
> > >> pci_ioremap_bar+0x70/0x78()
> > >> [    1.216646] Modules linked in:
> > >> [    1.219696] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc5+ #1
> > >> [    1.226018] Call trace:
> > >> [    1.228453] [<ffffffc0000884f0>] dump_backtrace+0x0/0x16c
> > >> [    1.233826] [<ffffffc00008866c>] show_stack+0x10/0x1c
> > >> [    1.238851] [<ffffffc0006e3210>] dump_stack+0x74/0x94
> > >> [    1.243878] [<ffffffc0000a934c>] warn_slowpath_common+0x88/0xb0
> > >> [    1.249767] [<ffffffc0000a9438>] warn_slowpath_null+0x14/0x20
> > >> [    1.255485] [<ffffffc0003994c4>] pci_ioremap_bar+0x6c/0x78
> > >> [    1.260942] [<ffffffc0005598cc>] tg3_init_one+0x148/0x16f4
> > >> [    1.266401] [<ffffffc00039ccf0>] pci_device_probe+0x78/0xd4
> > >> [    1.271946] [<ffffffc00042785c>] driver_probe_device+0x94/0x390
> > >> [    1.277834] [<ffffffc000427c44>] __driver_attach+0x98/0xa0
> > >> [    1.283293] [<ffffffc000425a54>] bus_for_each_dev+0x54/0x98
> > >> [    1.288835] [<ffffffc00042730c>] driver_attach+0x1c/0x28
> > >> [    1.294121] [<ffffffc000426f04>] bus_add_driver+0x164/0x240
> > >> [    1.299663] [<ffffffc000428430>] driver_register+0x64/0x130
> > >> [    1.305207] [<ffffffc00039c97c>] __pci_register_driver+0x3c/0x48
> > >> [    1.311181] [<ffffffc000aa8a5c>] tg3_driver_init+0x1c/0x28
> > >> [    1.316640] [<ffffffc0000814e0>] do_one_initcall+0xc4/0x1b4
> > >> [    1.322186] [<ffffffc000a74b64>] kernel_init_freeable+0x1b8/0x25c
> > >> [    1.328246] [<ffffffc0006de318>] kernel_init+0xc/0xd4
> > >> [    1.333278] ---[ end trace f4dca5ab5b436080 ]---
> > >> [    1.337871] tg3 0000:01:00.0: Cannot map device registers, aborting
> > >> [    1.344122] tg3: probe of 0000:01:00.0 failed with error -12
> > >>
> > >>
> > >
> > > Thanks for trying out the patches. Which firmware version are you
> > > using? We may have release new firmware version for PCI to work if not
> > > released yet.
> > 
> > U-Boot 2013.04-mustang_sw_1.13.28-beta (Aug 25 2014 - 14:16:10)
> > 
> > I will check if there is newer fw available.
> > 
> > > Also can you please send out the entire boot log?
> > 
> > Please see below link:
> > 
> >       http://pastebin.com/fLqaDn6t
> 
> From Ming's log, using the v9 patches:
> 
>   PCI host bridge /soc/pcie@1f2b0000 ranges:
>     No bus range found for /soc/pcie@1f2b0000, using [??? 0xffffffc3eb4292c0-0xffffffc0005e3b8c flags 0x40]
> 
> What's going on here?  It looks like it's from
> of_pci_get_host_bridge_resources(), but I don't see how this output could
> happen.

Sorry, v9 to v11 had a bug in the print message where the range was passed as a reference. I have since
fixed it in v12. I've noticed this log when preparing for v12 but somehow missed it in the change log?

Best regards,
Liviu

> 
>      IO 0xe010000000..0xe01000ffff -> 0x00000000
>     MEM 0xe180000000..0xe1ffffffff -> 0x80000000
>   xgene-pcie 1f2b0000.pcie: (rc) x1 gen-1 link up
>   xgene-pcie 1f2b0000.pcie: PCI host bridge to bus 0000:00
>   pci_bus 0000:00: root bus resource [bus 00-ff]
>   pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
>   pci_bus 0000:00: root bus resource [mem 0xe180000000-0xe1ffffffff] (bus address [0x80000000-0xffffffff])
>   pci_bus 0000:00: scanning bus
>   pci 0000:00:00.0: [19aa:e008] type 01 class 0x060400
>   pci 0000:00:00.0: reg 0x10: [mem 0x8000000000-0x807fffffff 64bit pref]
> 
> I guess this is the "inbound BAR" that you hid in the v10 patches.  Hiding
> it will prevent some of BAR assignment problems below.  This is probably
> what caused the tg3 mapping problem Ming initially reported above.  We
> tried to reassign the inbound BAR, and it took up the entire space that we
> thought was available for CPU accesses to the PCI bus, leaving none for the
> tg3 device.
> 
> Was Ming just unlucky by having an unusual configuration, e.g., with a lot
> of memory or something?  He certainly doesn't have a complicated PCIe
> hierarchy.  I assume you've tested this and had it work *somewhere*.
> 
>   pci 0000:00:00.0: supports D1 D2
>   pci_bus 0000:00: fixups for bus
>   pci 0000:00:00.0: scanning [bus 01-01] behind bridge, pass 0
>   pci_bus 0000:01: scanning bus
>   pci 0000:01:00.0: [14e4:165a] type 00 class 0x020000
>   pci 0000:01:00.0: reg 0x10: [mem 0x00100000-0x0010ffff 64bit]
>   pci 0000:01:00.0: PME# supported from D3hot
>   pci 0000:01:00.0: PME# disabled
>   pci_bus 0000:01: fixups for bus
>   pci_bus 0000:01: bus scan returning with max=01
>   pci 0000:00:00.0: scanning [bus 01-01] behind bridge, pass 1
>   pci_bus 0000:00: bus scan returning with max=01
>   pci 0000:00:00.0: BAR 0: assigned [mem 0xe180000000-0xe1ffffffff 64bit pref]
>   pci 0000:00:00.0: BAR 8: no space for [mem size 0x00100000]
>   pci 0000:00:00.0: BAR 8: failed to assign [mem size 0x00100000]
>   pci 0000:01:00.0: BAR 0: no space for [mem size 0x00010000 64bit]
>   pci 0000:01:00.0: BAR 0: failed to assign [mem size 0x00010000 64bit]
>   pci 0000:00:00.0: PCI bridge to [bus 01]
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

