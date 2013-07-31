Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3GaQsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:48:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:49601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3GaQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,788,1367996400"; 
   d="scan'208";a="354990656"
Date: Wed, 31 Jul 2013 09:48:49 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH v2] usb: core: don't try to reset_device() a port that
 got just disconnected
Message-ID: <20130731164849.GB6907@xanatos>
References: <1375239080-21322-1-git-send-email-jwerner@chromium.org>
 <Pine.LNX.4.44L0.1307311041540.1546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307311041540.1546-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:43:30AM -0400, Alan Stern wrote:
> On Tue, 30 Jul 2013, Julius Werner wrote:
> 
> > The USB hub driver's event handler contains a check to catch SuperSpeed
> > devices that transitioned into the SS.Inactive state and tries to fix
> > them with a reset. It decides whether to do a plain hub port reset or
> > call the usb_reset_device() function based on whether there was a device
> > attached to the port.
> > 
> > However, there are device/hub combinations (found with a JetFlash
> > Transcend mass storage stick (8564:1000) on the root hub of an Intel
> > LynxPoint PCH) which can transition to the SS.Inactive state on
> > disconnect (and stay there long enough for the host to notice). In this
> > case, above-mentioned reset check will call usb_reset_device() on the
> > stale device data structure. The kernel will send pointless LPM control
> > messages to the no longer connected device address and can even cause
> > several 5 second khubd stalls on some (buggy?) host controllers, before
> > finally accepting the device's fate amongst a flurry of error messages.
> > 
> > This patch makes the choice of reset dependent on the port status that
> > has just been read from the hub in addition to the existence of an
> > in-kernel data structure for the device, and only proceeds with the more
> > extensive reset if both are valid.
> > 
> > Signed-off-by: Julius Werner <jwerner@chromium.org>
> This version looks better.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks Alan, I'll send this off to Greg shortly.

Sarah Sharp
