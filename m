Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaLWUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:19:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51648 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756521AbaLWUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:19:48 -0500
Date: Tue, 23 Dec 2014 15:19:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Du, Changbin" <changbin.du@intel.com>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [DISCUSSION] USB device remote wakeup is not working for S3 case
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01C43756@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1412231516060.29466-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014, Du, Changbin wrote:

> > You have to make sure that wakeup is also enabled for the host
> > controller the device is attached to.  For some host controllers, it
> > may also be necessary to enable wakeup for the root hub.
> > 
> Yes, the root-hub is not wakeup enabled by default, actually hub
> devices are not enabled. It works after I enable it via sysfs interface.

On some hardware, device wakeup requests can work even when root-hub 
wakeup is disabled -- it varies.

In general we do not want hubs to be enabled for wakeup.  If they were, 
then your computer would wake up the moment you unplugged a USB device.  
You would not be able to (for example) to put your laptop to sleep, 
unplug a USB mouse, and put the laptop in its case.

> > > Could we also enable wakeup for usb mouse? Or is there any concern to
> > enable it?
> > > Per my opinion, most people may expect clicking mouse can awake system.
> > 
> > It doesn't matter to me, but you should ask the people on the
> > linux-input mailing list.
> > 
> > Also, what about wakeup for a non-USB mouse?  Shouldn't that be enabled
> > as well?
> Unfortunately the mouse I found are all of usb so cannot confirm it. The
> concern is if we want usb keyboard/mouse wakeup work by default, it does
> make sense only if the parent hubs are also enabled by default.  This is a policy
> issue and may be better place it on userspace. I have no better idea :) .

As mentioned above, it depends on the hardware.

Alan Stern

