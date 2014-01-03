Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaACDkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:40:55 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52577 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaACDkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:40:53 -0500
Date: Fri, 3 Jan 2014 11:40:37 +0800
From: littlebat <dashing.meng@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: denis.turischev@compulab.co.il, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Oliver Neukum <oneukum@suse.de>, dashing.meng@gmail.com,
        Niklas Schnelle <niklas@komani.de>, Giorgos <ganastasiouGR@gmail.com>,
        art1@vhex.net
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
Message-Id: <20140103114037.89bd88ae161ac9f9827a3008@gmail.com>
In-Reply-To: <20140103000334.GE9621@xanatos>
References: <52B31EDA.60908@compulab.co.il>
	<52B327D5.3080805@compulab.co.il>
	<20131219182110.GC3573@xanatos>
	<52B41EC7.1070704@compulab.co.il>
	<20131220234547.GC2835@xanatos>
	<52B69925.8030409@compulab.co.il>
	<20140103000334.GE9621@xanatos>
Organization: RMQ
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 16:03:34 -0800
Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> On Sun, Dec 22, 2013 at 09:47:49AM +0200, Denis Turischev wrote:
> > On 12/21/2013 01:45 AM, Sarah Sharp wrote:
> > > On Fri, Dec 20, 2013 at 12:41:11PM +0200, Denis Turischev wrote:
> > >>> Also, which kernel are you experiencing this issue on?  In
> > >>> 3.12, I queued a separate patch to deal with spurious reboot
> > >>> issues on Lynx Point:
> > >>>
> > >>> commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
> > >> Sorry, I indeed tested not on the latest kernel version, Ubuntu
> > >> 3.13-rc3 has this patch and it works for me.
> > > 
> > > What does "Ubuntu 3.13-rc3" mean?  Where did you get your kernel
> > > from?
> > Latest Ubuntu development kernel based on mainline 3.13-rc3.
> > http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.13-rc3-trusty/
> > > 
> > > Also, do you have an HP system, or is this a different vendor?
> > No, it's not HP system, it's Compulab's IntensePC-2 with Phoenix
> > BIOS.
> 
> Ok, that's a bit of an issue then.  Your system needs the quirk
> introduced by commit 638298dc66ea36623dbc2757a24fc2c4ab41b016 "xhci:
> Fix spurious wakeups after S5 on Haswell".  That went into 3.12-rc3.
> However, in 3.13-rc6, commit 6962d914f317b119e0db7189199b21ec77a4b3e0
> "xhci: Limit the spurious wakeup fix only to HP machines" limited the
> quirk to only HP systems.
> 
> That means your system worked fine in 3.13-rc3 (when the quirk was
> applied broadly), but won't work for 3.13-rc6 (when the quirk was
> narrowed to HP machines).  So we need the quirk to apply to your
> systems as well.
> 
> ISTR that the other folks on Cc (Meng, Niklas, Giorgos, and Art) all
> had systems that broke when commit
> 638298dc66ea36623dbc2757a24fc2c4ab41b016 was introduced.  For those
> systems, what vendor was the system, and what BIOS was it running?

I'm Meng(littlebat), 
Motherboard vendor:
Manufacturer: ASRock
Product Name: Z87 Pro3

BIOS:

Boot into BIOS setup interface, only show:
ASRock UEFI Setup Utility
UIFI Version: Z87 Pro3 P2.20
Chipset Version: C2

Information below gotten from command: sudo dmidecode
# dmidecode 2.12
SMBIOS 2.7 present.
26 structures occupying 1467 bytes.
Table at 0x000EE880.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: P2.20
	Release Date: 07/03/2013
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 8192 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
		UEFI is supported
	BIOS Revision: 4.6

The original bug report of mine is:
https://bugzilla.kernel.org/show_bug.cgi?id=66551

and the bug disappeared when applied patch: commit
6962d914f317b119e0db7189199b21ec77a4b3e0 "xhci: Limit the spurious
wakeup fix only to HP machines"

> 
> Takashi, did the HP systems that needed the quirk have a Phoenix BIOS?
> 
> Denis, do all of Compulab's Haswell systems reboot on shutdown?  Are
> they all running a Phoenix BIOS?  Can you send me the output of `sudo
> lspci -vvv -s` for the xHCI host?
> 
> Basically, I'm trying to find a common variable to key off.  I suspect
> BIOS vendor is probably the right thing, instead of system vendor.
> 
> Sarah Sharp
