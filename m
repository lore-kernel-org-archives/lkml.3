Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3JAIk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:40:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63517 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab3JAIkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:40:23 -0400
Date: Tue, 1 Oct 2013 09:40:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Suman Anna <s-anna@ti.com>
Cc: Kumar Gala <galak@codeaurora.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 2/9] hwspinlock/omap: add support for dt nodes
Message-ID: <20131001084015.GH22259@e106331-lin.cambridge.arm.com>
References: <cover.1379445653.git.s-anna@ti.com>
 <0fd6a11880894260d627a50b1e35f363625e9b1d.1379445653.git.s-anna@ti.com>
 <AE597DCC-83D7-4BCD-8990-3D63540F32EA@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE597DCC-83D7-4BCD-8990-3D63540F32EA@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Fri, Sep 27, 2013 at 05:06:38PM +0100, Kumar Gala wrote:
> 
> On Sep 17, 2013, at 2:30 PM, Suman Anna wrote:
> 
> > HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> > which are all device-tree boot only. This patch adds the
> > base support for parsing the DT nodes, and removes the code
> > dealing with the traditional platform device instantiation.
> > 
> > Signed-off-by: Suman Anna <s-anna@ti.com>
> > ---
> > .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 31 +++++++++++
> > arch/arm/mach-omap2/Makefile                       |  3 --
> > arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
> > drivers/hwspinlock/omap_hwspinlock.c               | 23 +++++++--
> > 4 files changed, 50 insertions(+), 67 deletions(-)
> > create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> > delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
> > 
> > diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> > new file mode 100644
> > index 0000000..235b7c5
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> > @@ -0,0 +1,31 @@
> > +OMAP4+ HwSpinlock Driver
> > +========================
> > +
> > +Required properties:
> > +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
> > +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs

"Currently supports" is not something I expect to see in a binding
document. That sounds like a description of the driver rather than the
binding.

How similar are these hardware modules? What are the differences?

> > +- reg:			Contains the hwspinlock register address range (base
> > +			address and length)

Is there only one register bank for the hwlock module?

> > +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
> > +
> > +Common hwlock properties:
> > +The following describes the usage of the common hwlock properties (defined in
> > +Documentation/devicetree/bindings/hwlock/hwlock.txt) on OMAP.
> > +
> > +- hwlock-base-id:	There are currently no OMAP SoCs with multiple
> > +			hwspinlock devices. The OMAP driver uses a default
> > +			base id value of 0 for the locks present within the
> > +			single hwspinlock device on all SoCs.


Driver details should not leak into bindngs...

As mentioned in the other patch, I don't think this is the way to handle
this. I think we need a phandle + args representation.

> > +- hwlock-num-locks:	This property is not required on OMAP SoCs, since the
> > +			number of locks present within a device can be deduced
> > +			from the SPINLOCK_SYSSTATUS device register.

Huh? Why define this property at all here if we don't need it and don't
use it?

The common document should state that specific bindings may use it and
should explicitly state if they do, rather than stating they don't...

Cheers,
Mark.
