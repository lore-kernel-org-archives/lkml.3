Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaEUUYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:24:12 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:41525 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaEUUYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:24:11 -0400
Date: Wed, 21 May 2014 23:23:31 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux@openrisc.net, jonas@southpole.se
Subject: Re: [PATCH v2] openrisc: irq: use irqchip framework
Message-ID: <20140521202330.GB14701@chokladfabriken.org>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
 <20140521195056.GA14701@chokladfabriken.org>
 <20140521200156.GJ8664@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521200156.GJ8664@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:01:56PM -0400, Jason Cooper wrote:
> On Wed, May 21, 2014 at 10:50:57PM +0300, Stefan Kristiansson wrote:
> ...
> > I see two paths to go to get there though, and here's where I'd like some input.
> > 1) Define the three different implementations as seperate irqchips,
> >    with accompanying IRQCHIP_DECLARE.
> > 2) Add custom device-tree bindings and determine the chip type from that.
> > 
> > What would be the best choice here?
> > I think I'm leaning towards 1) and I have a tentative patch for that,
> > but I wanted to went the question before posting it.
> 
> Are there actually three IP blocks here that we may see separately
> somewhere else?
> 

Not exactly, the interrupt controller is embedded inside the OpenRISC cpu.
But, the interrupt controller can either be edge or level triggered
(and this is a fixed setting for the whole controller).
And in addition to that, there is one implementation of the interrupt controller
that have some additional quirks, like level interrupts need to be acked,
and the polarity of the ack signal is negated to what the specification says.

And there's no (sane) way to detect what kind of controller is implemented
in the cpu, so it has to be 'user-provided'
(read, provided from the device-tree).

Stefan
