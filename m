Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaFKEKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:10:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaFKEKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:10:07 -0400
Date: Tue, 10 Jun 2014 21:10:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Chen <peter.chen@freescale.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611041000.GB15184@kroah.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611021439.GA25082@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:14:40AM +0800, Peter Chen wrote:
> Hi Greg,
> 
> Currently, we can't disable auto probe function during booting
> if both device and device driver register code are built in due
> to .drivers_autoprobe is a private value for bus core and this
> value can only be changed by sys entry.

Then don't build them into the kernel :)

> It causes we can't implement feature that the user can choose
> manual binding and auto binding through module parameters.

Wait, you just asked about building the stuff into the kernel, not a
module.

> Eg, the default binding is automatic, but the user can override
> it by module parameter.

Do we do that for any other "bus" anywhere?

> Let's take USB peripheral as an example, there is a device for
> udc, and a device driver for usb gadget driver, at default, we want
> the device to be bound to driver automatically, this is what
> we have done now. But if there are more than one udcs and gadget
> drivers (eg one B port for mass storage, another B port for usb ethernet),
> the user may want to have specific binding (eg, udc-0 -> mass storage,
> udc-1 -> usb ethernet), so the binding will be established
> after rootfs has mounted. (This feature is implementing)

Then there better be a way to describe this on the kernel command line
(i.e. module paramaters), right?  Which is a total mess, why not just
not bind anything in this case and let the user pick what they want?

> From what I read code, we can't implement above feature, but I may
> be wrong, if you have some solutions, give me some hints please.
> If there is no solution for above feature, do we agree with exporting
> .drivers_autoprobe for bus driver or something similar?

I don't understand what you mean by this, care to show me with code?

thanks,

greg k-h
