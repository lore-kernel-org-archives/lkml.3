Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaARCB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 21:01:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50500 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaARCB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 21:01:57 -0500
Date: Sat, 18 Jan 2014 03:01:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140118020155.GA24158@amd.pavel.ucw.cz>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <20140117222806.GB13930@amd.pavel.ucw.cz>
 <20140117225013.GE14649@pd.tnic>
 <52D9B408.4020007@zytor.com>
 <20140118002926.GA22185@amd.pavel.ucw.cz>
 <52D9D6FC.7050100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D9D6FC.7050100@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-01-17 17:21:00, H. Peter Anvin wrote:
> On 01/17/2014 04:29 PM, Pavel Machek wrote:
> > 
> > Have you checked your dmesg recently? Normal people don't read
> > it... it is just too much of it.
> > 
> >> Printing a warning is appropriate if we can't actually fix the problem
> >> in the OS.  If we actually make the problem go away then we have just
> >> done our job and we can be done with it.
> > 
> > I disagree. Older kernel versions still may have problem, etc.
> > 
> > We normally do print warnings for problems we work around. We want
> > vendors to fix their hardware, too...
> > 
> > ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT -
> > 0xBDB5FF40/0x00000000BDB64F40, using 32 (20131115/tbfadt-522)
> > [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> > 
> 
> You say people don't read their dmesg...
> ... because there is too much ...
> ... so let's add more?

I'd say that proposed "your bios has a bug" is way more useful than
stuff such as:

pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
pci 0000:00:00.0: [8086:2e30] type 00 class 0x060000
pci 0000:00:01.0: [8086:2e31] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: System wakeup disabled by ACPI
pci 0000:00:02.0: [8086:2e32] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff 64bit]
pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:02.0: reg 0x20: [io  0xf140-0xf147]
pci 0000:00:02.1: [8086:2e33] type 00 class 0x038000
pci 0000:00:02.1: reg 0x10: [mem 0xd0400000-0xd04fffff 64bit]
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xd0600000-0xd0603fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
pci 0000:00:1d.0: System wakeup disabled by ACPI

So yes. Lets add useful stuff.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
