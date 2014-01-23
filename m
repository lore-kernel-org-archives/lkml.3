Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaAWToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:44:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaAWToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:44:20 -0500
Date: Thu, 23 Jan 2014 11:45:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        navinp@cdac.in, linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        tulinizer@gmail.com, stern@rowland.harvard.edu,
        yacine.belkadi.1@gmail.com, ke42caxa@cip.cs.fau.de
Subject: Re: [PATCH] staging: usbip: convert usbip-host driver to
 usb_device_driver
Message-ID: <20140123194510.GA10745@kroah.com>
References: <1390502206-28684-1-git-send-email-valentina.manea.m@gmail.com>
 <20140123190944.GA11639@kroah.com>
 <CABdoFFeC=S6raty6d6+4sfm4zk7jiF-XnBKgxzTmEzmf6wX3CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdoFFeC=S6raty6d6+4sfm4zk7jiF-XnBKgxzTmEzmf6wX3CA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:37:28PM +0200, Valentina Manea wrote:
> On Thu, Jan 23, 2014 at 9:09 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jan 23, 2014 at 08:36:46PM +0200, Valentina Manea wrote:
> >> This driver was previously an interface driver. Since USB/IP
> >> exports a whole device, not just an interface, it would make
> >> sense to be a device driver.
> >>
> >> This patch also modifies the way userspace sees and uses a
> >> shared device - dealing with interfaces is no longer required.
> >
> > In what way is this modified?  What is now different?
> >
> 
> 1. The usbip_status file is no longer created for interface 0, but for
> the whole device (such as
> /sys/devices/pci0000:00/0000:00:01.2/usb1/1-1/usbip_status).
> 2. Per interface information, such as interface class or protocol, is
> no longer sent/received. Only device specific information is
> transmitted.
> 3. Since the driver was moved one level below in the USB architecture,
> there is no need to bind/unbind each interface, just the device as a
> whole.

Please say all of this in your changelog entry :)

thanks,

greg k-h
