Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaJPVzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:55:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42849 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:55:02 -0400
Date: Thu, 16 Oct 2014 14:54:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>, x86@kernel.org, aubrey.li@linux.intel.com
Subject: Re: [Patch v2] x86: Make Atom PMC driver configurable.
Message-ID: <20141016215456.GA15625@roeck-us.net>
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
 <20141015145924.GA21199@redhat.com>
 <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
 <20141016021859.GA12042@redhat.com>
 <20141016052448.GB14796@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016052448.GB14796@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 07:24:48AM +0200, Ingo Molnar wrote:
> 
> * Dave Jones <davej@redhat.com> wrote:
> 
> > The Atom PMC driver is always built-in, regardless of whether
> > the kernel being built is going to be run on an Atom (or even Intel) CPU.
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> > Cc: aubrey.li@linux.intel.com
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index f2327e88e07c..b4dfd96aeea8 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2485,7 +2485,8 @@ config X86_DMA_REMAP
> >  	depends on STA2X11
> >  
> >  config PMC_ATOM
> > -	def_bool y
> > +	tristate "Intel Atom SOC power management controller driver"
> > +	default y
> >          depends on PCI
> >  
> 
> So what I think should happen is to decouple of the 'must work' 
> features from the optional debug features in this 'driver': the 
> Atom SoC power-off quirk should be made unconditional, as long as 
> the .config is Atom-supported (CPU_SUP_INTEL I guess).
> 
> All the other bits, such as the debugfs interface, should be in a 
> separately and appropriately named config option, 
> CONFIG_X86_INTEL_ATOM_PMC_DEBUG=y or so, with 'default n'.
> 
> The file should probably be split up, the quirk moved into one of 
> the generic quirk files, while pmc_atom.c should have the debugfs 
> interface.
> 
The quirk isn't really a quirk, though. Maybe a separate poweroff driver
would make sense, similar to the other poweroff drivers in drivers/power/reset/.

It might also make sense to rework it as mfd client driver and tie it to
the lpc_ich driver, to be loaded when the lpc_ich driver is loaded.

I don't personally see a problem with making it tristate, as long as a remove
function is defined (which is not the case today). This way it would not have
to be loaded for non-Atom systems.

Guenter
