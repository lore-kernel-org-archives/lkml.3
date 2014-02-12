Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaBLO1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:27:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaBLO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:27:36 -0500
Date: Wed, 12 Feb 2014 06:29:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 1 of 1]: musb: fixed a potential NULL pointer dereference.
Message-ID: <20140212142945.GA9172@kroah.com>
References: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:08:22AM +0100, Dr. H. Nikolaus Schaller wrote:
> fixed a potential NULL pointer dereference.
>     
>     Rationale:
>     this is the only location in the musb driver where the
>     otg->gadget pointer is dereferenced. Assuming that it
>     is never NULL is not only potentially unsafe but was
>     observed in the wild on a GTA04 (OMAP3/TPS65950 based
>     board) when trying to boot a device tree based 3.14-rc2
>     kernel with USB cable plugged in.
>     
>     DT boot appears to modify the order in which components
>     (gadget driver) are loaded and linked and therefore
>     an early musb interrupt triggers with a NULL gadget
>     pointer ending in a kernel panic.
>     
>     Since a non-existing gadget can never be "active" we
>     simply use a 0 value for musb->is_active.
>     
>     Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Please don't attach patches, our tools don't like them at all.

And shouldn't we fix the root problem here, not just gloss over the fact
that this pointer is NULL at this point in time?  Fixing the real issue
should be the correct solution, right?

thanks,

greg k-h
