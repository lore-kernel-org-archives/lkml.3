Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaAWTI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:08:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaAWTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:08:54 -0500
Date: Thu, 23 Jan 2014 11:09:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: anthony.foiani@gmail.com, devel@driverdev.osuosl.org, navinp@cdac.in,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, tulinizer@gmail.com,
        stern@rowland.harvard.edu, yacine.belkadi.1@gmail.com,
        ke42caxa@cip.cs.fau.de
Subject: Re: [PATCH] staging: usbip: convert usbip-host driver to
 usb_device_driver
Message-ID: <20140123190944.GA11639@kroah.com>
References: <1390502206-28684-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390502206-28684-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:36:46PM +0200, Valentina Manea wrote:
> This driver was previously an interface driver. Since USB/IP
> exports a whole device, not just an interface, it would make
> sense to be a device driver.
> 
> This patch also modifies the way userspace sees and uses a
> shared device - dealing with interfaces is no longer required.

In what way is this modified?  What is now different?

> --- a/drivers/usb/core/generic.c
> +++ b/drivers/usb/core/generic.c
> @@ -155,6 +155,7 @@ int usb_choose_configuration(struct usb_device *udev)
>  	}
>  	return i;
>  }
> +EXPORT_SYMBOL(usb_choose_configuration);
>  
>  static int generic_probe(struct usb_device *udev)
>  {
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index bb31597..fb0a555 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -1921,6 +1921,7 @@ free_interfaces:
>  	usb_autosuspend_device(dev);
>  	return 0;
>  }
> +EXPORT_SYMBOL(usb_set_configuration);
>  
>  static LIST_HEAD(set_config_list);
>  static DEFINE_SPINLOCK(set_config_lock);

Please make both of these EXPORT_SYMBOL_GPL(), like the rest of the USB
symbols are.

thanks,

greg k-h
