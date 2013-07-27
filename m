Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab3G0Iss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 04:48:48 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64366 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3G0Isn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 04:48:43 -0400
Date: Sat, 27 Jul 2013 10:48:26 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
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
Message-ID: <20130727084825.GA4707@netboy>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726171524.GB28895@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:15:24AM -0600, Jason Gunthorpe wrote:
> 
> Further, every other kernel release tended to break the board.c files,
> just due to the usual kernel churn.

Yes...

> DT is much better, the stuff that can be described in DT is broader
> and more thought tends to have been put into DT bindings than was put
> into the old C methods. It has less churn, and what churn there is
> seems simpler to follow.

...
 
> Of course all this could have been done in C, but it wasn't/hasn't been..

You have identified the real issue: poor quality of the ARM board
support process within the kernel. Churn is still churn, whether in DT
or in platform devices, but the DT people promised to end the churn.

At least with the platform code, I knew where to look to resolve
issues. Thanks to DT, I now have three haystacks to search, namely
boot loader, DT, and kernel.
 
[ I disagree about the "more thought" part. The current discussion,
  coming years too late after the introduction of DT to ARM Linux, is
  contrary evidence enough. ]

> Why would Freescale PPC be any different from the IBM PPC we use? We'd
> use exactly the same techniques we use on ARM and PPC today and the
> churn to the DT wouldn't be an operational problem in the field.

I always suspected that the IBM powerpc Linux code was of higher
quality. Freescale has been just awful.

And that is just the point. No one is saying that DT cannot work. In
theory (and in your experience) it is really wonderful. However, all
this talk about "one day we will offer stable binding on ARM" already
tells me what kind of quality to expect.

> Why do you think our experiences are so different?

Because the "embedded mindset" was used to develop the code on the
platforms that I have been using.

> *shrug* For embedded I am being *very pragmatic*. I don't need/want an
> ABI boundary between the DT and the kernel. I don't need the DT to
> statically describe the hardware.

Yes, I know the kind of quality to expect from the embedded vendors.
But that doesn't mean that mainline Linux should also stink.

> Well, you know why. The DT schema used by the kernel changes over
> time. Kirkwood just went through a massive change in schema in the
> past few releases, and the same was true on our PPC platforms when
> that was new.

I find the very idea to be total unacceptable. This should never
happen in the stable kernel.

> I can't delay shipping while upstream sorts this out - so I know
> *absolutely* that the DT schema will change. This has been planned for
> and designed into the boot system and won't be a problem.
> 
> Why would anyone do embedded any other way?

Yep, that is the embedded way: ship it!

We can do better than that.

Thanks,
Richard
