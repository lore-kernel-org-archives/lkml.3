Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3AQQDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:03:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33224 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757060Ab3AQQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:03:44 -0500
Date: Thu, 17 Jan 2013 11:03:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
In-Reply-To: <20130117153229.GA21904@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1301171054220.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Felipe Balbi wrote:

> On Thu, Jan 17, 2013 at 10:21:53AM -0500, Alan Stern wrote:
> > On Thu, 17 Jan 2013, Felipe Balbi wrote:
> > 
> > > > Bits 31 & 30 from PORTSC register were allocated by our SOC designers
> > > > to inform the host controller about the PHY type to be used. 
> > > 
> > > Wow, that's something you should never do. PORTSC register belongs to
> > > the EHCI controller and those bits are reserved for future use and they
> > > *MUST* return zero. I wouldn't be surprised if current EHCI driver
> > > assumes those bits will be zero and/or makes sure they're set to zero
> > > when writing to PORTSC register.
> > 
> > In fact, those bits _have_ been assigned an official purpose in the 
> > EHCI-1.1 addendum.  Presumably the Tegra hardware only supports 
> > EHCI-1.0.
> 
> I see, they're used for device addresses now.
> 
> How can we make sure on Tegra systems we won't use those top two bits ?

ehci-hcd doesn't use those device address bits at all.  They are meant
for the LPM (Link Power Management) extension, which ehci-hcd doesn't
support.  Even if support gets added in the future, we'll know that the
LPM capability isn't present unless bit 17 in the HCCPARAMS register is
set.

On the other hand, what I wrote earlier about not overwriting those 
bits wasn't quite correct.  ehci-hcd _does_ overwrite them with 0's 
during shutdown or removal.  I don't know if this will matter for the 
Tegra platform.

Alan Stern

