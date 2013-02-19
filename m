Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3BSNcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:32:46 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36821 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab3BSNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130213093907.GM20996@sortiz-mobl>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
	<20130212212935.GJ20996@sortiz-mobl>
	<20130212213823.GA20745@kroah.com>
	<201302122309.01176.arnd@arndb.de>
	<20130213093907.GM20996@sortiz-mobl>
Date: Tue, 19 Feb 2013 15:32:44 +0200
X-Google-Sender-Auth: MIOlsLPRROOLyRhLLLuIFXu6pdk
Message-ID: <CA+i0qc6G83xsakt4FVzV1+=b6MVS9C73rE6+3Wmf1R8gs7rH1A@mail.gmail.com>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
From: Tomas Winkler <tomas.winkler@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:39 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> On Tue, Feb 12, 2013 at 11:09:00PM +0000, Arnd Bergmann wrote:
> > On Tuesday 12 February 2013, gregkh@linuxfoundation.org wrote:
> > > >
> > > > > Please let's find something that makes both hw and Linux happy
> > > > I still believe it makes sense to use mei_device for what we add to the MEI
> > > > bus. I'd be fine with mei_bus_device as well, but that would somehow look
> > > > a bit awkward. Greg, Arnd, any preference ?
> > >
> > > "mei_device" works the best for me.  Tomas, what you think of as a "MEI
> > > Device" really is a "MEI Controller", it bridges the difference between
> > > the PCI bus and your new MEI bus, so you will need to start thinking of
> > > these things a bit differently now that you have created your own little
> > > virtual bus.
> >
> > Yes, I agree. mei_bus_device would also work as the name for the controller,
> > but not for the devices attached to it IMO.
> Tomas, I propose to switch to mei_controller instead of mei_host and keep the
> mei_device name for the devices we attach to the MEI bus.
> Does that work for you ?
>

The issue is that when we added our virtual bus we haven't gave up on
/dev/mei backed by mei_device
This is the interface, defined in linux/mei.h  which user space
applications use to connect to ME Clients within ME device.
Any ME client can be connected through this interface and we have few
legacy applications running for few years that use this interface so
we are not going to break them.

What we've done now is we added a virtual bus so also in-kernel
applications/subsystems can more naturally connect to the ME Clients,
this connection is client specific.  So the device that connect to the
bus is not an mei device but mei client device hence the name I've
proposed mei_cl_device.

Does it make sense?


Thanks
>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
