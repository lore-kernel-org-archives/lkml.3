Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaCFPZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:25:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42568 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752574AbaCFPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:25:39 -0500
Date: Thu, 6 Mar 2014 10:25:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jagdish Gedia <jvgediya@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Delivery Status Notification (Failure)
In-Reply-To: <CAOAoqGs_391XuB4apV+BQOXxv24=z=9qa6Muh-Ry-0PecqrUDQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403061022510.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Jagdish Gedia wrote:

> Hi Alan,
> 
> Thanks for you informative reply.
> I will try your suggestion. yes, i will not get more than one wakeup per second.
> 
> I have tried below things.
> My usb device is using the cdc-acm.c driver.
> 
> inside cdc-acm.c file,
> 
> static struct usb_device *usb_device;
> 
> static int acm_probe(........, ....)
> {
>     usb_device = interface_to_usbdev(intf);
>     ..........
> }
> 
> inside interrupt handler
> 
> static irqhandle_t int_handler(..., ..)
> {
>    usb_lock_device(usb_device);
>    usb_remote_wakeup(usb_device);
>    usb_unlock_device(usb_device);
>    return IRQ_HANDLED;
> }
> 
> but these things are not working. kernel is crashing when interrupt occurs.

Because you didn't do what I said: Call pm_request_resume.  Not 
usb_remote_wakeup.

> I have some other doubt also.
> 
> 1. If usb is runtime suspended and if global suspend happens , do i
> need to do anything special to wakeup the usb device?

No.

> 2. How can i address particularly my usb device. right now, i am using
> usb_device = interface_to_usbdev(intf) to get pointer to my usb device
> inside probe function,

That's a perfectly good way to do it.  Lots of other drivers do the 
same thing.

>  but probe function is getting called for every
> interface of the device. Is there any other way through which i can
> get the pointer to my usb device like i can traverse all the available
> usb device and on basis of vendor and product id i can address my usb
> device or by any other way?

You can't get the device pointer unless you have something to start 
from.  For example, if you already have an interface pointer then you 
can use interface_to_usbdev.

Alan Stern

