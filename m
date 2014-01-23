Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaAWUGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:06:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41167 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967AbaAWUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:06:04 -0500
Date: Thu, 23 Jan 2014 15:06:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valentina Manea <valentina.manea.m@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        <devel@driverdev.osuosl.org>, <navinp@cdac.in>,
        <linux-usb@vger.kernel.org>, <ly80toro@cip.cs.fau.de>,
        <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        <tulinizer@gmail.com>, <yacine.belkadi.1@gmail.com>,
        <ke42caxa@cip.cs.fau.de>
Subject: Re: [PATCH] staging: usbip: convert usbip-host driver to usb_device_driver
In-Reply-To: <CABdoFFeC=S6raty6d6+4sfm4zk7jiF-XnBKgxzTmEzmf6wX3CA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1401231502010.891-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Valentina Manea wrote:

> 1. The usbip_status file is no longer created for interface 0, but for
> the whole device (such as
> /sys/devices/pci0000:00/0000:00:01.2/usb1/1-1/usbip_status).
> 2. Per interface information, such as interface class or protocol, is
> no longer sent/received. Only device specific information is
> transmitted.
> 3. Since the driver was moved one level below in the USB architecture,
> there is no need to bind/unbind each interface, just the device as a
> whole.

If you don't bind the interfaces, they will naturally bind to their 
normal drivers on the host.  You probably don't want that to happen.  
(Although, at the moment, I don't see how you can prevent it.)

Also, in your patch, stub_probe() calls usb_choose_configuration().  
Shouldn't that be done by the client, since the client now has access 
to the entire device?

Alan Stern

