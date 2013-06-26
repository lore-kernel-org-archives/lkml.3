Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FZNxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:53:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52814 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3FZNxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:53:22 -0400
Date: Wed, 26 Jun 2013 15:53:11 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Message-ID: <20130626135311.GA9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org>
 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:20:23PM +0100, Grant Likely wrote:
> On Wed, Jun 26, 2013 at 12:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > the properties) should be part of a file in
> > Documentation/devicetree/bindings/ (arm/uefi.txt?).
> >
> > What node are these properties expected to be contained within?
> >
> > Shouldn't that node be required to contain a compatible value, which
> > would define the schema for the other properties?
> 
> Typically, a compatible property isn't only used for nodes that
> represent a device or a so-called 'virtual' device (ie. such as to
> describe how all the sound complex is wired together) since that
> should be the clue to an OS that a device driver will bind against the
> node. I think these properties can be dropped into /chosen without
> defining a new compatible value.
 
That would be my preference.
But yes, that should be documented, and will be in the next version.

> >> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
> >> +even on LPAE-capable systems, the above fields are 32-bit regardless.
> >
> > What about ARMv8? Is the intention to have a separate definition for the
> > UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
> > future version of UEFI allows LPAE usage?
> 
> It is unlikely that will happen on v7 since newer versions of UEFI are
> expected to remain backwards compatible with the current spec.
 
I'm going to go out on a limb here and claim that it wouldn't be possible
to do that compatibly. The current spec doesn't ban LPAE (or "use of long
descriptors"). But it does specify that all RAM known to UEFI must use a
1:1 mapping.

> >> +After the kernel has mapped the required regions into its address space,
> >> +a SetVirtualAddressMap() call is made into UEFI in order to update
> >> +relocations. This call must be performed with all the code in a 1:1
> >
> > Presumably "all the code" also includes "all .data and .bss", or
> > whatever the UEFI-equivalent may be? I'm not familiar with UEFI at all;
> > does the "EFI memory map" mentioned above describe all the memory
> > regions that must be mapped to use UEFI?
> 
> yes.Actually, there is an API for retrieving the memory map from UEFI
> at runtime, but it is difficult to call from within the kernel.
> Actually, my preference would be to not require GRUB or the Linux
> Loader to add the above properties at all and instead have the kernel
> proper retrieve the memory map directly. That would reduce the
> dependency on GRUB/LinuxLoader doing things correctly, but Leif knows
> better how feasible that would be.

It's completely feasible, but we'd need to use a different method to do
the boot services call with a 1:1 mapping (idmap support is not available
until much later in the boot process).

The System Table pointer still needs to be passed across though.

/
    Leif
