Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaEVT7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:59:00 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:42190 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaEVT65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:58:57 -0400
Date: Thu, 22 May 2014 22:58:12 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, linux <linux@openrisc.net>
Subject: Re: [ORLinux] [PATCH v2] openrisc: irq: use irqchip framework
Message-ID: <20140522195811.GA4761@chokladfabriken.org>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
 <20140521195056.GA14701@chokladfabriken.org>
 <537DA7F5.6010704@southpole.se>
 <CAMuHMdX6s1yYpwVoRiQYr2F5MTKqgSFLzVRniw6QYHgUmG7KBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX6s1yYpwVoRiQYr2F5MTKqgSFLzVRniw6QYHgUmG7KBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:48:00AM +0200, Geert Uytterhoeven wrote:
> On Thu, May 22, 2014 at 9:32 AM, Jonas Bonn <jonas@southpole.se> wrote:
> > On 05/21/2014 09:50 PM, Stefan Kristiansson wrote:
> >> I see two paths to go to get there though, and here's where I'd like some input.
> >> 1) Define the three different implementations as seperate irqchips,
> >>    with accompanying IRQCHIP_DECLARE.
> >> 2) Add custom device-tree bindings and determine the chip type from that.
> >
> > I think 1) above is the way to go.  Something alone the lines of
> > "opencores,or1k-pic-level", "opencores,or1k-pic-edge", and
> > "opencores,or1200-pic".
> 
> Sounds fine to me. The only thing I'm still wondering about is whether
> to have both "opencores,or1k-pic-*" variants, or just ""opencores,or1k-pic"
> and an (optional) property for edge/level selection.
> 
> Is edge support planned to stay in future versions of the specifications?
> If not, go with the optional property to select edge.
> If yes, have two variants.
> 

There have been no discussion about removing the edge triggered options.

Adding an optional property would afaict in practice be option 2),
as we would need to add a custom device-tree binding for it.
There are the pre-existing 'flags' in the 'interrupts' binding,
but it has slighty different semantics, since it is per interrupt-line and
not per interrupt controller.
Besides, using that property would mean that we would need to change
#interrupt-cells from 1 to 2, which would break pre-existing device-tree
descriptions.

> > The first two match the behaviour of the or1k specification; the third
> > one, however, is really a misimplementation of the spec and is kind of
> > tied to the actual implementation of the OR1200... I wonder if we don't
> > need to version this one like we version the CPU identifier (*-rtlsvnXXXXX).
> 
> Is this planned to be fixed for OR1200?
> If yes, how? If this will be done by switching to the version that follows the
> or1k spec, the compatible value in DT can just be changed to one of the
> "opencores,or1k-pic-*" variants.
> 

I agree, I think the or1200-pic identifier is enough to mark the "special" pic.
If the or1200 would be fixed, it certainly be according to the or1k spec.
But, apart from the or1200 itself, there are other implementations
(e.g. mor1kx) that can be configured to be "or1200 pic compatible",
to enable them to be suitable as drop-in replacements.

Stefan
