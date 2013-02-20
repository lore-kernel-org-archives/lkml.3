Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869Ab3BTK5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:57:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:3018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934056Ab3BTK5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:57:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="288159375"
Date: Wed, 20 Feb 2013 11:57:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Message-ID: <20130220105731.GT18295@sortiz-mobl>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
 <20130212212935.GJ20996@sortiz-mobl>
 <20130212213823.GA20745@kroah.com>
 <201302122309.01176.arnd@arndb.de>
 <20130213093907.GM20996@sortiz-mobl>
 <CA+i0qc6G83xsakt4FVzV1+=b6MVS9C73rE6+3Wmf1R8gs7rH1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i0qc6G83xsakt4FVzV1+=b6MVS9C73rE6+3Wmf1R8gs7rH1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 03:32:44PM +0200, Tomas Winkler wrote:
> On Wed, Feb 13, 2013 at 11:39 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> >
> > On Tue, Feb 12, 2013 at 11:09:00PM +0000, Arnd Bergmann wrote:
> > > On Tuesday 12 February 2013, gregkh@linuxfoundation.org wrote:
> > > > >
> > > > > > Please let's find something that makes both hw and Linux happy
> > > > > I still believe it makes sense to use mei_device for what we add to the MEI
> > > > > bus. I'd be fine with mei_bus_device as well, but that would somehow look
> > > > > a bit awkward. Greg, Arnd, any preference ?
> > > >
> > > > "mei_device" works the best for me.  Tomas, what you think of as a "MEI
> > > > Device" really is a "MEI Controller", it bridges the difference between
> > > > the PCI bus and your new MEI bus, so you will need to start thinking of
> > > > these things a bit differently now that you have created your own little
> > > > virtual bus.
> > >
> > > Yes, I agree. mei_bus_device would also work as the name for the controller,
> > > but not for the devices attached to it IMO.
> > Tomas, I propose to switch to mei_controller instead of mei_host and keep the
> > mei_device name for the devices we attach to the MEI bus.
> > Does that work for you ?
> >
> 
> The issue is that when we added our virtual bus we haven't gave up on
> /dev/mei backed by mei_device
> This is the interface, defined in linux/mei.h  which user space
> applications use to connect to ME Clients within ME device.
> Any ME client can be connected through this interface and we have few
> legacy applications running for few years that use this interface so
> we are not going to break them.
> 
> What we've done now is we added a virtual bus so also in-kernel
> applications/subsystems can more naturally connect to the ME Clients,
> this connection is client specific.  So the device that connect to the
> bus is not an mei device but mei client device hence the name I've
> proposed mei_cl_device.
I don't have a strong opinion here, so that would be fine with me.
Greg, Arnd, would mei_cl_device and mei_cl_driver be an acceptable compromise?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
