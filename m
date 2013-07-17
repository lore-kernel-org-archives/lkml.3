Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3GQRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:21:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3GQRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:21:49 -0400
Date: Wed, 17 Jul 2013 09:35:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Rong Wang <wr011235813@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong.Wang@csr.com
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130717163548.GA14999@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com>
 <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
 <20130717075706.GC5291@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717075706.GC5291@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:57:06AM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> > > The question is since we default GADGET, so the g_mass_storage.ko is
> > > installed early but connecting to a host PC
> > > is randomly, But the udev has no idea when a host PC connects our device.
> > > 
> > > So we consider it's reasonable to let the udev know the GADGET device state.
> > > Is there any alternative to our question?
> > 
> > I thought we already export events for gadget device states, have you
> > looked for them?  I can't dig through the code at the moment, but this
> > seems like a pretty common issue...
> > 
> > Felipe, any ideas?
> 
> we already expose that in sysfs. IIRC udev can act on sysfs changes,
> no ?

If something is polling the sysfs file, yes.  If not, a change event
should be sent to notify people that they need to go re-read it as
something major happened (laptop docked, disk got removed, device
changed state, etc.)

thanks,

greg k-h
