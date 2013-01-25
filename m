Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3AYMS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:18:56 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39342 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3AYMSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:18:52 -0500
Message-ID: <5102781A.8070502@mvista.com>
Date: Fri, 25 Jan 2013 16:18:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
References: <fe6cef496609.6609fe6cef49@huawei.com>
In-Reply-To: <fe6cef496609.6609fe6cef49@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-01-2013 6:44, fangxiaozhi 00110321 wrote:

> From: fangxiaozhi <huananhu@huawei.com>

> 1. Define a new macro for USB storage match rules:
>      matching with Vendor ID and interface descriptors.

> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------
>
>   diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usb.c linux-3.8-rc4/drivers/usb/storage/usb.c
> --- linux-3.8-rc4_orig/drivers/usb/storage/usb.c 2013-01-22 14:12:42.595238727 +0800
> +++ linux-3.8-rc4/drivers/usb/storage/usb.c 2013-01-22 14:16:01.398250305 +0800
> @@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
>    .useTransport = use_transport, \
>   }
>
> +#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> +         vendor_name, product_name, use_protocol, use_transport, \
> +         init_function, Flags) \
> +{ \
> + .vendorName = vendor_name, \
> + .productName = product_name, \
> + .useProtocol = use_protocol, \
> + .useTransport = use_transport, \
> + .initFunction = init_function, \
> +}

   Shouldn't the field initilaizers be indented with tab, not space?

> diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usual-tables.c linux-3.8-rc4/drivers/usb/storage/usual-tables.c
> --- linux-3.8-rc4_orig/drivers/usb/storage/usual-tables.c 2013-01-22 14:12:42.594238726 +0800
> +++ linux-3.8-rc4/drivers/usb/storage/usual-tables.c 2013-01-22 14:16:01.426250199 +0800
> @@ -41,6 +41,19 @@
>   #define USUAL_DEV(useProto, useTrans) \
>   { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
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

    Same question. And trailing '}' should be on a separate line.

WBR, Sergei

