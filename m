Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaLSPZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:25:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42648 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751414AbaLSPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:25:32 -0500
Date: Fri, 19 Dec 2014 10:25:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Changbin" <changbin.du@intel.com>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [DISCUSSION] USB device remote wakeup is not working for S3 case
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01C42A57@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1412191020320.1599-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Du, Changbin wrote:

> > There's a simple solution: Call device_set_wakeup_enable() for the device!
> > You can do this from the command line by:
> > 
> > 	echo auto >/sys/bus/usb/devices/.../power/control
> > 
> > where the "..." is the pathname for your device.
> > 
> Yes, this can enable auto-suspend for usb device like a mouse. And remote wakeup
> does work for RPM because rpm suspend refers to the needs_remote_wakeup flag.
> But this doesn't impact system level suspend. The correct thing is:
> 	
> 	echo enabled >/sys/bus/usb/devices/.../power/wakeup

Yes, I'm sorry, you're right.  It's easy to mix up autosuspend and 
wakeup.

> This will call device_set_wakeup_enable() for the device and should work. But 
> unfortunately it seems didn't work even the wakeup file shows "enabled" which 
> means the device is wakeup enabled(Tried on 3.16 & 3.18 kernel). This is a different
> issue, I will check.

You have to make sure that wakeup is also enabled for the host 
controller the device is attached to.  For some host controllers, it 
may also be necessary to enable wakeup for the root hub.

> Could we also enable wakeup for usb mouse? Or is there any concern to enable it?
> Per my opinion, most people may expect clicking mouse can awake system.

It doesn't matter to me, but you should ask the people on the 
linux-input mailing list.

Also, what about wakeup for a non-USB mouse?  Shouldn't that be enabled 
as well?

Alan Stern

