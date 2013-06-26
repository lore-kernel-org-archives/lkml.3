Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3FZOFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:05:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51355 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3FZOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:05:07 -0400
Date: Wed, 26 Jun 2013 16:04:59 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Message-ID: <20130626140459.GB9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:13:39PM +0100, Grant Likely wrote:
> > diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> > +It (early) parses the FDT for the following parameters:
> 
> Need to state which node these properties can be found in. I recommend /chosen

Will do.
 
> I would also prefix all of the following properties with "linux,"
> since they are very much about what the Linux kernel needs for
> booting. EFI stub will be creating these properties specifically for
> Linux, and the LinuxLoader should do the same (until we eventually
> kill it).
 
And that.

> > +- 'efi-system-table':
> > +  Physical address of the system table. (required)
> 
> Need to mention the size of this address. Is it 64 bit or 32 bit? I
> would follow the lead of 'linux,initrd-start' here and make the size
> of property the size of the address. ie. If it is 8 bytes long, then
> it is a 64 bit address.
 
Currently, it's a 4-byte address.
Although technically possible to be >32-bit in an LPAE system, the 1:1
mappign requirement of the UEFI spec forces it to reside in the lower
4GB on a 32-bit system.

> > +- 'efi-runtime-mmap':
> > +  Physical address of an EFI memory map, containing at least
> > +  the regions to be preserved. (required)
> > +- 'efi-runtime-mmap-size':
> > +  Size in bytes of the provided memory map. (required)
> 
> I would collapse the above two properties into a single property that
> actually contains the memory map instead of pointing to it. You will
> also need to specify the exact format of the data in this property.
 
Ok, that makes sense.

Hmm. The data is an array of struct EFI_MEMORY_DESCRIPTOR entries,
known in Linux as efi_memory_desc_t. Is that a good enough description?

> > +- 'efi-mmap-desc-size':
> > +  Size of each descriptor in the memory map. (override default)
> > +- 'efi-mmap-desc-ver':
> > +  Memory descriptor format version. (override default)
> 
> I don't understand how these properties will actually work. What
> changes in the parsing if these properties are set?
 
I guess the intended use is that these options would permit you to
append new fields to the struct and have old code correctly parse the
array anyway.

/
    Leif
