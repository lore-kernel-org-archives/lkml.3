Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaKOV3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:29:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49229 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754498AbaKOV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:29:19 -0500
Date: Sat, 15 Nov 2014 16:29:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
In-Reply-To: <20141114224829.GA2980@sean.stalley.intel.com>
Message-ID: <Pine.LNX.4.44L0.1411151626120.11758-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Sean O. Stalley wrote:

> To summarize the spec:
> MA USB groups a host & connected devices into MA service sets (MSS).
> The architectural limit is 254 MA devices per MSS.
> 
> If the host needs to connect more devices than that, It can start a
> new MSS and connect to 254 more MA devices.
> 
> 
> 
> Is supporting up to 254 devices on one machine sufficient?

It's probably more than enough.

> Would it make sense (and does the usb stack support) having 254 root
> ports on one host controller? If so, we could make our host
> controller instance have 254 ports. I'm guessing the hub driver may have
> a problem with this (especially for superspeed).

The USB stack is likely to have problems if there are more than 31 
ports on any hub.

> If that doesn't make sense (or isn't supported), we can have 1 host
> controller instance per MA device. Would that be preferred?

It doesn't make much difference.  Whatever you think will be easier to 
support.  You might check and see how usbip does it.

> > Also, I noticed that your patch adds a new bus type for these MA host 
> > controllers.  It really seems like overkill to have a whole new bus 
> > type if there's only going to be one device on it.
> 
> The bus was added when we were quickly trying to replace the platform
> device code. It's probably not the right thing to do.
> 
> I'm still not sure why we can't make our hcd a platform device,
> especially since dummy_hcd & the usbip's hcd are both platform devices.

A platform device is the right way to go.

Alan Stern

