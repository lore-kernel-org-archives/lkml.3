Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3KFVwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:52:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46176 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756476Ab3KFVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:52:30 -0500
Date: Wed, 6 Nov 2013 16:52:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
In-Reply-To: <1383769641-22910-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1311061648220.1220-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Julius Werner wrote:

> This patch adds a check for USB_STATE_NOTATTACHED to the
> hub_port_warm_reset_required() workaround for ports that end up in
> Compliance Mode in hub_events() when trying to decide which reset
> function to use. Trying to call usb_reset_device() with a NOTATTACHED
> device will just fail and leave the port broken.

What if the device is in USB_STATE_SUSPENDED?

> 
> Also bumped the messages about this kind of reset failure from dev_dbg()
> to dev_warn() to make it easier to notice, since calling that function
> with a NOTATTACHED device would almost always be a bug

Not at all.  If a device is unplugged, its state changes to NOTATTACHED 
before the driver is unbound.  During that time, the driver will see 
all its URBs failing, so it may very well try to reset the device.  
(For example, usbhid behaves like this.)  That isn't a bug.

Alan Stern

