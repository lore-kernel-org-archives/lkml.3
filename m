Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAPQsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:48:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23754 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaAPQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:48:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YXR8wH86jXapCOy6M1jUKvlVgj+3EtUs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8520750BFE6
Date: Thu, 16 Jan 2014 11:48:33 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: orion: provide C-style interrupt handler for
 MULTI_IRQ_HANDLER
Message-ID: <20140116164833.GH29184@titan.lakedaemon.net>
References: <1389775235.10695.51.camel@dagon.hellion.org.uk>
 <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Thu, Jan 16, 2014 at 09:10:31AM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Marvell Kirkwood and Dove SoCs make use of an irqchip
> driver. As expected for irqchip drivers, it uses a C-style
> interrupt handler and therefore selects MULTI_IRQ_HANDLER.
> 
> Now, compiling a kernel with both non-DT and DT support enabled,
> selecting MULTI_IRQ_HANDLER will break ASM irq handler used by
> non-DT boards.
> 
> Therefore, we provide a C-style irq handler even for non-DT boards,
> if MULTI_IRQ_HANDLER is set. By installing the C-style irq handler
> in orion_irq_init this is transparent to all non-DT board files.
> 
> While the regression report was filed on Marvell Kirkwood, also
> Marvell Dove non-DT boards are affected and fixed by this patch.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Ian Campbell <ijc@hellion.org.uk>
> Reported-by: Ian Campbell <ijc@hellion.org.uk>
> Fixes: 2326f04321a9 ("ARM: kirkwood: convert to DT irqchip and clocksource")
> Fixes: f07d73e33d0e ("ARM: dove: convert to DT irqchip and clocksource")
> ---
> Compared to the two patch version sent on Ian's regression report,
> I cooked this down to a single patch only touching plat-orion/irq.c.
> I also dropped Orion5x and MV78x00, as they not yet select MULTI_IRQ_HANDLER
> at all. Instead I added a comment about taking care of them, as soon as
> they move over to an irqchip driver themselves.
> 
> I have not yet Cc'ed this patch to -stable to get some discussion and
> an Acked-by from Jason or Andrew, too.
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ian Campbell <ijc@hellion.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/plat-orion/irq.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)

Applied to mvebu/fixes with Andrew's Ack.  It's too late for v3.13, so
it'll be the first thing sent for v3.14.

thx,

Jason.
