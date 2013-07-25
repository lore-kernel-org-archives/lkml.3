Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3GYVih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:38:37 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:53084 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab3GYVi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:38:29 -0400
Date: Thu, 25 Jul 2013 15:37:53 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130725213753.GC17616@obsidianresearch.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725184834.GA8296@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 08:48:34PM +0200, Richard Cochran wrote:
> On Thu, Jul 25, 2013 at 07:29:20PM +0100, Mark Rutland wrote:
> > On Thu, Jul 25, 2013 at 07:05:48PM +0100, Stephen Warren wrote:
> > > 
> > > I don't think having people "rely" on the bindings is the issue so much
> > > as the awareness that if they do, there will be compatibility issues for
> > > unstable bindings.
> > 
> > As long as we can make sufficiently clear that trying to use an unstable
> > binding is going to be *very* painful, and not necessarily supported.
> 
> Oh, man.
> 
> The introduction of DT into ARM Linux was supposed to make everyone's
> life sooo much easier. Of course, based on experience with powerpc, I
> never believed it*, but still I would expect to hear that the DT
> bindings are, well, a *binding* contract between the board developer,
> boot loader, and the kernel.

To restate a perspective I've shared before (as someone shipping
embedded products with DT on PPC and ARM).

We use DT has a kernel configuration input. Our environment is
designed to guarantee 100% that the kernel and DT match exactly. DT
very deliberately isn't an ABI boundary in our systems.

We've been doing this for years and have a proven in the field track
record of upgrades from pre-2.6.16 to 3.7 and beyond with multiple
SOCs. The same bootloader that was shipped to support non-DT 2.6.16
boots DT 3.7 just fine.

For closed system embedded DT has proven *WONDERFUL*. It is a huge,
gigantic improvement over what we had before. The introduction of DT
carried with it an increase in generality and configurability that has
gone far beyond what was possible using just board.c files (back in
the 2.6.teens days).

This is where I see the value in DT. ABI stability is not something I
want/need from DT. As an ODM we have dramatically less board specific
code than ever before, and new code we need is upstreamable as DT
elements.

IMHO, this is a fine and very reasonable way to use DT in embedded.

To me, it is general purpose stuff (Chromebooks, ARM servers, etc)
where the main problem is. I think those cases need a different
solution: A subset of DT that is guarenteed ABI stable, firmware that
substantially sets up the entire machine, and the proper callback
hooks (eg through UEFI and AHCI) to let the firmware do low level
hardware specific work at runtime.

This is how x86 gets the kind of compatability it has. Trying to
describe and control every tiny detail (pin mux, regulator, clk) is
great for embedded, but fundamentally not future-proof enough for
general purpose.

Regards,
Jason
