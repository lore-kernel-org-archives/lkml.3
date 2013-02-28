Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab3B1POG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:14:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758537Ab3B1POC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:14:02 -0500
Date: Thu, 28 Feb 2013 10:14:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lan Tianyu <tianyu.lan@intel.com>
cc: Li Fei <fei.li@intel.com>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chuansheng.liu@intel.com>
Subject: Re: [PATCH 4/5] usb: call pm_runtime_put_sync in pm_runtime_get_sync
 failed case
In-Reply-To: <512F1741.60202@intel.com>
Message-ID: <Pine.LNX.4.44L0.1302281011550.1352-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Lan Tianyu wrote:

> Hi Alan:
> 	Further thinking, the device should be disconnected since the port
> can't be resumed and the device will not work normally. Something like
> following. Does this make sense?
> ---
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index d5d3de4..cf36b11 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3170,6 +3170,7 @@ int usb_port_resume(struct usb_device *udev,
> pm_message_t msg)
>                 if (status < 0) {
>                         dev_dbg(&udev->dev, "can't resume usb port,
> status %d\n",
>                                         status);
> +                       hub_port_logical_disconnect(hub, port1);
>                         return status;
>                 }
>         }

I don't know.  If you do this, will the port ever get powered on again?  
This sort of thing is hard to test.

As far as the device is concerned, it won't make much difference.  
Either way, the device won't work.

Alan Stern

