Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab3BFU0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:26:03 -0500
Received: from meriadoc.sigma-star.at ([178.63.61.2]:40863 "EHLO
	meriadoc.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3BFU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:26:00 -0500
Date: Wed, 6 Feb 2013 21:25:53 +0100
From: Richard Weinberger <richard@sigma-star.at>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gstir <david@sigma-star.at>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DMAR faults from unrelated device when vfio is used
Message-ID: <20130206212553.667e6d8b@spider.haslach.nod.at>
In-Reply-To: <1360176440.11144.676.camel@bling.home>
References: <1359972630.2498.21.camel@riven-lux.site>
	<1359992968.11144.414.camel@bling.home>
	<1360071110.6200.19.camel@riven-lux.site>
	<1360078648.11144.558.camel@bling.home>
	<1360096613.11144.612.camel@bling.home>
	<20130206190908.79073124@spider.haslach.nod.at>
	<1360176440.11144.676.camel@bling.home>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/hFJw6wLWY8LMNi8EzBB7G5f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/hFJw6wLWY8LMNi8EzBB7G5f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Am Wed, 06 Feb 2013 11:47:20 -0700
schrieb Alex Williamson <alex.williamson@redhat.com>: 
> Does the card work with pci-assign or are both broken?

It works with pci-assign. :-\

 
> Possible there's a bug in how we're managing the vector table and pba
> here.  Can you get to the monitor and run 'into mtree' and provide the
> results?  Thanks,

Please see attachment.

Thanks,
//richard
--MP_/hFJw6wLWY8LMNi8EzBB7G5f
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=mtree_vfio.txt

(qemu) info mtree
info mtree
memory
0000000000000000-7ffffffffffffffe (prio 0, RW): system
  0000000000000000-00000000dfffffff (prio 0, RW): alias ram-below-4g @pc.ram 0000000000000000-00000000dfffffff
  00000000000a0000-00000000000bffff (prio 1, RW): alias smram-region @pci 00000000000a0000-00000000000bffff
  00000000000c0000-00000000000c3fff (prio 1, R-): alias pam-rom @pc.ram 00000000000c0000-00000000000c3fff
  00000000000c4000-00000000000c7fff (prio 1, R-): alias pam-rom @pc.ram 00000000000c4000-00000000000c7fff
  00000000000c8000-00000000000cbfff (prio 1, R-): alias pam-rom @pc.ram 00000000000c8000-00000000000cbfff
  00000000000cb000-00000000000cdfff (prio 1000, RW): alias kvmvapic-rom @pc.ram 00000000000cb000-00000000000cdfff
  00000000000cc000-00000000000cffff (prio 1, R-): alias pam-rom @pc.ram 00000000000cc000-00000000000cffff
  00000000000d0000-00000000000d3fff (prio 1, RW): alias pam-ram @pc.ram 00000000000d0000-00000000000d3fff
  00000000000d4000-00000000000d7fff (prio 1, RW): alias pam-ram @pc.ram 00000000000d4000-00000000000d7fff
  00000000000d8000-00000000000dbfff (prio 1, RW): alias pam-ram @pc.ram 00000000000d8000-00000000000dbfff
  00000000000dc000-00000000000dffff (prio 1, RW): alias pam-ram @pc.ram 00000000000dc000-00000000000dffff
  00000000000e0000-00000000000e3fff (prio 1, RW): alias pam-ram @pc.ram 00000000000e0000-00000000000e3fff
  00000000000e4000-00000000000e7fff (prio 1, RW): alias pam-ram @pc.ram 00000000000e4000-00000000000e7fff
  00000000000e8000-00000000000ebfff (prio 1, RW): alias pam-ram @pc.ram 00000000000e8000-00000000000ebfff
  00000000000ec000-00000000000effff (prio 1, RW): alias pam-ram @pc.ram 00000000000ec000-00000000000effff
  00000000000f0000-00000000000fffff (prio 1, R-): alias pam-rom @pc.ram 00000000000f0000-00000000000fffff
  00000000e0000000-00000000ffffffff (prio 0, RW): alias pci-hole @pci 00000000e0000000-00000000ffffffff
  00000000fec00000-00000000fec00fff (prio 0, RW): kvm-ioapic
  00000000fed00000-00000000fed003ff (prio 0, RW): hpet
  00000000fee00000-00000000feefffff (prio 0, RW): kvm-apic-msi
  0000000100000000-000000019fffffff (prio 0, RW): alias ram-above-4g @pc.ram 00000000e0000000-000000017fffffff
  00000001a0000000-400000019fffffff (prio 0, RW): alias pci-hole64 @pci 00000001a0000000-400000019fffffff
I/O
0000000000000000-000000000000ffff (prio 0, RW): io
  0000000000000020-0000000000000021 (prio 0, RW): kvm-pic
  0000000000000040-0000000000000043 (prio 0, RW): kvm-pit
  0000000000000060-0000000000000060 (prio 0, RW): i8042-data
  0000000000000061-0000000000000061 (prio 0, RW): elcr
  0000000000000064-0000000000000064 (prio 0, RW): i8042-cmd
  0000000000000070-0000000000000071 (prio 0, RW): rtc
  000000000000007e-000000000000007f (prio 0, RW): kvmvapic
  0000000000000092-0000000000000092 (prio 0, RW): port92
  00000000000000a0-00000000000000a1 (prio 0, RW): kvm-pic
  0000000000000170-0000000000000177 (prio 0, RW): alias ide @ide 0000000000000170-0000000000000177
  00000000000001ce-00000000000001d0 (prio 0, RW): alias vbe @vbe 00000000000001ce-00000000000001d0
  00000000000001f0-00000000000001f7 (prio 0, RW): alias ide @ide 00000000000001f0-00000000000001f7
  0000000000000376-0000000000000376 (prio 0, RW): alias ide @ide 0000000000000376-0000000000000376
  0000000000000378-000000000000037f (prio 0, RW): alias parallel @parallel 0000000000000378-000000000000037f
  00000000000003b4-00000000000003b5 (prio 0, RW): alias vga @vga 00000000000003b4-00000000000003b5
  00000000000003ba-00000000000003ba (prio 0, RW): alias vga @vga 00000000000003ba-00000000000003ba
  00000000000003c0-00000000000003cf (prio 0, RW): alias vga @vga 00000000000003c0-00000000000003cf
  00000000000003d4-00000000000003d5 (prio 0, RW): alias vga @vga 00000000000003d4-00000000000003d5
  00000000000003da-00000000000003da (prio 0, RW): alias vga @vga 00000000000003da-00000000000003da
  00000000000003f1-00000000000003f5 (prio 0, RW): alias fdc @fdc 00000000000003f1-00000000000003f5
  00000000000003f6-00000000000003f6 (prio 0, RW): alias ide @ide 00000000000003f6-00000000000003f6
  00000000000003f7-00000000000003f7 (prio 0, RW): alias fdc @fdc 00000000000003f7-00000000000003f7
  00000000000003f8-00000000000003ff (prio 0, RW): serial
  00000000000004d0-00000000000004d0 (prio 0, RW): kvm-elcr
  00000000000004d1-00000000000004d1 (prio 0, RW): kvm-elcr
  0000000000000510-0000000000000511 (prio 0, RW): fwcfg
  0000000000000cf8-0000000000000cfb (prio 0, RW): pci-conf-idx
  0000000000000cfc-0000000000000cff (prio 0, RW): pci-conf-data
  0000000000005658-0000000000005658 (prio 0, RW): vmport
  000000000000c000-000000000000c01f (prio 1, RW): uhci
  000000000000c020-000000000000c03f (prio 1, RW): virtio-pci
  000000000000c040-000000000000c04f (prio 1, RW): piix-bmdma-container
    000000000000c040-000000000000c043 (prio 0, RW): piix-bmdma
    000000000000c044-000000000000c047 (prio 0, RW): bmdma
    000000000000c048-000000000000c04b (prio 0, RW): piix-bmdma
    000000000000c04c-000000000000c04f (prio 0, RW): bmdma
aliases
pc.ram
0000000000000000-000000017fffffff (prio 0, RW): pc.ram
pci
0000000000000000-7ffffffffffffffe (prio 0, RW): pci
  00000000000a0000-00000000000affff (prio 2, RW): alias vga.chain4 @vga.vram 0000000000000000-000000000000ffff
  00000000000a0000-00000000000bffff (prio 1, RW): vga-lowmem
  00000000000c0000-00000000000dffff (prio 1, RW): pc.rom
  00000000000e0000-00000000000fffff (prio 1, R-): alias isa-bios @pc.bios 0000000000000000-000000000001ffff
  00000000e0000000-00000000efffffff (prio 1, RW): vga.vram
  00000000febf0000-00000000febf3fff (prio 1, RW): VFIO 0000:00:1b.0 BAR 0
    00000000febf0000-00000000febf3fff (prio 0, RW): VFIO 0000:00:1b.0 BAR 0 mmap
  00000000febf4000-00000000febf5fff (prio 1, RW): VFIO 0000:03:00.0 BAR 0
    00000000febf4000-00000000febf4fff (prio 0, RW): VFIO 0000:03:00.0 BAR 0 mmap
    00000000febf5000-00000000febf507f (prio 0, RW): msix-table
    00000000febf5080-00000000febf5087 (prio 0, RW): msix-pba
    00000000febf6000-00000000febf5fff (prio 0, RW): VFIO 0000:03:00.0 BAR 0 mmap msix-hi
  00000000febf6000-00000000febf6fff (prio 1, RW): vga.mmio
    00000000febf6400-00000000febf641f (prio 0, RW): vga ioports remapped
    00000000febf6500-00000000febf6515 (prio 0, RW): bochs dispi interface
  00000000febf7000-00000000febf7fff (prio 1, RW): virtio-net-pci-msix
    00000000febf7000-00000000febf702f (prio 0, RW): msix-table
    00000000febf7800-00000000febf7807 (prio 0, RW): msix-pba
  00000000febf8000-00000000febf83ff (prio 1, RW): VFIO 0000:00:1a.0 BAR 0
    00000000febf8000-00000000febf7fff (prio 0, RW): VFIO 0000:00:1a.0 BAR 0 mmap
  00000000febf9000-00000000febf93ff (prio 1, RW): VFIO 0000:00:1d.0 BAR 0
    00000000febf9000-00000000febf8fff (prio 0, RW): VFIO 0000:00:1d.0 BAR 0 mmap
  00000000fffe0000-00000000ffffffff (prio 0, R-): pc.bios
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
vbe
0000000000000000-7ffffffffffffffe (prio 0, RW): vbe
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
parallel
0000000000000000-7ffffffffffffffe (prio 0, RW): parallel
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
fdc
0000000000000000-7ffffffffffffffe (prio 0, RW): fdc
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
fdc
0000000000000000-7ffffffffffffffe (prio 0, RW): fdc
vga.vram
00000000e0000000-00000000efffffff (prio 1, RW): vga.vram
pc.bios
00000000fffe0000-00000000ffffffff (prio 0, R-): pc.bios
--MP_/hFJw6wLWY8LMNi8EzBB7G5f
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=mtee_pciassign.txt

(qemu) info mtree
info mtree
memory
0000000000000000-7ffffffffffffffe (prio 0, RW): system
  0000000000000000-00000000dfffffff (prio 0, RW): alias ram-below-4g @pc.ram 0000000000000000-00000000dfffffff
  00000000000a0000-00000000000bffff (prio 1, RW): alias smram-region @pci 00000000000a0000-00000000000bffff
  00000000000c0000-00000000000c3fff (prio 1, R-): alias pam-rom @pc.ram 00000000000c0000-00000000000c3fff
  00000000000c4000-00000000000c7fff (prio 1, R-): alias pam-rom @pc.ram 00000000000c4000-00000000000c7fff
  00000000000c8000-00000000000cbfff (prio 1, R-): alias pam-rom @pc.ram 00000000000c8000-00000000000cbfff
  00000000000cb000-00000000000cdfff (prio 1000, RW): alias kvmvapic-rom @pc.ram 00000000000cb000-00000000000cdfff
  00000000000cc000-00000000000cffff (prio 1, R-): alias pam-rom @pc.ram 00000000000cc000-00000000000cffff
  00000000000d0000-00000000000d3fff (prio 1, RW): alias pam-ram @pc.ram 00000000000d0000-00000000000d3fff
  00000000000d4000-00000000000d7fff (prio 1, RW): alias pam-ram @pc.ram 00000000000d4000-00000000000d7fff
  00000000000d8000-00000000000dbfff (prio 1, RW): alias pam-ram @pc.ram 00000000000d8000-00000000000dbfff
  00000000000dc000-00000000000dffff (prio 1, RW): alias pam-ram @pc.ram 00000000000dc000-00000000000dffff
  00000000000e0000-00000000000e3fff (prio 1, RW): alias pam-ram @pc.ram 00000000000e0000-00000000000e3fff
  00000000000e4000-00000000000e7fff (prio 1, RW): alias pam-ram @pc.ram 00000000000e4000-00000000000e7fff
  00000000000e8000-00000000000ebfff (prio 1, RW): alias pam-ram @pc.ram 00000000000e8000-00000000000ebfff
  00000000000ec000-00000000000effff (prio 1, RW): alias pam-ram @pc.ram 00000000000ec000-00000000000effff
  00000000000f0000-00000000000fffff (prio 1, R-): alias pam-rom @pc.ram 00000000000f0000-00000000000fffff
  00000000e0000000-00000000ffffffff (prio 0, RW): alias pci-hole @pci 00000000e0000000-00000000ffffffff
  00000000fec00000-00000000fec00fff (prio 0, RW): kvm-ioapic
  00000000fed00000-00000000fed003ff (prio 0, RW): hpet
  00000000fee00000-00000000feefffff (prio 0, RW): kvm-apic-msi
  0000000100000000-000000019fffffff (prio 0, RW): alias ram-above-4g @pc.ram 00000000e0000000-000000017fffffff
  00000001a0000000-400000019fffffff (prio 0, RW): alias pci-hole64 @pci 00000001a0000000-400000019fffffff
I/O
0000000000000000-000000000000ffff (prio 0, RW): io
  0000000000000020-0000000000000021 (prio 0, RW): kvm-pic
  0000000000000040-0000000000000043 (prio 0, RW): kvm-pit
  0000000000000060-0000000000000060 (prio 0, RW): i8042-data
  0000000000000061-0000000000000061 (prio 0, RW): elcr
  0000000000000064-0000000000000064 (prio 0, RW): i8042-cmd
  0000000000000070-0000000000000071 (prio 0, RW): rtc
  000000000000007e-000000000000007f (prio 0, RW): kvmvapic
  0000000000000092-0000000000000092 (prio 0, RW): port92
  00000000000000a0-00000000000000a1 (prio 0, RW): kvm-pic
  0000000000000170-0000000000000177 (prio 0, RW): alias ide @ide 0000000000000170-0000000000000177
  00000000000001ce-00000000000001d0 (prio 0, RW): alias vbe @vbe 00000000000001ce-00000000000001d0
  00000000000001f0-00000000000001f7 (prio 0, RW): alias ide @ide 00000000000001f0-00000000000001f7
  0000000000000376-0000000000000376 (prio 0, RW): alias ide @ide 0000000000000376-0000000000000376
  0000000000000378-000000000000037f (prio 0, RW): alias parallel @parallel 0000000000000378-000000000000037f
  00000000000003b4-00000000000003b5 (prio 0, RW): alias vga @vga 00000000000003b4-00000000000003b5
  00000000000003ba-00000000000003ba (prio 0, RW): alias vga @vga 00000000000003ba-00000000000003ba
  00000000000003c0-00000000000003cf (prio 0, RW): alias vga @vga 00000000000003c0-00000000000003cf
  00000000000003d4-00000000000003d5 (prio 0, RW): alias vga @vga 00000000000003d4-00000000000003d5
  00000000000003da-00000000000003da (prio 0, RW): alias vga @vga 00000000000003da-00000000000003da
  00000000000003f1-00000000000003f5 (prio 0, RW): alias fdc @fdc 00000000000003f1-00000000000003f5
  00000000000003f6-00000000000003f6 (prio 0, RW): alias ide @ide 00000000000003f6-00000000000003f6
  00000000000003f7-00000000000003f7 (prio 0, RW): alias fdc @fdc 00000000000003f7-00000000000003f7
  00000000000003f8-00000000000003ff (prio 0, RW): serial
  00000000000004d0-00000000000004d0 (prio 0, RW): kvm-elcr
  00000000000004d1-00000000000004d1 (prio 0, RW): kvm-elcr
  0000000000000510-0000000000000511 (prio 0, RW): fwcfg
  0000000000000cf8-0000000000000cfb (prio 0, RW): pci-conf-idx
  0000000000000cfc-0000000000000cff (prio 0, RW): pci-conf-data
  0000000000005658-0000000000005658 (prio 0, RW): vmport
  000000000000c000-000000000000c01f (prio 1, RW): uhci
  000000000000c020-000000000000c03f (prio 1, RW): virtio-pci
  000000000000c040-000000000000c04f (prio 1, RW): piix-bmdma-container
    000000000000c040-000000000000c043 (prio 0, RW): piix-bmdma
    000000000000c044-000000000000c047 (prio 0, RW): bmdma
    000000000000c048-000000000000c04b (prio 0, RW): piix-bmdma
    000000000000c04c-000000000000c04f (prio 0, RW): bmdma
aliases
pc.ram
0000000000000000-000000017fffffff (prio 0, RW): pc.ram
pci
0000000000000000-7ffffffffffffffe (prio 0, RW): pci
  00000000000a0000-00000000000affff (prio 2, RW): alias vga.chain4 @vga.vram 0000000000000000-000000000000ffff
  00000000000a0000-00000000000bffff (prio 1, RW): vga-lowmem
  00000000000c0000-00000000000dffff (prio 1, RW): pc.rom
  00000000000e0000-00000000000fffff (prio 1, R-): alias isa-bios @pc.bios 0000000000000000-000000000001ffff
  00000000e0000000-00000000efffffff (prio 1, RW): vga.vram
  00000000febf0000-00000000febf3fff (prio 1, RW): VFIO 0000:00:1b.0 BAR 0
    00000000febf0000-00000000febf3fff (prio 0, RW): VFIO 0000:00:1b.0 BAR 0 mmap
  00000000febf4000-00000000febf5fff (prio 1, RW): assigned-dev-container
    00000000febf4000-00000000febf5fff (prio 0, RW): kvm-pci-assign.bar0
    00000000febf5000-00000000febf5fff (prio 1, RW): assigned-dev-msix
  00000000febf6000-00000000febf6fff (prio 1, RW): vga.mmio
    00000000febf6400-00000000febf641f (prio 0, RW): vga ioports remapped
    00000000febf6500-00000000febf6515 (prio 0, RW): bochs dispi interface
  00000000febf7000-00000000febf7fff (prio 1, RW): virtio-net-pci-msix
    00000000febf7000-00000000febf702f (prio 0, RW): msix-table
    00000000febf7800-00000000febf7807 (prio 0, RW): msix-pba
  00000000febf8000-00000000febf83ff (prio 1, RW): VFIO 0000:00:1a.0 BAR 0
    00000000febf8000-00000000febf7fff (prio 0, RW): VFIO 0000:00:1a.0 BAR 0 mmap
  00000000febf9000-00000000febf93ff (prio 1, RW): VFIO 0000:00:1d.0 BAR 0
    00000000febf9000-00000000febf8fff (prio 0, RW): VFIO 0000:00:1d.0 BAR 0 mmap
  00000000fffe0000-00000000ffffffff (prio 0, R-): pc.bios
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
vbe
0000000000000000-7ffffffffffffffe (prio 0, RW): vbe
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
parallel
0000000000000000-7ffffffffffffffe (prio 0, RW): parallel
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
vga
0000000000000000-7ffffffffffffffe (prio 0, RW): vga
fdc
0000000000000000-7ffffffffffffffe (prio 0, RW): fdc
ide
0000000000000000-7ffffffffffffffe (prio 0, RW): ide
fdc
0000000000000000-7ffffffffffffffe (prio 0, RW): fdc
vga.vram
00000000e0000000-00000000efffffff (prio 1, RW): vga.vram
pc.bios
00000000fffe0000-00000000ffffffff (prio 0, R-): pc.bios
--MP_/hFJw6wLWY8LMNi8EzBB7G5f--
