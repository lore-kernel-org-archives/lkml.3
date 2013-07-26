Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3GZPtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:49:49 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37115 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3GZPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:49:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130726141016.GF9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<51F168FC.9070906@wwwdotorg.org>
	<20130725182920.GA24955@e106331-lin.cambridge.arm.com>
	<20130725184834.GA8296@netboy>
	<20130725213753.GC17616@obsidianresearch.com>
	<20130726080115.GA5436@netboy>
	<1374831744.2923.42.camel@shinybook.infradead.org>
	<20130726130927.GC4219@netboy>
	<20130726141016.GF9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 08:49:43 -0700
Message-ID: <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 7:10 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:
>
>> Unless I totally misunderstood, the thread is talking about letting
>> established bindings change with each new kernel version.  I am
>> opposed to that.
>
> No, nobody is really saying that is a particularly good idea.  There is
> some debate about how we work out what an established binding is but
> there's no serious suggestion that we don't want stable bindings.

Yes, what Mark said -- _today_ all bindings are subject to change and
can be changed in lockstep with the kernel. This has been necessary as
part of development to sort out all of the various bootstrapping
issues across platforms.

What we're talking about is to end that mode of operation, and moving
over to locking in bindings. Device tree contents, as mentioned
elsewhere, might still be changed just like code is -- bugs are fixed,
etc. But it's time to start locking down the bindings, in particular
no longer change the established ones.

Long term, final goal is likely to be close to what Russell is saying
-- nothing should go into the kernel tree unless the binding is in a
fully stable state. However, we have a transitional period between now
and then, and even when we're at the final state there will be need to
have some sort of sandbox for development and test of future bindings.
Dealing with all that, as well as the actual process for locking in
bindings, is what needs to be sorted out.

I think we're all in agreement that bindings that change over time are
nothing but pain, but we're arguing that in circles anyway.


-Olof
