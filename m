Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab3GZN1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:27:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28603 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3GZN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:27:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18gd7KV8t4OGy81cte4uSL7PWyHZWAiDio=
Date: Fri, 26 Jul 2013 09:27:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Richard Cochran <richardcochran@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130726132709.GH29916@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726130927.GC4219@netboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:
> On Fri, Jul 26, 2013 at 10:42:24AM +0100, David Woodhouse wrote:
> > On Fri, 2013-07-26 at 10:01 +0200, Richard Cochran wrote:
> > > On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:
> > > > 
> > > > We use DT has a kernel configuration input. Our environment is
> > > > designed to guarantee 100% that the kernel and DT match exactly. DT
> > > > very deliberately isn't an ABI boundary in our systems.
> > > 
> > > Think about what you just said.
> > > 
> > > The DT describes the *hardware* not the kernel. Why should you ever
> > > need to update your DT at all?
> > 
> > Well, the nodes which describe hardware devices, according to the
> > bindings which form an ABI contract between DT and drivers, should not
> > normally change. Although they *can* change, if for example you change
> > the MAC address and that's stored there. Or you change the PHY you want
> > it to use. Or something like that. The *ABI* doesn't change, but the
> > data you express *using* that ABI can change. That's kind of the point.
> 
> Unless I totally misunderstood, the thread is talking about letting
> established bindings change with each new kernel version.  I am
> opposed to that.
> 
> Of course, a user may want to change the values of his MAC addresses,
> if he needs to. But he should never have to change *how* he specifies
> those addresses.

The other dynamic change that bears mentioning here is attributes which
have been configured by the bootloader.  For example, in mvebu, we have
the Schrodinger's Cat register.  It allows you to reconfigure the base
address of the registers from *within* that register range.  If the
bootloader does this, the DT needs to be updated to reflect the current
hardware configuration.  Otherwise, the kernel is stuck poking around at
memory addresses hoping to find something sane.

But this falls into the same category as you mentioned, but outside of
chosen {};.

> So, as long as everyone can agree to the principle that a working DT
> should remain working after a kernel upgrade, then I'll shut up. In
> actual fact, this is not the case today, nor was it ever so in the
> past, AFAICT, but it never hurts to set goals.

Some instability is necessary as we figure out what 'stable' is.
Otherwise, things would've been so rigid, we'd've never made any
progress.  I'd say we now a sufficient body of code and experience to
start enforcing the goal.

thx,

Jason.
