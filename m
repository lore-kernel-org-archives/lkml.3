Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaKZM23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:28:29 -0500
Received: from mail0.toppoint.de ([217.70.197.20]:56608 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:28:28 -0500
Date: Wed, 26 Nov 2014 12:22:18 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Deucher <alexdeucher@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] radeon: acquire BIOS via firmware subsystem if
 everything else failed
Message-ID: <20141126122218.GB5782@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@linux.ie>
References: <20141122193025.GA5782@kaos.lebenslange-mailadresse.de>
 <CADnq5_OCeJ2M6qJXLXVow-RN6nZjBjmhQwu-FLSjLwwLWpsE5w@mail.gmail.com>
 <20141125172550.GA19688@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125172550.GA19688@srcf.ucam.org>
X-message-flag: Get yourself a real email client. http://www.mutt.org/
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tldr: works now, without patch, without GRUB, with efi-stub

Am Tue, Nov 25, 2014 at 05:25:50PM +0000 schrieb Matthew Garrett:
> On Tue, Nov 25, 2014 at 12:14:21PM -0500, Alex Deucher wrote:
> > The vbios image is available via ACPI prior to the OS taking over.
> > IIRC, Matthew Garret fixed up the bootloader to fetch the vbios image
> > prior to loading Linux so that it could be accessed after the OS
> > loaded.
> 
> EFI rather than ACPI, but yeah. In theory this should work fine if 
> you're using the EFI entry point. I don't know whether the patches for 
> linuxefi were ever accepted by grub upstream - if not, pushing those 
> would make more sense.

I could not find any patches for GRUB in this context. I did find big
numbers of web pages detailing how one would need to disable KMS to
use the radeon, or how to patch the radeon driver to load a vbios dump
from a file, or plain telling radeon didn't work. At least one for
about every Linux distribution I have heard of, and then some.

I could not find a way to use the EFI entry point from GRUB either.
Using the "linux" command was what never worked for me. I tried
"linuxefi", which complained about an invalid signature.

I then had a look at rEFInd again, upgraded it to the current version,
and then booted from rEFInd the same Linux 3.18-rc6 image (without the
patch) that did not work with GRUB earlier, and everything works ok.

Going to remove GRUB now :)

Sorry for any inconvenience...

Best regards,
Wilfried

---

Some details for others who might find this useful:

Hardware: MacBookPro8,2
Boot "chain": EFI -> rEFInd 0.8.3 ("gnuefi" variant) -> Linux 3.18-rc6
Kernel Commandline: "ro root=/dev/vg0/root video=radeondrmfb:1680x1050-32@60 radeon.dpm=1 video=inteldrmfb:1680x1050-32@60 i915.lvds_use_ssc=0 i915.lvds_downclock=1"

