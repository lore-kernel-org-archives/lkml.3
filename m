Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJPFYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:24:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35098 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJPFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:52 -0400
Date: Thu, 16 Oct 2014 07:24:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>, x86@kernel.org, aubrey.li@linux.intel.com
Subject: Re: [Patch v2] x86: Make Atom PMC driver configurable.
Message-ID: <20141016052448.GB14796@gmail.com>
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
 <20141015145924.GA21199@redhat.com>
 <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
 <20141016021859.GA12042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016021859.GA12042@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> The Atom PMC driver is always built-in, regardless of whether
> the kernel being built is going to be run on an Atom (or even Intel) CPU.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Cc: aubrey.li@linux.intel.com
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e88e07c..b4dfd96aeea8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2485,7 +2485,8 @@ config X86_DMA_REMAP
>  	depends on STA2X11
>  
>  config PMC_ATOM
> -	def_bool y
> +	tristate "Intel Atom SOC power management controller driver"
> +	default y
>          depends on PCI
>  

So what I think should happen is to decouple of the 'must work' 
features from the optional debug features in this 'driver': the 
Atom SoC power-off quirk should be made unconditional, as long as 
the .config is Atom-supported (CPU_SUP_INTEL I guess).

All the other bits, such as the debugfs interface, should be in a 
separately and appropriately named config option, 
CONFIG_X86_INTEL_ATOM_PMC_DEBUG=y or so, with 'default n'.

The file should probably be split up, the quirk moved into one of 
the generic quirk files, while pmc_atom.c should have the debugfs 
interface.

That way we don't break anyone and remove the unnecessary code as 
well. It's also a nice clean up.

Thanks,

	Ingo
