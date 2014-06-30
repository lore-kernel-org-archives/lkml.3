Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbaF3T31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:29:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46146 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbaF3T3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:29:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18pxxHxtgXAVXvA7bLLifvN+C+PpLaS9Jk=
X-DKIM: OpenDKIM Filter v2.0.1 titan DD00F59EA23
Date: Mon, 30 Jun 2014 15:29:10 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        santosh.shilimkar@ti.com, joe@perches.com, tglx@linutronix.de
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Message-ID: <20140630192910.GA23978@titan.lakedaemon.net>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:40:18PM +0530, Sricharan R wrote:
> This series does some cleanups, fixes for handling two interrupts
> getting mapped twice to same crossbar and provides support for
> hardwired IRQ and crossbar definitions.
> 
> On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
> 131, 132, 133 are direct wired to hardware blocks bypassing
> crossbar. This quirky implementation is *NOT* supposed to be the
> expectation of crossbar hardware usage. This series adds support
> to represent such hard-wired irqs through DT and avoid generic
> allocation/programming of crossbar in the driver.
> 
> This way of supporting hard-wired irqs was a result of
> the below discussions.
> http://www.spinics.net/lists/arm-kernel/msg329946.html
> 
> Based on 3.16 rc2 mainline.
> 
> All the patches are available here
>  git@github.com:Sricharanti/sricharan.git crossbar_updates
> 
> The fixes series[1] earlier posted is merged in to this.
> [1] http://www.spinics.net/lists/arm-kernel/msg328273.html
> 
> [V2] Merged the above series and rebased on 3.15 mainline
> 
> [V3] Modified patch#3 to get irqs-skip properties from DT,
>      merged path#8 for checkpatch warning to other relevant
>      patches and fixed comments for other patches.
> 
> [V4] Based on 3.16rc2 and fixed Jason's <jason@lakedaemon.net> comments.
> 
> Nishanth Menon (14):
>   irqchip: crossbar: Dont use '0' to mark reserved interrupts
>   irqchip: crossbar: Check for premapped crossbar before allocating
>   irqchip: crossbar: Introduce ti,irqs-skip to skip irqs that bypass
>     crossbar
>   irqchip: crossbar: Initialise the crossbar with a safe value
>   irqchip: crossbar: Change allocation logic by reversing search for
>     free irqs
>   irqchip: crossbar: Remove IS_ERR_VALUE check
>   irqchip: crossbar: Fix sparse and checkpatch warnings
>   irqchip: crossbar: Fix kerneldoc warning
>   irqchip: crossbar: Return proper error value
>   irqchip: crossbar: Change the goto naming
>   irqchip: crossbar: Introduce ti,max-crossbar-sources to identify
>     valid crossbar mapping
>   irqchip: crossbar: Introduce centralized check for crossbar write
>   documentation: dt: omap: crossbar: Add description for interrupt
>     consumer
>   irqchip: crossbar: Allow for quirky hardware with direct hardwiring
>     of GIC
> 
> Sricharan R (2):
>   irqchip: crossbar: Set cb pointer to null in case of error
>   irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap callback
> 
>  .../devicetree/bindings/arm/omap/crossbar.txt      |   36 +++++
>  drivers/irqchip/irq-crossbar.c                     |  168 +++++++++++++++++---
>  2 files changed, 179 insertions(+), 25 deletions(-)

Whole series applied to irqchip/crossbar, I'll give it a day or two in
-next, then I'll merge it into irqchip/core.

Tony: Right now, it's immutable unless you tell me I applied something
incorrectly.  Once it goes into irqchip/core, it's immutable no matter
what you say. ;-)

thx,

Jason.
