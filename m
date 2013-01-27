Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3A0Smg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:42:36 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46056 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425Ab3A0Smf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:42:35 -0500
Date: Sun, 27 Jan 2013 19:42:29 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Message-ID: <20130127184229.GA7163@breakpoint.cc>
References: <fe6cef496609.6609fe6cef49@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6cef496609.6609fe6cef49@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:44:50AM +0800, fangxiaozhi 00110321 wrote:
> diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usual-tables.c linux-3.8-rc4/drivers/usb/storage/usual-tables.c
> --- linux-3.8-rc4_orig/drivers/usb/storage/usual-tables.c 2013-01-22 14:12:42.594238726 +0800
> +++ linux-3.8-rc4/drivers/usb/storage/usual-tables.c 2013-01-22 14:16:01.426250199 +0800
> @@ -41,6 +41,19 @@
>  #define USUAL_DEV(useProto, useTrans) \
>  { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
>  
> +/* Define the device is matched with Vendor ID and interface descriptors */
> +#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
> +                 vendorName, productName, useProtocol, useTransport, \
> +                 initFunction, flags) \
> +{ \
> + .match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
> +                         | USB_DEVICE_ID_MATCH_VENDOR, \
> + .idVendor    = (id_vendor), \
> + .bInterfaceClass = (cl), \
> + .bInterfaceSubClass = (sc), \
> + .bInterfaceProtocol = (pr), \
> + .driver_info = (flags) }

The braces aren't required and you did not need in UNUSUAL_VENDOR_INTF.

Sebastian
