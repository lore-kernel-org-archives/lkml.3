Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab3GRGYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:24:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3GRGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:24:41 -0400
Date: Wed, 17 Jul 2013 23:24:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, sylvester.nawrocki@gmail.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        akpm@linux-foundation.org, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, benoit.cousson@linaro.org, mchehab@redhat.com,
        cesarb@cesarb.net, davem@davemloft.net, rnayak@ti.com,
        shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com, balajitk@ti.com, george.cherian@ti.com
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
Message-ID: <20130718062447.GA19997@kroah.com>
References: <1372247257-30186-1-git-send-email-kishon@ti.com>
 <1372247257-30186-2-git-send-email-kishon@ti.com>
 <20130717062944.GA24968@kroah.com>
 <51E664CB.8050906@ti.com>
 <20130717172510.GB17093@kroah.com>
 <51E78525.9000802@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E78525.9000802@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:33:17AM +0530, Kishon Vijay Abraham I wrote:
> >> Wanted to group all the PHY drivers to be used by different subsystems
> >> (SATA/USB/PCIE/HDMI/VIDEO) into a single entity. There were some comments in my
> >> initial version [3] on using a bus_type instead of class but then it was
> >> decided to go with class itself.
> >>
> >> [3] -> http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/01389.html
> > 
> > Ok, but what does the class usage get you?
> 
> hmm.. actually I use class only to iterate through the list of devices in *phy*
> class which could very well be implemented using list. Just that I wont have a
> /sys/class/phy/ entry to find the list of phys added in the system. I dont
> think I want to add any other stuff to expose to the user space at this point
> of time.
> > 
> >>> When modifying/adding new sysfs stuff, you need a Documentation/ABI/
> >>> entry as well.
> >>
> >> I'm not actually adding any new sysfs entry other than what a *class_create*
> >> must have created. Do I need to add one for that?
> > 
> > If you are not creating anything in sysfs at all, why use the driver
> > model?  (hint, I think you need to do something here to justify it...)
> 
> Well.. it helps me to use pm_runtime to enable clocks utilizing the
> parent-child relationship.

Ok, that's a good reason for this, nevermind then.  Care to send the
latest patches you have in emails so I can review them?

thanks,

greg k-h
