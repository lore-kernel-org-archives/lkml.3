Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3KKQsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:48:42 -0500
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:35369 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3KKQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:48:29 -0500
Message-ID: <1384188485.19117.90.camel@kazak.uk.xensource.com>
Subject: Re: [linux-sunxi] [PATCH 2/2] ARM: sun6i: Add SMP support for the
 Allwinner A31
From: Ian Campbell <ijc@hellion.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 16:48:05 +0000
In-Reply-To: <20131110100312.GI26440@lukather>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
	 <1383583997.8826.123.camel@kazak.uk.xensource.com>
	 <20131108084056.GB26440@lukather>
	 <1383906355.3189.77.camel@kazak.uk.xensource.com>
	 <20131110100312.GI26440@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-10 at 11:03 +0100, Maxime Ripard wrote:
> Hi Ian,
> 
> On Fri, Nov 08, 2013 at 10:25:55AM +0000, Ian Campbell wrote:
> > On Fri, 2013-11-08 at 09:40 +0100, Maxime Ripard wrote:
> > > > I'm trying to work out if we can make this work with the requirement
> > > > which both Xen and KVM have to enter the kernel in NS-HYP mode.
> > > > 
> > > > The way this works on e.g. vexpress is (roughly) that u-boot wakes up
> > > > the secondary CPUs from the lowlevel firmware and places them into its
> > > > own holding pen, which has the same wake up protocol as the firmware so
> > > > the kernel can just use the same code. If u-boot never gets to run on
> > > > secondary CPUs that isn't going to help much. 
> > > > 
> > > > My concern is that the sequence here appears to involve resetting the
> > > > secondary CPU, which I figure will probably defeat that strategy by
> > > > kicking the CPU back into the lowlevel firmware in the reset state,
> > > > meaning it can't be done by a u-boot only change.
> > > 
> > > I think this is where we're headed for the A20, Marc was interested in
> > > doing that,
> > 
> > Marc Zyngier is that?
> 
> Ah yes. I forgot to put it in CC...
> 
> > >  since we already have pretty much this in u-boot already,
> > > however, this is not the case for the A31.
> > 
> > > As far as I know, the Allwinner's bootloader that we currently use
> > > isn't bringing up the secondary CPUs, and we don't have any port of
> > > some sort of u-boot yet that we could work on.
> > 
> > Ah, OK. I'd assumed that A20 and A31 (indeed, most sunxi platforms) were
> > mostly equivalent as far as u-boot support went.
> 
> No. The A31 has no current support at all in u-boot(-sunxi, that is),
> so the only bootloader we can use is Allwinner's one.
> 
> It's one my TODO list somewhere, but as usual, time is lacking :)
> 
> > > So, I guess we don't really have much choice in that case, even though
> > > eventually I'd like to have this for the A31 too.
> > 
> > Right, I suppose it makes sense to consider what we want to do on the
> > A20 now and keep in mind that A31 may want to follow in the future.
> > 
> > > > Hrm, what to do ... perhaps a DT driven selection between this mechanism
> > > > and sev to kick a wfe loop reading the private register?
> > > 
> > > We can discuss this whenever we will actually have that choice to
> > > make, but maybe a kernel parameter would be better?
> > 
> > I don't think so -- u-boot would then have to munge the command line to
> > say that it had/had not brought up secondaries. DTB seems more natural
> > to me. e.g. on ARMv8 there is already a requirement to provide a per-CPU
> > property describing the bringup protocol ("PSCI" and "spintable" are the
> > options there).
> 
> Then I guess we can assume that we have to do all the CPU bring up
> work if this property is missing?

Yes, I think that is a fair enough assumption.

> > Anyway, once I get to the point of being able to do something I'll
> > coordinate with Marc etc and figure out what to do. In the meantime I
> > think having the kernel do the bringup (like this patch does) is
> > sensible. It's very likely to be what we want to do in the absence of
> > any instruction to the contrary (DTB or otherwise) in the future anyway.
> 
> Yep.
> 
> A part from the discussion on the approach, do you have any comments
> on the patches themselves?

I know approximately diddly about how one is supposed to bring up these
processors, but I did correlate what you were doing as best I could with
the A20 manual for the registers and it looked sensible to me, modulo
the fact that I was looking at the manual for a slightly different
processor ;-)

Not a terribly strong statement, sorry.

Ian.

