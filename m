Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbaD2Sbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:31:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52049 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756785AbaD2Sbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:31:49 -0400
Date: Tue, 29 Apr 2014 19:31:31 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Joel Fernandes <agnel.joel@gmail.com>
Cc: Joel Fernandes <joelf@ti.com>, Nishanth Menon <nm@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary
 CPU
Message-ID: <20140429183131.GF3582@e103592.cambridge.arm.com>
References: <1398191506-3741-1-git-send-email-joelf@ti.com>
 <20140428164348.GA14354@e103592.cambridge.arm.com>
 <535E8DC2.4010504@ti.com>
 <535E8E2D.1020708@ti.com>
 <20140429091725.GA3582@e103592.cambridge.arm.com>
 <D49C397D-1ABD-4882-B3F5-94F359D7552B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D49C397D-1ABD-4882-B3F5-94F359D7552B@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:36:30PM +0100, Joel Fernandes wrote:

[...]

> >> Sorry what I meant is, say its of Type function. What tells the firmware
> >> to switch to THUMB?
> >> 
> >> What's typically done is a boot address register is written by the
> >> kernel, and the firmware jumps to it after WFE.
> > 
> > Using ENTRY(x) ... ENDPROC(x) causes the symbol seen by the linker
> > for x to have the Thumb bit set if the code is Thumb.
> > 
> > This means that any reference the linker fixes up for that symbol
> > will have the Thumb bit set appropriately.  This applies to any kind
> > of reference, so code in another file that takes the address of the
> > symbol and then passes that address to the firmware should result in the
> > firmware getting an address with the Thumb bit.
> > 
> > From the firmware's point of view it just gets a raw address, but
> > the Thumb bit will now be set.  The firmware still needs to handle
> > this correctly when jumping, but from the look of the code this may
> > already work on omap3/4.  It would be interesting to know whether it
> > works on omap5.
> 
> Thanks a lot for the explanation. That makes perfect sense. I will try it and let you know if it works on OMAP5.

ARM/thumb interworking making perfect sense?  I'll have to frame that
and put it on the wall :)

objdump and nm conveniently mask off the Thumb bit from all function
addresses they print out, but if you show the symbols using readelf
instead you'll see addresses with bit 0 set for Thumb functions.


It's possible that the firmware still doesn't handle branching to Thumb
correctly, but if it does it would be nice to remove the requirement to
build an odd piece of a Thumb-2 kernel in ARM.

Cheers
---Dave
