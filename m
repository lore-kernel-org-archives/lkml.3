Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaG2PWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:22:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53570 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754298AbaG2PWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:22:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/temVxWcRZUOsLWGNUU4eU
Date: Tue, 29 Jul 2014 08:20:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140729152052.GV29045@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-30-git-send-email-balbi@ti.com>
 <20140729121425.GR29045@atomide.com>
 <20140729141522.GB17808@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729141522.GB17808@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140729 07:18]:
> Hi,
> 
> On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > > now that we don't need to support legacy board-files,
> > > we can completely switch over to a linear irq domain
> > > and make use of irq_alloc_domain_generic_chips() to
> > > allocate all generic irq chips for us.
> > 
> > This patch seems to somehow break off-idle for omap3 
> > where it no longer wakes up.
> 
> Sure your bisection is correct ? This patch just switches from legacy
> irq domain to linear irq domain.

Yes, I tried it a few times. Just enabling
retention idle hangs too with this patch.

Maybe it's omap3_prcm_irq_setup that relies on
11 + OMAP_INTC_START? There may be other such issues
remaining too but most should be already fixed up.

Regards,

Tony
