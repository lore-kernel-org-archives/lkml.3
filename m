Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3KQBkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 20:40:10 -0500
Received: from plane.gmane.org ([80.91.229.3]:52915 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3KQBkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 20:40:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikolaus Meine <meine@tnt.uni-hannover.de>
Subject: Re: =?utf-8?b?eGhjaV9oY2Q=?= 3.12 regression
Date: Sun, 17 Nov 2013 01:33:50 +0000 (UTC)
Message-ID: <loom.20131117T022347-280@post.gmane.org>
References: <20131110175002.GA26281@invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.83.204.222 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Iron/25.0.1400.0 Chrome/25.0.1400.0 Safari/537.22)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


M G Berberich <kernel <at> oss.m-berberich.de> writes:

> 
> Hello,
> 
> since 3.12 dmesg (and logfiles) are filled up with:
> 
>   xhci_hcd 0000:00:14.0: ep 0x81 - asked for 96 bytes, 78 bytes 
untransferred
>   xhci_hcd 0000:00:14.0: Giveback URB ffff8807f82ec240, len = 18, expected 
= 96, status = -121
>   xhci_hcd 0000:00:14.0: Stalled endpoint
>   xhci_hcd 0000:00:14.0: Giveback URB ffff8808181e0240, len = 0, expected 
= 13, status = -32
>   xhci_hcd 0000:00:14.0: Queueing reset endpoint command
>   xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
>   xhci_hcd 0000:00:14.0: Finding segment containing stopped TRB.
>   xhci_hcd 0000:00:14.0: Finding endpoint context
>   xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
>   xhci_hcd 0000:00:14.0: Cycle state = 0x0
>   xhci_hcd 0000:00:14.0: New dequeue segment = ffff8808195b4280 (virtual)
>   xhci_hcd 0000:00:14.0: New dequeue pointer = 0xfffb2140 (DMA)
>   xhci_hcd 0000:00:14.0: Queueing new dequeue state
>   xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = 
ffff8808195b4280 (0xfffb2000 dma), new deq ptr =
> ffff880816832140 (0xfffb2140 dma), new cycle = 0
>   xhci_hcd 0000:00:14.0: // Ding dong!
>   xhci_hcd 0000:00:14.0: WARN halted endpoint, queueing URB anyway.
>   xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
>   xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq =  <at> 
fffb2140
> 
> blocks, about 25 at a time, every 2 seconds.
> As far as I can tell, this is new with 3.12 (stock) kernel.
> 
> System is a i7 4770 on Gigabyte H87-HD3 motherboard, with a IcyBox
> IB-867-B, lshw-output attached.
> 
> /proc/version:
>   Linux version 3.12.0 (berberic <at> hermione) (gcc version 4.8.2 (Debian
>   4.8.2-1) ) #1 SMP PREEMPT Mon Nov 4 21:20:24 CET 2013
> 
> scripts/ver_linux:
>   Linux hermione 3.12.0 #1 SMP PREEMPT Mon Nov 4 21:20:24 CET 2013 x86_64 
GNU/Linux
> 
>   Gnu C                  4.8
>   Gnu make               3.81
>   binutils               2.23.90.20131017
>   util-linux             scripts/ver_linux: 23: scripts/ver_linux: 
fdformat: not found
>   mount                  support
>   module-init-tools      found
>   Linux C Library        2.17
>   Dynamic linker (ldd)   2.17
>   Procps                 3.3.4
>   Kbd                    1.15.5
>   Sh-utils               8.21
>   Modules Loaded ppdev lp bnep rfcomm bluetooth vboxpci vboxnetadp
>                  vboxnetflt vboxdrv kvm_intel kvm cpufreq_powersave
> 		 it87 hwmon_vid coretemp firewire_sbp2 firewire_core
> 		 fuse snd_usb_audio snd_usbmidi_lib snd_seq_midi
>                  snd_rawmidi pcspkr parport_pc parport
> 
> lsusb:
>   Bus 002 Device 002: ID 8087:8000 Intel Corp. 
>   Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>   Bus 001 Device 002: ID 8087:8008 Intel Corp. 
>   Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>   Bus 004 Device 002: ID 05e3:0732 Genesys Logic, Inc. 
>   Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>   Bus 003 Device 005: ID 08bb:2902 Texas Instruments PCM2902 Audio Codec
>   Bus 003 Device 004: ID 0409:005a NEC Corp. HighSpeed Hub
>   Bus 003 Device 003: ID 046d:c05a Logitech, Inc. M90/M100 Optical Mouse
>   Bus 003 Device 002: ID 03f0:6204 Hewlett-Packard DeskJet 5150c
>   Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> 	MfG
> 	bmg
> 

Hello!

After upgrading from kernel 3.11 to 3.12 my USB 3.0 card reader
(Transcend RDF8) stopped working with the same error.

I managed to find the code line which triggered the erroneous behaviour:

It's the definition of the macro xhci_dbg(...) in xhci.h line 1590/1591.

In 3.11 it is
  do { if (XHCI_DEBUG) dev_dbg(...); } while (0)

XHCI_DEBUG is defined as 0 because XHCI_HCD_DEBUGGING is not defined
so this macro collapses to nothing.

In 3.12 xhci_dbg(...) is defined as
  dev_dbg(...)
which actually calls dev_printk(...) because DEBUG is defined.

If I define xhci_dbg() in 3.12 as
  do { } while (0)
my card reader starts working again.

That was the good news.
The bad news is that I have no idea why calling dev_printk(...)
does any  harm here. Maybe it's a timing problem.


Best Regards
Nikolaus Meine


