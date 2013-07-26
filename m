Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3GZNkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:40:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38711 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3GZNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:40:01 -0400
Date: Fri, 26 Jul 2013 14:38:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Richard Cochran <richardcochran@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
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
Message-ID: <20130726133802.GN24642@n2100.arm.linux.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <51F168FC.9070906@wwwdotorg.org> <20130725182920.GA24955@e106331-lin.cambridge.arm.com> <20130725184834.GA8296@netboy> <20130725213753.GC17616@obsidianresearch.com> <20130726080115.GA5436@netboy> <1374831744.2923.42.camel@shinybook.infradead.org> <20130726130927.GC4219@netboy> <20130726132709.GH29916@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726132709.GH29916@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 09:27:09AM -0400, Jason Cooper wrote:
> On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:
> > Unless I totally misunderstood, the thread is talking about letting
> > established bindings change with each new kernel version.  I am
> > opposed to that.
> > 
> > Of course, a user may want to change the values of his MAC addresses,
> > if he needs to. But he should never have to change *how* he specifies
> > those addresses.
> 
> The other dynamic change that bears mentioning here is attributes which
> have been configured by the bootloader.  For example, in mvebu, we have
> the Schrodinger's Cat register.  It allows you to reconfigure the base
> address of the registers from *within* that register range.  If the
> bootloader does this, the DT needs to be updated to reflect the current
> hardware configuration.  Otherwise, the kernel is stuck poking around at
> memory addresses hoping to find something sane.
> 
> But this falls into the same category as you mentioned, but outside of
> chosen {};.

No, this falls within the remit of "describing the hardware" and it is
certainly something that is free to change.

What should not "change" once a kernel is the method by which hardware is
described in DT.  "change" there in the sense that how it was described by
kernel 3.X should still be accepted by 3.X+n, even if 3.X+n comes up with
a much better way to describe it.

The actual data associated with those descriptions is free to change in
whatever way is necessary if the hardware itself changes due to things
being programmed differently.

Think of it as the difference between the design of an interface, and the
interface being used.  We don't mandate that the write() syscall shall
always be called for fd=1 with length=5 and bytes "Hello" in the buffer.
We mandate that the write() syscall shall be passed an integer fd, a
buffer pointer, and a length and we don't change that ever.

Think of "a better way to describe it" as introducing the writev() syscall
to supplement write() so that applications can do writes from scattered
memory locations.  We don't get rid of the write() syscall - we add to
the ABI that's already there leaving the existing interfaces with exactly
the same semantics, so that all the existing stuff continues to work as-is.
