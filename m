Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3HAHhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:37:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3HAHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:37:00 -0400
Date: Thu, 1 Aug 2013 15:32:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: Re: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Message-ID: <20130801073240.GA5419@kroah.com>
References: <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
 <20130724202957.GA14913@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE76B1B@HASMSX106.ger.corp.intel.com>
 <20130728153155.GA6781@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77A4E@HASMSX106.ger.corp.intel.com>
 <20130729223805.GA9677@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77AB9@HASMSX106.ger.corp.intel.com>
 <20130729231724.GA10863@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE7AC90@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE7AC90@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 07:21:30AM +0000, Winkler, Tomas wrote:
> > 
> > On Mon, Jul 29, 2013 at 11:08:52PM +0000, Winkler, Tomas wrote:
> > > How do I add new device specific sysfs in non-race way if my entry
> > > point is the pci probe function.
> > 
> > You do it in the device creation for the device you add below the PCI device
> > in sysfs, by setting the groups field in the device.
> > 
> > You don't create files in the sysfs directory for the PCI device itself, those are
> > owned by the PCI bus core.
> > 
> > This is why you are your own "bus" here, use it :)
> 
> > If you still have questions, how about we take it to code, post what you have,
> > and I'll see what needs to be changed.
> > 
> > hope this helps,
> 
> Right but this is not related to mei_cl_bus,  which is an abstraction
> in MEI protocol level, I wanted to augment the pci device.

Then do that in the pci core :)

> We'd I've tried to expose is the FW status register from pci config
> space, (I' know the pci config space Is already exposed through syfs),
> the issue is that the  offset of the registers changes between
> different HW, so I wished that there Is a sysfs entry called fw_status
> always points to the correct offset.  An application that tries to
> query fw status can be oblivious to underlying HW SKU. 
> 
> I guess that sysfs is not good interface for that now.  I will just
> resend the two other patches w/o sysfs 

No, you would be adding "random" files to a pci device in sysfs, how
would userspace ever know about something like this?

If this is a PCI-standard thing, then add it to the PCI core please.
Otherwise, it belongs on your "controller" as it is a child of the PCI
device, and should be able to live there just fine.

thanks,

greg k-h
