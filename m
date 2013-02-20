Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555Ab3BTNg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:36:29 -0500
Received: from relais.videotron.ca ([24.201.245.36]:45951 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab3BTNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:36:26 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 20 Feb 2013 08:36:25 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
In-reply-to: <1361356696.13482.269.camel@i7.infradead.org>
Message-id: <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
 <20130131092801.GV23505@n2100.arm.linux.org.uk>
 <20130131145947.f62474a0600848df86548b96@freescale.com>
 <20130201011712.GF23505@n2100.arm.linux.org.uk>
 <1359703995.23531.6.camel@shinybook.infradead.org>
 <20130205210436.670c62e26d2121330e87af35@freescale.com>
 <1360141322.6066.4.camel@shinybook.infradead.org>
 <20130206191905.ac8eb6743e69425f30888704@freescale.com>
 <20130207181315.GM17833@n2100.arm.linux.org.uk>
 <1360344301.6066.263.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
 <1360363233.6066.283.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
 <1361356696.13482.269.camel@i7.infradead.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Woodhouse, David wrote:

> On Tue, 2013-02-19 at 22:17 -0500, Nicolas Pitre wrote:
> > 
> > > +$(obj)/bswapsdi2.o: $(obj)/../../../../arch/$(SRCARCH)/lib/bswapsdi2.o
> > > +     $(call cmd,shipped)
> > > +
> > 
> > I don't think you can get away with this.  The decompressor code is 
> > compiled with -fpic and the main kernel is not.  Most toolchains do mark 
> > object files with some flags to prevent the link of incompatible objects 
> > together (normally pic and non pic objects are not compatible even if in 
> > this very simple case that would not matter).  Maybe you are able to 
> > link zImage successfully simply because no references to __bswap* needed 
> > to be resolved and therefore the linker didn't need to search/include 
> > that object?
> 
> This, and the issue with -Os vs. -O2, make me inclined to suggest that
> we should just provide an asm version of these functions instead of
> using the compiler.

You'll have the same issue wrt the above whether or not the source file 
is C or assembly.


Nicolas
