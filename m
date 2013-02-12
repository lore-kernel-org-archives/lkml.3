Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3BLVif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:38:35 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59511 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3BLVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:38:27 -0500
Date: Tue, 12 Feb 2013 13:38:23 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Message-ID: <20130212213823.GA20745@kroah.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
 <1360694222-27632-2-git-send-email-sameo@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B01ECF4E9@HASMSX106.ger.corp.intel.com>
 <20130212212935.GJ20996@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212212935.GJ20996@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 10:29:35PM +0100, Samuel Ortiz wrote:
> Hi Tomas,
> 
> On Tue, Feb 12, 2013 at 09:17:21PM +0000, Winkler, Tomas wrote:
> > 
> > 
> > > In preparation for the MEI bus code merge, we rename the mei_device
> > > structure to mei_host.
> > > struct mei_device will be used for devices on the MEI bus in order to follow
> > > exisiting driver model implementations practices.
> > > 
> > I'd like to NACK this name, we use  'host' for the host part of the MEI protocol, 
> > 
> > You can use the mei_controller, mei_adapter, and  I'm not sure what else can come into mind.
> mei_controller sounds good to me.
> 
> 
> > I prefer not to break the HW spec language.  I prefer to leave it mei_device as after all it's a device on pci bus it's not a pure host controller.
> > And call what is on the mei  bus mei_cl_dev or mei_app_dev . From the HW perspective it actually 
> > talks to a client/application residing inside MEI device, it is not always a physical device like NFC.
> > 
> The bus is not physical neither. It's really items that we add to this bus,
> watchdog could be the next candidate for example.
> 
> > Please let's find something that makes both hw and Linux happy
> I still believe it makes sense to use mei_device for what we add to the MEI
> bus. I'd be fine with mei_bus_device as well, but that would somehow look
> a bit awkward. Greg, Arnd, any preference ?

"mei_device" works the best for me.  Tomas, what you think of as a "MEI
Device" really is a "MEI Controller", it bridges the difference between
the PCI bus and your new MEI bus, so you will need to start thinking of
these things a bit differently now that you have created your own little
virtual bus.

thanks,

greg k-h
