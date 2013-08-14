Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3HNTrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:47:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760214Ab3HNTrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:47:46 -0400
Date: Wed, 14 Aug 2013 12:47:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, tobetter@gmail.com, patches@linaro.org
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
Message-ID: <20130814194744.GA28373@kroah.com>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
 <20130814182239.GC23847@kroah.com>
 <20130814190410.GO2401@sirena.org.uk>
 <20130814191513.GA24873@kroah.com>
 <20130814193950.GQ2401@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814193950.GQ2401@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:39:50PM +0100, Mark Brown wrote:
> > > We can't just treat it as a PHY (which is the obvious workaroud) since
> > > we do also need to use the built
> > > in PHY in the SoC.
> 
> > There has to be some type of resource that it can grab, as obviously
> > it's failing to work properly unless that resource is present.  Just
> 
> That resource is the USB bus I think (I suspect the issue is that the
> fact that power is always present confuses the USB enumeration protocol
> if the device gets brought out of reset prior to the bus being live).

Which USB bus is it?  How is this device even probed before the device
is found by the bus?

Ah crud, this is an i2c driver, not a USB driver, no wonder I'm
confused...

You are going to have to find some kind of relationship here, not just
by linker order, otherwise you are going to have problems later on.

> The normal way to grab that resource would be to make the device a
> device on the bus but currently the only way USB gets children is via
> USB enumeration.

Perhaps make this device a child of the USB controller in the DT
description?

> > messing with the init order isn't going to solve any problem if the
> > driver is built as a module, as nothing guarantees module load order.
> 
> Right, and I did discuss that with Tushar elsehwere prior to this being
> posted here.  We figured given how cheap and non-invasive the workaround
> is it was worth just doing it.

Nope, sorry, I'm not going to take it.

> > So this patch wouldn't really solve the problem, only paper over it for
> > one type of configuration (i.e. driver built into the system), right?
> 
> Yes, though realistically nobody actually does that for the relevant
> systems and if they do it's always possible to control the module load
> order if you really want to.

But you aren't telling anyone that is what is needed.  How would anyone
know that they need to control the load order?

thanks,

greg k-h
