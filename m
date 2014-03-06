Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaCFFDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:03:20 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:46854 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCFFDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <001a11c2fcca7727e504f3e8d518@google.com>
References: <CAOAoqGuLffRn8SgkB0967U0Qvg8HWnxvL5Uq4EZk7Vxw1jiSJw@mail.gmail.com>
	<001a11c2fcca7727e504f3e8d518@google.com>
Date: Thu, 6 Mar 2014 10:33:17 +0530
Message-ID: <CAOAoqGs_391XuB4apV+BQOXxv24=z=9qa6Muh-Ry-0PecqrUDQ@mail.gmail.com>
Subject: Re: Delivery Status Notification (Failure)
From: Jagdish Gedia <jvgediya@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for you informative reply.
I will try your suggestion. yes, i will not get more than one wakeup per second.

I have tried below things.
My usb device is using the cdc-acm.c driver.

inside cdc-acm.c file,

static struct usb_device *usb_device;

static int acm_probe(........, ....)
{
    usb_device = interface_to_usbdev(intf);
    ..........
}

inside interrupt handler

static irqhandle_t int_handler(..., ..)
{
   usb_lock_device(usb_device);
   usb_remote_wakeup(usb_device);
   usb_unlock_device(usb_device);
   return IRQ_HANDLED;
}

but these things are not working. kernel is crashing when interrupt occurs.

I have some other doubt also.

1. If usb is runtime suspended and if global suspend happens , do i
need to do anything special to wakeup the usb device?

2. How can i address particularly my usb device. right now, i am using
usb_device = interface_to_usbdev(intf) to get pointer to my usb device
inside probe function, but probe function is getting called for every
interface of the device. Is there any other way through which i can
get the pointer to my usb device like i can traverse all the available
usb device and on basis of vendor and product id i can address my usb
device or by any other way?


thanks,
jagdish gediya
