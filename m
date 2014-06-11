Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaFKTG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:06:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:06:27 -0400
Date: Wed, 11 Jun 2014 12:10:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Chen <peter.chen@freescale.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611191017.GA15120@kroah.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com>
 <20140611032322.GB25082@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611032322.GB25082@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:23:23AM +0800, Peter Chen wrote:
> On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > On Wed, Jun 11, 2014 at 10:14:40AM +0800, Peter Chen wrote:
> > > Hi Greg,
> > > 
> > > Currently, we can't disable auto probe function during booting
> > > if both device and device driver register code are built in due
> > > to .drivers_autoprobe is a private value for bus core and this
> > > value can only be changed by sys entry.
> > 
> > Then don't build them into the kernel :)
> > 
> > > It causes we can't implement feature that the user can choose
> > > manual binding and auto binding through module parameters.
> > 
> > Wait, you just asked about building the stuff into the kernel, not a
> > module.
> 
> Yes, build the code into the kernel.
> > 
> > > Eg, the default binding is automatic, but the user can override
> > > it by module parameter.
> > 
> > Do we do that for any other "bus" anywhere?
> 
> I don't know.
> 
> > 
> > > Let's take USB peripheral as an example, there is a device for
> > > udc, and a device driver for usb gadget driver, at default, we want
> > > the device to be bound to driver automatically, this is what
> > > we have done now. But if there are more than one udcs and gadget
> > > drivers (eg one B port for mass storage, another B port for usb ethernet),
> > > the user may want to have specific binding (eg, udc-0 -> mass storage,
> > > udc-1 -> usb ethernet), so the binding will be established
> > > after rootfs has mounted. (This feature is implementing)
> > 
> > Then there better be a way to describe this on the kernel command line
> > (i.e. module paramaters), right?  Which is a total mess, why not just
> > not bind anything in this case and let the user pick what they want?
> 
> If the user is used to do nothing at rootfs for current or earlier kernel,
> Is it ok we change the driver's behaviour and a sys entry is mandatory
> for user?

We can't break existing systems, so I don't understand the issue here.
Just don't configure your kernel for a system you don't have / want,
right?

> > > From what I read code, we can't implement above feature, but I may
> > > be wrong, if you have some solutions, give me some hints please.
> > > If there is no solution for above feature, do we agree with exporting
> > > .drivers_autoprobe for bus driver or something similar?
> > 
> > I don't understand what you mean by this, care to show me with code?
> 
> I mean the individual bus driver can't change bus->p->drivers_autoprobe?
> bus->p->drivers_autoprobe is handled at drivers/base/bus.c.
> 
> If the individual bus driver can change bus->p->drivers_autoprobe, we
> can disable autoprobe (auto-binding) during booting.

No, that's a core only thing.

greg k-h
