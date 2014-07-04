Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaGDLkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:40:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47931 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaGDLkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:40:08 -0400
Date: Fri, 4 Jul 2014 12:40:04 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Prabhakar Kushwaha <prabhakar@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: PCI(e) arch support
Message-ID: <20140704114004.GG6501@e106497-lin.cambridge.arm.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
 <4342569.JSAyWBcJn2@wuerfel>
 <20140704110251.GF6501@e106497-lin.cambridge.arm.com>
 <8557411.iWl9PJdYsS@wuerfel>
MIME-Version: 1.0
In-Reply-To: <8557411.iWl9PJdYsS@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 04 Jul 2014 11:40:04.0565 (UTC) FILETIME=[B2A0B850:01CF977C]
X-MC-Unique: 114070412400600501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:28:09PM +0100, Arnd Bergmann wrote:
> On Friday 04 July 2014 12:02:51 Liviu Dudau wrote:
> > > Supporting just one boot loader is of course a bit silly, especially when
> > > you know that people will be using all sorts of boot loaders.
> > 
> > You could also argue that supporting just one kernel is silly as well, but
> > so far I haven't seen too many Linux people complaining that *BSD is not
> > officially supported.
> 
> I have heard complaints from UEFI people though that want to support
> more than just Linux ;-)
> 
> > It's also a small game of demand and offer: ARM partners that were interested
> > in ARMv8 have been asked which bootloader solution they are interested in,
> > and I guess not enough u-boot supporters made their voices heard. Limited
> > resources leads to limited choices.
> 
> I think it's rather a question of whether they'd benefit from ARM doing it.
> It's fairly easy to port most of the smaller boot-loaders, and there
> is not much architecture specific code in them.
> 
> > > A more interesting aspect of this question is what the kernel can expect
> > > the boot loader to have done with the PCI host bridge when the kernel
> > > is entered.
> > 
> > Indeed. I'm interested in opinions here.
> > 
> > > 
> > > Traditionally, embedded ARM boot loaders have left the PCI host bridge
> > > alone unless they were booting from it, and Linux did all the setup.
> > > With the SBSA class of ARM servers, this is not really practical, and
> > > whatever runs before Linux (typically UEFI) should already set up the
> > > PCI bus and do resource allocation like every other server architecture
> > > does. I would assume that UEFI does this right, and if not we can consider
> > > that a bug.
> > 
> > And at the moment we have UEFI on Juno that can be made SBSA compliant
> > but by default it's not (yes, it *is* a bug).
> 
> Is this because of the PCI config space access or something else?

No, just lack of man power to carry enough work in that area for UEFI.

> 
> The publically announced version of Juno doesn't have any PCI slots,
> so I guess this is about a future variant, right?

Yes, current chip has an errata on PCI which renders it unable to carry
device initiated transfers. This will be fixed in the next revision of
the chip due next year.

> 
> > > However, what do we do about PCI hosts that can be used with different
> > > kinds of systems? Do we assume that they all do PCI resource allocation?
> > > Can we decide this on a per host driver basis, or do we need to introduce
> > > an extension to the PCI DT binding to make that decision?
> > 
> > The PCI code currently should skip the configured devices and only touch
> > the not configured ones. The question is how to detect if the host bridge
> > has been initialised by the firmware or not.
> 
> On PowerPC we used to have a per platform flag that defined whether PCI was
> supposed to be initialized by firmware or by the OS, but it makes less
> sense on ARM64 since we try to avoid introducing the concept of platforms
> in too many places.
> 
> If we can't rely on the firmware to get it right, I think we don't have
> a choice but to rely on DT information (In the ACPI case, I would definitely
> mandate that the firmware has to get it right). We may also need to deal
> with the case of firmware initializing the PCI host bridge incorrectly,
> though we can try not to do that until we have to.
> 
> It should be easy enough to detect the case of a host bridge that has
> not been touched, but that would fail in case of kexec() when it has
> been set up by a previously running kernel.

One option would be to have per host controller registers that if at a known
value it would mean the setup has been done, but that is just giving ammo
to the hardware guys to screw us up.

Best regards,
Liviu

> 
> 	Arnd
> 
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

