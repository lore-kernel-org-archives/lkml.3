Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaJPDEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJPDE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:04:29 -0400
Date: Wed, 15 Oct 2014 23:04:10 -0400
From: Dave Jones <davej@redhat.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>, x86@kernel.org
Subject: Re: [Patch v2] x86: Make Atom PMC driver configurable.
Message-ID: <20141016030410.GA12760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Li, Aubrey" <aubrey.li@linux.intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Felipe Balbi <balbi@ti.com>, x86@kernel.org
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
 <20141015145924.GA21199@redhat.com>
 <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
 <20141016021859.GA12042@redhat.com>
 <543F34D3.2040004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F34D3.2040004@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:00:35AM +0800, Li, Aubrey wrote:
 > On 2014/10/16 10:18, Dave Jones wrote:
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
 > 
 > PMC driver provides core function like reboot, better to change to
 > bool, or did you see a scenario it can be as a module?

All the MODULE_* stuff in arch/x86/kernel/pmc_atom.c threw me off.
It could also use a help text.  I suspect you might be in a better
position than me to write one though.

	Dave

