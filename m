Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaB1F4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:56:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40476 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaB1F4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:56:33 -0500
Date: Fri, 28 Feb 2014 05:56:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140228055629.GA847@srcf.ucam.org>
References: <53100C8D.1060001@linux.intel.com>
 <20140228045637.GA28257@srcf.ucam.org>
 <53101D1D.9010202@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53101D1D.9010202@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:22:37PM +0800, Li, Aubrey wrote:
> On 2014/2/28 12:56, Matthew Garrett wrote:
> > EFI reboot is still somewhat unreliable - it may be safe after the 
> > recent patches to provide a 1:1 mapping.
> 
> So it's acceptable to put EFI in the default list.

Probably, once we've got those patches landed (I've lost track of 
whether they're in 3.13 or aimed at 3.14)

> > CF9 is, as far as I know, not  part of any spec, so it seems like a bad
> > idea to put it in the default list.
> 
> Any hurt known if put it in the default list?

Mm. Not all x86 platforms support cf8/cf9 (Moorestown, for instance) and 
so it's theoretically possible that they'd put some different hardware 
there instead. But then, Moorestown probably has its own reboot code, so 
that may not matter?

> > 
> > What do the ACPI reboot vectors look like on these systems?
> 
> Reset register address: 0xCF9
> Value to cause reset:   0x6

Huh. But that's almost exactly what the PCI reboot code would do. Why 
does the PCI method work but the ACPI one fail? Does it really depend on 
ORing the original value with the reset value? Or is the timing just 
somehow marginal?

> > This is definitely incorrect. The ACPI write *must* occur twice in order 
> > to be effective on various systems. EFI shouldn't be attempted until 
> > after the second ACPI write.
> > 
> 
> Do we have any spec mentioned that?

Nope. This is entirely unspecified, it's just how things work - several 
vendors use cf9 for the ACPI reboot vector, and there have to be two 
writes to cf9 to trigger the reboot. Windows attempts the write twice, 
and as a result things work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
