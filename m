Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKEBbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:31:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:3417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaKEBbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="626675914"
Date: Tue, 4 Nov 2014 17:31:12 -0800
From: sostalle <sean.stalley@intel.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 00/10] MA USB drivers cover letter
Message-ID: <20141105013112.GA5611@sean.stalley.intel.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <877fzbs5lb.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877fzbs5lb.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[with a valid Message-ID]

On Tue, Nov 04, 2014 at 10:00:32AM +0100, Bjørn Mork wrote:
> [added linux-usb@vger.kernel.org Cc]
> 
> Stephanie Wallick <stephanie.s.wallick@intel.com> writes:
> 
> > Media Agnostic (MA) USB enables the USB protocol to be used over a wide
> > range of physical media. MA USB is a relatively new protocol and is
> > currently unsupported in the Linux kernel. This patch set adds the
> > following drivers with the following capabilities:
> >
> > 1) MA USB Host:
> >         - provides functionality of a USB Host Controller.
> >         - implements MA USB protocol for a MA USB host.
> >         - provides MA USB packet transport over TCP
> >
> > 2) MA USB Device:
> >         - provides functionality of a USB Device Controller.
> >         - implements MA USB protocol for a MA USB device.
> >         - provides MA USB packet transport over TCP
> 
> Nice.  But don't you think this deserves the attention of the linux-usb
> mailing list?  Yes, Greg's attention is of course good to have too :-)
> But  I believe this is of interest to more people, who might not read
> everything on linux-kernel.


This is probably more relevant/interesting to the people on linux-usb.
Since we were trying to get this driver into staging, we thought linux-kernel
was the right place to send the patches. We can send the next set out to
linux-usb as well.


> Has there been any thought/discussion about the relationship to the
> existing usbip drivers, which just moved out of staging? Is a usbip
> userspace compatibility layer feasible sometime in the future?

 
That discussion hasn't happened. usbip has a different protocol than MA USB,
so much of the code cannot be reused.

I just briefly looked into the userspace code for usbip. It looks like the
userspace compatibility layer is just a utility for establishing the TCP
connection between the host and device & choosing what devices to connect,
correct? We have a similar utility (see patch 9/10) which could probably
be replaced by the usbip userspace utilities.

Thanks,
Sean
