Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3FLJGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:06:23 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61934 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FLJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:06:18 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Fix locking vs. interrupts
To: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <alpine.LFD.2.02.1306121023150.22970@ionos>
References: <1371015544.8250.182.camel@pasglop> <alpine.LFD.2.02.1306121023150.22970@ionos>
Date: Wed, 12 Jun 2013 10:06:12 +0100
Message-Id: <20130612090612.7E4ED3E0A56@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 10:25:56 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 12 Jun 2013, Benjamin Herrenschmidt wrote:
> 
> > The OF code uses irqsafe locks everywhere except in a handful of functions
> > for no obvious reasons. Since the conversion from the old rwlocks, this
> > now triggers lockdep warnings when used at interrupt time. At least one
> > driver (ibmvscsi) seems to be doing that from softirq context.
> > 
> > This converts the few non-irqsafe locks into irqsafe ones, making them
> > consistent with the rest of the code.
> 
> Fun. https://lkml.org/lkml/2013/2/4/416 seems to have got lost 
>  
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: <stable@vger.kernel.org> [v3.9+]
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> > ---
> > 
> > Note: It's silly to access the device-tree at interrupt time in most cases,
> > and we should probably fix ibmvscsi, but for the time being, let's fix the
> 
> Right.
> 
> > obvious bug. Thomas, this can probably still go into 3.10... If not, I've
> > CCed stable.
> 
> Should go through Grant I think.

Applied, thanks.

g.

