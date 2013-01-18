Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab3ARFj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:39:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13365 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3ARFj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:39:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Jan 2013 21:39:26 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 18 Jan 2013 11:09:22 +0530
Subject: RE: [PATCH v2 4/4] usb: Add APIs to access host registers from
 Tegra PHY
Thread-Topic: [PATCH v2 4/4] usb: Add APIs to access host registers from
 Tegra PHY
Thread-Index: Ac30zEH87TvLHcF+Q36GVDpqh28+mwAcOhqA
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1A6F108A@BGMAIL02.nvidia.com>
References: <20130117153229.GA21904@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1301171054220.1339-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301171054220.1339-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, January 17, 2013 9:34 PM
> To: Felipe Balbi
> Cc: Venu Byravarasu; gregkh@linuxfoundation.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> swarren@wwwdotorg.org; linux-tegra@vger.kernel.org
> Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
> PHY
> 
> On Thu, 17 Jan 2013, Felipe Balbi wrote:
> 
> > On Thu, Jan 17, 2013 at 10:21:53AM -0500, Alan Stern wrote:
> > > On Thu, 17 Jan 2013, Felipe Balbi wrote:
> > >
> > > > > Bits 31 & 30 from PORTSC register were allocated by our SOC
> designers
> > > > > to inform the host controller about the PHY type to be used.
> > > >
> > > > Wow, that's something you should never do. PORTSC register belongs
> to
> > > > the EHCI controller and those bits are reserved for future use and they
> > > > *MUST* return zero. I wouldn't be surprised if current EHCI driver
> > > > assumes those bits will be zero and/or makes sure they're set to zero
> > > > when writing to PORTSC register.
> > >
> > > In fact, those bits _have_ been assigned an official purpose in the
> > > EHCI-1.1 addendum.  Presumably the Tegra hardware only supports
> > > EHCI-1.0.
> >
> > I see, they're used for device addresses now.
> >
> > How can we make sure on Tegra systems we won't use those top two bits ?
> 
> ehci-hcd doesn't use those device address bits at all.  They are meant
> for the LPM (Link Power Management) extension, which ehci-hcd doesn't
> support.  Even if support gets added in the future, we'll know that the
> LPM capability isn't present unless bit 17 in the HCCPARAMS register is
> set.
> 
> On the other hand, what I wrote earlier about not overwriting those
> bits wasn't quite correct.  ehci-hcd _does_ overwrite them with 0's
> during shutdown or removal.  I don't know if this will matter for the
> Tegra platform.

This should not cause any issue to Tegra platform, as these bits are set
during PHY power on.

> 
> Alan Stern

