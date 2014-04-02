Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaDBSYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:24:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbaDBSYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:24:05 -0400
Date: Wed, 2 Apr 2014 11:26:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][next] phy: core: make NULL a valid phy reference if
 !CONFIG_GENERIC_PHY
Message-ID: <20140402182626.GA24594@kroah.com>
References: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com>
 <20140313152024.GF4599@saruman.home>
 <20140313214450.GG27355@saruman.home>
 <533C4E8F.20306@ti.com>
 <20140402181655.GB23998@kroah.com>
 <533C542F.4020608@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533C542F.4020608@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 02:17:19PM -0400, Santosh Shilimkar wrote:
> On Wednesday 02 April 2014 02:16 PM, Greg KH wrote:
> > On Wed, Apr 02, 2014 at 01:53:19PM -0400, Santosh Shilimkar wrote:
> >> On Thursday 13 March 2014 05:44 PM, Felipe Balbi wrote:
> >>> Hi,
> >>>
> >>> On Thu, Mar 13, 2014 at 10:20:24AM -0500, Felipe Balbi wrote:
> >>>> On Thu, Mar 13, 2014 at 01:11:13PM +0200, Grygorii Strashko wrote:
> >>>>> This fixes a regression on Keystone 2 platforms caused by patch
> >>>>> 57303488cd37da58263e842de134dc65f7c626d5
> >>>>> "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
> >>>>> optional support of generic phy in DWC3 core.
> >>>>>
> >>>>> On Keystone 2 platforms the USB is not working now because
> >>>>> CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
> >>>>> return -ENOSYS always. The log shows:
> >>>>>  dwc3 2690000.dwc3: failed to initialize core
> >>>>>  dwc3: probe of 2690000.dwc3 failed with error -38
> >>>>>
> >>>>> Hence, fix it by making NULL a valid phy reference in Generic PHY
> >>>>> APIs stubs in the same way as it was done by the patch
> >>>>> 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
> >>>>> a valid phy reference".
> >>>>>
> >>>>> CC: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>> CC: Felipe Balbi <balbi@ti.com>
> >>>>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>>>
> >>>> nice :-)
> >>>>
> >>>> Acked-by: Felipe Balbi <balbi@ti.com>
> >>>
> >>> Greg, if your tree isn't closed yet, could you consider this patch still
> >>> for v3.15 merge window ? Grygorii found a regression on Keystone
> >>> platforms which this patch fixes. Let me know if you need the original
> >>> patch and myself or Kishon can send it to you.
> >>>
> >> Just checking whether the fix was picked up for the 3.14 merge window ?
> > 
> > 3.14 is long released, the merge window for that was months ago.
> > 
> Sorry for the typo. I mean for upcoming v3.15 merge window.

My trees are now "empty" now, with everything I had for the 3.15-rc1
merge window already in Linus's tree.  So I suggest looking there to see
if this made it in or not.

If not, be sure to resend it.

thanks,

greg k-h
