Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaB1GM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:12:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40673 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaB1GM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:12:58 -0500
Date: Fri, 28 Feb 2014 06:12:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140228061254.GA2226@srcf.ucam.org>
References: <53100C8D.1060001@linux.intel.com>
 <20140228045637.GA28257@srcf.ucam.org>
 <53101D1D.9010202@linux.intel.com>
 <20140228055629.GA847@srcf.ucam.org>
 <531027BE.2010807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531027BE.2010807@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 02:07:58PM +0800, Li, Aubrey wrote:
> On 2014/2/28 13:56, Matthew Garrett wrote:
> > Probably, once we've got those patches landed (I've lost track of 
> > whether they're in 3.13 or aimed at 3.14)
> 
> You didn't look the reference I quoted in the patch.
> 
> It's stable if 32/64 bit linux call the corresponding 32/64bit EFI
> runtime service. Matt Fleming's mixed mode is aiming at 3.15:
> 
> http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=mixed-mode

It's stable as long as you have the 1:1 mapping patches, which are 
different to the mixed mode patches. Otherwise it'll work on some 
hardware and crash on others.

> > Mm. Not all x86 platforms support cf8/cf9 (Moorestown, for instance) and 
> > so it's theoretically possible that they'd put some different hardware 
> > there instead. But then, Moorestown probably has its own reboot code, so 
> > that may not matter?
> 
> Yes, Moorestown has its own machine_ops. Instead of the system hanging
> after issue "reboot" command, I think and suggest CF9 is worth to have a
> try.

Writing to arbitrary register addresses isn't a good plan if we're on a 
platform that might have different hardware there.

> >> Reset register address: 0xCF9
> >> Value to cause reset:   0x6
> > 
> > Huh. But that's almost exactly what the PCI reboot code would do. Why 
> > does the PCI method work but the ACPI one fail? Does it really depend on 
> > ORing the original value with the reset value? Or is the timing just 
> > somehow marginal?
> 
> reboot returns at:
> 
> if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
>                 return;
> 
> This is a ACPI bug or intention, who knows.

Well, how about we figure that out? Is there a full acpi dump of one of 
these machines somewhere?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
