Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3BUEaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:30:03 -0500
Received: from relais.videotron.ca ([24.201.245.36]:48656 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3BUEaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:30:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 20 Feb 2013 23:29:58 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
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
In-reply-to: <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
Message-id: <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
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
 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
 <1361367842.13482.279.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
 <1361372008.13482.280.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
 <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Kim Phillips wrote:

> On Wed, 20 Feb 2013 10:43:18 -0500
> Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > On Wed, 20 Feb 2013, Woodhouse, David wrote:
> > > On Wed, 2013-02-20 at 09:06 -0500, Nicolas Pitre wrote:
> > > > ... in which case there is no harm shipping a .c file and trivially 
> > > > enforcing -O2, the rest being equal.
> > > 
> > > For today's compilers, unless the wind changes.
> > 
> > We'll adapt if necessary.  Going with -O2 should remain pretty safe anyway.
> 
> Alas, not so for gcc 4.4 - I had forgotten I had tested
> Ubuntu/Linaro 4.4.7-1ubuntu2 here:
> 
> https://patchwork.kernel.org/patch/2101491/
> 
> add -O2 to that test script and gcc 4.4 *always* emits calls to
> __bswap[sd]i2, even with -march=armv6k+.

Crap.  OK, assembly code is the way to go then.

> I'll try working on an assembly version given it probably
> makes more sense, future-gcc-immunity-wise.

Agreed.


Nicolas
