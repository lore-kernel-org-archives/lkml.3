Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518Ab3GaT3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:29:41 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37337 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3GaT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:29:39 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: mbizon@freebox.fr, Mark Rutland <mark.rutland@arm.com>,
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
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
Date: Wed, 31 Jul 2013 21:29:35 +0200
Message-ID: <1409617.9untvfnOTJ@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130731191209.GA8027@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 of July 2013 21:12:09 Richard Cochran wrote:
> On Wed, Jul 31, 2013 at 05:23:35PM +0200, Tomasz Figa wrote:
> > I said it many, many times, that a) and b) I proposed are just two
> > extremes. It is unlikely that an extreme solution will be the best
> > option to choose. I am strongly for something in the middle, just
> > like I wrote in several of my previous replies.
> > 
> > This is something that should be commented, not those extreme options.
> 
> We are saying that pursuing a) is useless because it adds pain and
> complexity without adding benefit. I simply don't buy your argument
> that DT makes a better platform data, but that is besides the point.
> 
> I had said, think about the users.  You said, what users?  I wrote a
> clear and concise use case.  You said, lets think about a) and b) and
> all the shades of gray in between.

I showed you two example solutions that could handle this use case without 
stable binding ABI, just to prove that b) is not the only option (even if 
it's the best one, which I continue to agree on, don't get me wrong).

I also added that the use case is not fully valid, because you can't 
magically define bindings for all future hardware, which means you can't 
support the hardware using a DTB made before stable bindings for that 
hardware have ever been introduced.

With all of this, I agreed that a DTB made for kernel 3.x, when used with 
kernel 3.y (y > x) should provide the same or greater feature set than 
used with kernel 3.x, in other words, this should cause no regressions. 
Still, for new features, you will likely need to update the DTB.

> In order to support the use case, you will have to provide a stable
> ABI. You can't have a compromise solution. At the end of the day,
> either you have a stable ABI, or you don't.
> 
> It was apparent to me that the arm/dt thing has been meandering around
> since its inception, but what was surprising is that people were doing
> this on purpose, and now they are defending this. Why can't we get a
> firm commitment on having a stable ABI?

This is exactly what are we trying to do right now. But you don't get 
stable things right away. You need some kind of process, for design, 
review, staging, stabilization, etc. Without all of this we will again 
surely end up with something pretending to be good and stable, while being 
completely useless and only a burden to support in new code.

So, again, to summarize, my view on this is as follows:
 - there is a list of best practices for binding design and existing 
   stable bindings that can be used to help for designing new bindings,
 - new bindings go through review process,
 - after positive review, such bindings gets staging status, i.e. they are 
   marked as something that could change,
 - after some period of time (we need to define this precisely) they get 
   frozen and can't be changed in a way that breaks compatibility any
   more. In other words, they become ABI.

What do you think?

Best regards,
Tomasz

