Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaJOQUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:20:54 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:59857 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaJOQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:20:52 -0400
Date: Wed, 15 Oct 2014 17:20:30 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org, aubrey.li@linux.intel.com
Subject: Re: x86: Make Atom PMC driver configurable.
Message-ID: <20141015172030.6bb3c522@alan.etchedpixels.co.uk>
In-Reply-To: <20141015145924.GA21199@redhat.com>
References: <20141015144603.GA19944@redhat.com>
	<20141015145245.GB11511@saruman>
	<20141015145924.GA21199@redhat.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 10:59:24 -0400
Dave Jones <davej@redhat.com> wrote:

> On Wed, Oct 15, 2014 at 09:52:45AM -0500, Felipe Balbi wrote:
>  > Hi,
>  > 
>  > On Wed, Oct 15, 2014 at 10:46:03AM -0400, Dave Jones wrote:
>  > > The Atom PMC driver is always built-in, regardless of whether
>  > > the kernel being built is going to be run on an Atom (or even Intel) CPU.
>  > > 
>  > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > > 
>  > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>  > > index f2327e88e07c..04280177c1e2 100644
>  > > --- a/arch/x86/Kconfig
>  > > +++ b/arch/x86/Kconfig
>  > > @@ -2485,7 +2485,7 @@ config X86_DMA_REMAP
>  > >  	depends on STA2X11
>  > >  
>  > >  config PMC_ATOM
>  > > -	def_bool y
>  > > +	tristate "Intel Atom SOC power management controller driver"
>  > 
>  > looks like you should still have this as default y just to make sure you
>  > a simple defconfig still enables this as it did before.
>  
> I could, but why should this be default y ? There's no real
> justification to inflict this on everyone, given atom is at best
> a niche area of x86.

Possibly because you work for an enterprise vendor. Atom is not remotely
niche to everyone else.

This really does want to be a default Y for X86 at least, although I can
see that for the enterprise market you probably don't care quite so much
right now. Without that you are going to break a lot of users
configurations in a deeply surprising way.

Alan
