Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbaD3T1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:27:54 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41049 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbaD3T1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:27:52 -0400
Date: Wed, 30 Apr 2014 23:27:45 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Li Yang <leoli@freescale.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140430192745.GI3876@home.lan>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com> <20140430160625.GF23679@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430160625.GF23679@saruman.home>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for the review.

On Wed, Apr 30, 2014 at 11:06:25AM -0500, Felipe Balbi wrote:
> On Thu, Apr 24, 2014 at 12:54:13PM +0400, Paul Fertser wrote:
> > If VBUS is already present during the driver initialisation, the
> 
> s/initialisation/initialization

If I'm understanding [1] properly, both spelling variants are correct.

> > +	/* Now let it settle a bit and sense VBUS */
> > +	msleep_interruptible(1);
> > +	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
> > +		udc_controller->vbus_active = 1;
> 
> good fix, should this go to stable ?

I was reluctant to Cc stable because I'm not sure which versions need
to be fixed, as I've seen an earlier version (3.0 something or a bit
before that probably) working without this (no idea why); also I'm not
sure about that msleep as it's deduced solely from experimenting with
a particular i.MX model, I hoped someone from Freescale would comment
on it. I've seen your review [2] on a related patch and my fix should
have been obvious to Suresh (and trivial to test on different boards),
yet he didn't implement it, that worries me a bit.

[1] https://en.wikipedia.org/wiki/American_and_British_English_spelling_differences#-ise.2C_-ize_.28-isation.2C_-ization.29
[2] https://patchwork.kernel.org/patch/3822321/
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
