Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3ANRSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:18:21 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:10624 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757673Ab3ANRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:18:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/heiVBVYlvdQbRWgiqpLfc
Date: Mon, 14 Jan 2013 09:18:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, sameo@linux.intel.com,
        kishon@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/14] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
Message-ID: <20130114171814.GT14149@atomide.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
 <1357836694-30788-2-git-send-email-rogerq@ti.com>
 <20130110234537.GB15458@atomide.com>
 <50EFDE10.9080902@ti.com>
 <20130111181331.GM14149@atomide.com>
 <50F3EBEF.8040809@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3EBEF.8040809@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130114 03:31]:
> On 01/11/2013 08:13 PM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [130111 01:43]:
> >> Tony,
> >>
> >> On 01/11/2013 01:45 AM, Tony Lindgren wrote:
> >>> * Roger Quadros <rogerq@ti.com> [130110 08:54]:
> >>>> Let's have a single platform data structure for the OMAP's High-Speed
> >>>> USB host subsystem instead of having 3 separate ones i.e. one for
> >>>> board data, one for USB Host (UHH) module and one for USB-TLL module.
> >>>>
> >>>> This makes the code much simpler and avoids creating multiple copies of
> >>>> platform data.
> >>>
> >>> I can apply just this patch alone into an immutable branch that
> >>> we all can merge in as needed as long as we have acks for the USB
> >>> and MFD parts.
> >>>
> >>> Or does this one need to be changed based on Alan's comments
> >>> on the EHCI lib related changes?
> >>>
> >>
> >> This does not depend on EHCI lib based changes but it depends on the
> >> OMAP USB Host cleanup series posted earlier.
> > 
> > Can we first apply just the minimal platform_data + board file + clock
> > changes?
> > 
> We could, but I'll then have to make changes to the patches in the first
> series and re-post them. Do you want me to do that?

Yes please. Otherwise we'll unnecessarily complicate the dependencies between 
arch/arm/*omap* code and the drivers. And we've certainly had enough of
self-inflicted merge conflicts with the omap usb code already :)
 
> > That way I can apply those to some immutable tree for everybody to use,
> > and we cut off the dependency to the driver changes for the rest of the
> > patches. And then I'm off the hook for the rest of the patches :)
> > 
> 
> Or you could just ack this patch ;). The platform data is specific to
> USB host only :)

Well it's not just this patch. It's the clock related patches in your
earlier seriers that will conflict with any attempts to move the clock
data to live under drivers/clk/omap where it needs to go. And the three
patches at the end of this series to add platform data (which look fine),
but will likely conflict with something else. Let's try do do these changes
in a way where the dependencies are cut to minimum where possible.

Regards,

Tony
