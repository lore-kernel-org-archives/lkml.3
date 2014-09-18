Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaIRShT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:37:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50836 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352AbaIRShR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:37:17 -0400
Date: Thu, 18 Sep 2014 19:36:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] devicetree: cadence_ttc: Document binding for timer
 width
Message-ID: <20140918183626.GB10911@leverpostej>
References: <3537996136ec435ea660da869102d0a019214979.1410964243.git.michal.simek@xilinx.com>
 <20140917161737.GA7983@leverpostej>
 <db43281a-06bc-436b-a082-212d1f95d974@BL2FFO11FD034.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db43281a-06bc-436b-a082-212d1f95d974@BL2FFO11FD034.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 06:07:40AM +0100, Michal Simek wrote:
> On 09/17/2014 06:17 PM, Mark Rutland wrote:
> > On Wed, Sep 17, 2014 at 03:30:49PM +0100, Michal Simek wrote:
> >> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> >>
> >> Modern TTC implementations can extend the timer width to 32 bit. This
> >> feature is not self identifying so the driver needs to be made aware
> >> via device tree.
> >>
> >> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >> ---
> >>
> >>  Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
> >> index 993695c659e1..5439976eca6b 100644
> >> --- a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
> >> +++ b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
> >> @@ -6,6 +6,9 @@ Required properties:
> >>  - interrupts : A list of 3 interrupts; one per timer channel.
> >>  - clocks: phandle to the source clock
> >>
> >> +Optional properties:
> >> +- timer-width: Bit width of the timer. Either 16 or 32 (default 16).
> > 
> > Are we expecting TTC implementations with widths other than 16 or 32?
> 
> IRC if you use 32bit timer and setup for example 24bit width it should work
> too and you are just ignoring that upper bits.

Sure, but what I'd like to know is whether we expect HW implementations
other than 16 or 32 bit rather than whether or not the driver will work
in that case. I'm not saying no to this patch; I'm just curious.

> > This looks sane to me, but we might be able to just have a 32-bit-timer
> > property if we don't expect arbitrary widths.
> 
> Definitely model different timer width is easily possible to do in qemu
> that's why I think having more generic property timer-width is just better than
> having property used just for one case.

Ok, so if you want to support that can we change the documentation
wording to be:

- timer-width: Bit width of the timer, necessary if not 16.

That implies support for other bit widths, and when the property needs
to be set (IMO 'default' sounds too much like a driver description than
a contract description).

Does this apply to one timer register, or are multiple registers
affected?

Mark.
