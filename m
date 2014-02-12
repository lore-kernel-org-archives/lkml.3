Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBLQSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:18:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBLQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:17:59 -0500
Date: Wed, 12 Feb 2014 08:20:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 1 of 1]: musb: fixed a potential NULL pointer dereference.
Message-ID: <20140212162009.GA23327@kroah.com>
References: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com>
 <20140212142945.GA9172@kroah.com>
 <D56478EB-6936-4DFC-94F9-2A9A3CC217F1@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D56478EB-6936-4DFC-94F9-2A9A3CC217F1@goldelico.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 04:35:12PM +0100, Dr. H. Nikolaus Schaller wrote:
> 
> Am 12.02.2014 um 15:29 schrieb Greg Kroah-Hartman:
> 
> > On Wed, Feb 12, 2014 at 11:08:22AM +0100, Dr. H. Nikolaus Schaller wrote:
> >> fixed a potential NULL pointer dereference.
> >> 
> >>    Rationale:
> >>    this is the only location in the musb driver where the
> >>    otg->gadget pointer is dereferenced. Assuming that it
> >>    is never NULL is not only potentially unsafe but was
> >>    observed in the wild on a GTA04 (OMAP3/TPS65950 based
> >>    board) when trying to boot a device tree based 3.14-rc2
> >>    kernel with USB cable plugged in.
> >> 
> >>    DT boot appears to modify the order in which components
> >>    (gadget driver) are loaded and linked and therefore
> >>    an early musb interrupt triggers with a NULL gadget
> >>    pointer ending in a kernel panic.
> >> 
> >>    Since a non-existing gadget can never be "active" we
> >>    simply use a 0 value for musb->is_active.
> >> 
> >>    Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> > 
> > Please don't attach patches, our tools don't like them at all.
> 
> Sorry. That was by accident. Here is the patch appended.

That's better, but we need a "clean" patch to be able to apply it for
real :)

> > And shouldn't we fix the root problem here, not just gloss over the fact
> > that this pointer is NULL at this point in time?  Fixing the real issue
> > should be the correct solution, right?
> 
> Well,
> I must admit that I have no idea what the root cause could be 
> (because I neither know the musb nor the gadget subsystems)
> or if it is intended and just something in the initialization
> sequence has changed.
> 
> I have done one more test and it appears to be in a non-device-tree
> 3.14-rc1 as well. We did not see it in a 3.12.7 kernel on the same hardware.

Ah, can you run 'git bisect' to track down the real problem here?  We
don't like papering over problems like this, that doesn't help anyone
out.

thanks,

greg k-h
