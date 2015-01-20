Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbbATNJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:09:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:48646 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbATNJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:09:30 -0500
Date: Tue, 20 Jan 2015 14:08:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] irqchip: add dumb demultiplexer implementation
In-Reply-To: <CAL_JsqLCkU0TA5YCa2h+NyaXxG2vDpGSaNqveAr9XcnFDfuRXA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501201356370.5526@nanos>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com> <1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com> <CAL_JsqJ5DSo6jmAuHPDdV6pMca8BVbg5V-GZ5=2qu96_QYXMtQ@mail.gmail.com> <alpine.DEB.2.11.1501141110190.5526@nanos>
 <CAL_JsqLwBvV5s531_YsA=sCE4_LG=eXTua8mh069ufRjSNFhng@mail.gmail.com> <alpine.DEB.2.11.1501151003430.5526@nanos> <CAL_JsqLCkU0TA5YCa2h+NyaXxG2vDpGSaNqveAr9XcnFDfuRXA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Rob Herring wrote:
> On Thu, Jan 15, 2015 at 3:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 14 Jan 2015, Rob Herring wrote:
>
> > We do not change shared interrupts in any way. We provide an
> > alternative mechanism for braindead hardware. And if the at91 folks
> > are fine with the DT change, then it's their decision. Nothing forces
> > this on everyone.
> 
> We are changing how shared interrupts are described in DT. We don't
> need 2 ways to describe them. We could say this is only for AT91 and
> continue to describe shared interrupts as has been done forever. Then
> the next platform that hits this problem will have to go thru the same
> ABI breakage. Or we change DT practices to describe all shared
> interrupts with a demux node. Given the way DTs are incrementally
> created, it is not something we can check with review or tools, so we
> will still have the same ABI breakage problem.

This is not describing the proper shared interrupts. This is a special
case for a special case of braindamaged hardware. Whats wrong with
doing that? We dont have to change that for all shared interrupts
because 99% of them have a proper hardware implementation and are not
affected by this.

What's wrong with serving the AT91 with a proper solution, which does
NOT inflict horrible hacks into the core code and does NOT weaken
sanity checks and does NOT require irq chip specific knowledge in
device drivers?

> >> There are probably ways to do this demux irqchip without a DT change.

So far you have not provided any useful hint how to do so.

> > What's the problem with a DT change for a single platform, if the
> > maintainers are willing to take it and deal with the fallout?
> 
> What's the solution for a platform that an ABI break is not okay and
> can't deal with the fallout?

There is no other platform affected. This is a break for a specific
set of devices and the 'fallout' is confined, well known and accepted.

So what's your problem, really?

Thanks,

	tglx
 
