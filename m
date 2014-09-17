Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaIQRg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:36:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756409AbaIQRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:36:27 -0400
Date: Wed, 17 Sep 2014 13:36:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
In-Reply-To: <1410967150-25240-5-git-send-email-pmladek@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409171333310.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Petr Mladek wrote:

> USB hub has started to use a workqueue instead of kthread. Let's update
> the documentation and comments here and there.
> 
> This patch mostly just replaces "khubd" with "hub_wq". There are only few
> exceptions where the whole sentence was updated. These more complicated
> changes can be found in the following files:
> 
> 	   Documentation/usb/hotplug.txt
> 	   drivers/net/usb/usbnet.c
> 	   drivers/usb/core/hcd.c
> 	   drivers/usb/host/ohci-hcd.c
> 	   drivers/usb/host/xhci.c

Okay, here's a real issue.

> @@ -2042,7 +2042,7 @@ static void choose_devnum(struct usb_device *udev)
>  	int		devnum;
>  	struct usb_bus	*bus = udev->bus;
>  
> -	/* If khubd ever becomes multithreaded, this will need a lock */
> +	/* If hub_wq ever becomes multithreaded, this will need a lock */
>  	if (udev->wusb) {
>  		devnum = udev->portnum + 1;
>  		BUG_ON(test_bit(devnum, bus->devmap.devicemap));

You probably didn't notice when changing this comment.  But in fact,
workqueues _are_ multithreaded.  Therefore you need to add a lock to 
this routine.

Still, apart from these relatively minor issues, the series looks good.

Alan Stern

