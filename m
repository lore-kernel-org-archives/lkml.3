Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3BDShR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:37:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:46408 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3BDShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:37:15 -0500
Date: Mon, 4 Feb 2013 10:39:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: [PATCH 1/2] USB: storage: Define a new macro for USB storage
 match rules
Message-ID: <20130204183929.GA5570@kroah.com>
References: <fe8caaa7d09.d09fe8caaa7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8caaa7d09.d09fe8caaa7@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 03:14:46PM +0800, fangxiaozhi 00110321 wrote:
> +/* Define the device is matched with Vendor ID and interface descriptors */
> +#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
> +			vendorName, productName, useProtocol, useTransport, \
> +			initFunction, flags) \
> +{ \
> +	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
> +				| USB_DEVICE_ID_MATCH_VENDOR, \
> +	.idVendor    = (id_vendor), \
> +	.bInterfaceClass = (cl), \
> +	.bInterfaceSubClass = (sc), \
> +	.bInterfaceProtocol = (pr), \
> +	.driver_info = (flags) \
> +}

I'm not going to reject this given the number of times it has been
submitted, but can't you use the USB_VENDOR_AND_INTERFACE_INFO() macro
here in this definition?

If so, can you send me an add-on patch that makes that change?

thanks,

greg k-h
