Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaGDLC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:02:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44103 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaGDLCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:02:55 -0400
Date: Fri, 4 Jul 2014 12:02:51 +0100
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
Message-ID: <20140704110251.GF6501@e106497-lin.cambridge.arm.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
 <53B5F81B.8010801@freescale.com>
 <20140704094440.GC6501@e106497-lin.cambridge.arm.com>
 <4342569.JSAyWBcJn2@wuerfel>
MIME-Version: 1.0
In-Reply-To: <4342569.JSAyWBcJn2@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 04 Jul 2014 11:02:52.0078 (UTC) FILETIME=[7FF63CE0:01CF9777]
X-MC-Unique: 114070412025216201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:21:00AM +0100, Arnd Bergmann wrote:
> On Friday 04 July 2014 10:44:40 Liviu Dudau wrote:
> > On Fri, Jul 04, 2014 at 01:40:59AM +0100, Prabhakar Kushwaha wrote:
> > > Hi Tanmay, Liviu,
> > > On 7/4/2014 2:57 AM, Tanmay Inamdar wrote:
> > > > Reposting on request of several people since previously posted one was
> > > > corrupted.
> > > >
> > > > This patch adds the arch support for PCI(e) for arm64. The files
> > > > added or modified in this patch are based on PCI(e) support in
> > > > 32bit arm.
> > > >
> > > > Please note that this patch is just for the reference. Liviu Dudau from ARM
> > > > has posted his v8 series of patch to support PCIe in arm64.
> > > >
> > > > The patch will apply against 3.13 Linux Kernel
> > > >
> > > > Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> > > >
> > > 
> > > do we foresee similar type of changes in u-boot  to support PCI(e) for 
> > > ARM64.
> > 
> > I'm afraid I'm not familiar with u-boot's support for PCI(e), so I cannot
> > answer that. As a general matter, ARM has decided to officially support
> > UEFI as a bootloader for ARMv8 and that already has support for PCI(e),
> > one only needs a driver for the specific host bridge.
> 
> Supporting just one boot loader is of course a bit silly, especially when
> you know that people will be using all sorts of boot loaders.

You could also argue that supporting just one kernel is silly as well, but
so far I haven't seen too many Linux people complaining that *BSD is not
officially supported.

It's also a small game of demand and offer: ARM partners that were interested
in ARMv8 have been asked which bootloader solution they are interested in,
and I guess not enough u-boot supporters made their voices heard. Limited
resources leads to limited choices.

> 
> A more interesting aspect of this question is what the kernel can expect
> the boot loader to have done with the PCI host bridge when the kernel
> is entered.

Indeed. I'm interested in opinions here.

> 
> Traditionally, embedded ARM boot loaders have left the PCI host bridge
> alone unless they were booting from it, and Linux did all the setup.
> With the SBSA class of ARM servers, this is not really practical, and
> whatever runs before Linux (typically UEFI) should already set up the
> PCI bus and do resource allocation like every other server architecture
> does. I would assume that UEFI does this right, and if not we can consider
> that a bug.

And at the moment we have UEFI on Juno that can be made SBSA compliant
but by default it's not (yes, it *is* a bug).

> 
> However, what do we do about PCI hosts that can be used with different
> kinds of systems? Do we assume that they all do PCI resource allocation?
> Can we decide this on a per host driver basis, or do we need to introduce
> an extension to the PCI DT binding to make that decision?

The PCI code currently should skip the configured devices and only touch
the not configured ones. The question is how to detect if the host bridge
has been initialised by the firmware or not.

Best regards,
Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

