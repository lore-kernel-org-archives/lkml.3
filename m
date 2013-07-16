Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab3GPQWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:22:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3GPQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:22:12 -0400
Date: Mon, 15 Jul 2013 23:31:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rong Wang <wr011235813@gmail.com>
Cc: balbi@ti.com, Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130716063117.GA30320@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com>
 <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:49:07AM +0800, Rong Wang wrote:
> Hi Greg,
> 
> The USB on our platform can change roles between HOST and GADGET, but
> it is not capable of OTG.

That kind of sounds like the definition of OTG :)

> When the USB changes between roles the udev will run some scripts
> automatically according to the udev rules.

What exactly does udev/userspace see when the roles change?

And what can trigger the change in roles?

> The default role is GADGET, and we bind the g_mass_storage to the USB
> GADGET role.
> 
> We should secure the back end file storage between the device and the
> host PC connecting to our device.
> We need to know when the GADGET is really connect to a host PC, then
> we can umount the file on the device
> and export it to the g_mass_storage.

I thought you already get an event for this, otherwise no one would be
able to properly deal with this.

> The question is since we default GADGET, so the g_mass_storage.ko is
> installed early but connecting to a host PC
> is randomly, But the udev has no idea when a host PC connects our device.
> 
> So we consider it's reasonable to let the udev know the GADGET device state.
> Is there any alternative to our question?

I thought we already export events for gadget device states, have you
looked for them?  I can't dig through the code at the moment, but this
seems like a pretty common issue...

Felipe, any ideas?

greg k-h
