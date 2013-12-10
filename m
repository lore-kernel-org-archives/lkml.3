Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LJGsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:48:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42483 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3LJGsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:48:11 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-6e-52a6b928d1ff
Message-id: <52A6B91E.1010609@samsung.com>
Date: Tue, 10 Dec 2013 07:47:58 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330
 Thunderbird/17.0.5
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] gadget: make USB_CONFIGFS_MASS_STORAGE depend on BLOCK
References: <52A61781.6070708@infradead.org>
In-reply-to: <52A61781.6070708@infradead.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xa7oaO5cFGXxYZmBx8H69RfPi9WwW
	l3fNYbNYtKyV2eLtneksDqwem1doeeyfu4bd4/iN7UwenzfJBbBEcdmkpOZklqUW6dslcGX8
	XLeGtWALT0VXyxGmBsYtXF2MnBwSAiYSm9ZtZIGwxSQu3FvP1sXIxSEksJRR4nhzJxOE85lR
	YunGVUAZDg5eAS2Jp38dQBpYBFQlFt19xApiswkYS+w92MEIYosKhElMfXuHDcTmFRCU+DH5
	HtgCEQENid9XrrCCzGQWmMsocfDcD7CEsIC3xJWFj1lB5gsJ6EjsaK8ACXMK6EosnLGSCcRm
	FrCWWDlpGyOELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS
	83M3MUJC+MsOxsXHrA4xCnAwKvHwFjAsCxJiTSwrrsw9xCjBwawkwutZBxTiTUmsrEotyo8v
	Ks1JLT7EyMTBKdXA6L/7a/l8VdFr6Qy5kpvurpraYqNg41oxYcJh2Uc7FCvdJJYwBTDuvZgw
	P0trcTDbg2UG3i7/uH+pfFp/e0a2Md+hk15L5py6ra9zXsDvXNP+P87iLLuZ2LWDm/dvcnq6
	cs0nUc1vjhvLn/zpY9kiavFn/5bAl+unvpqZvSlXoeu0JO+2PgfueUosxRmJhlrMRcWJAJaJ
	WEg/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


W dniu 09.12.2013 20:18, Randy Dunlap pisze:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Make USB_CONFIGFS_MASS_STORAGE depend on BLOCK just like the other
> gadget MASS_STORAGE options do.  This fixes the following build errors
> that occur when BLOCK is not enabled:

Already submitted

http://www.spinics.net/lists/linux-usb/msg96739.html

AP


>
> drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
> drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration of function 'bdev_logical_block_size' [-Werror=implicit-function-declaration]
> drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration of function 'blksize_bits' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Felipe Balbi <balbi@ti.com>
> ---
>   drivers/usb/gadget/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- lnx-313-rc3.orig/drivers/usb/gadget/Kconfig
> +++ lnx-313-rc3/drivers/usb/gadget/Kconfig
> @@ -681,7 +681,7 @@ config USB_CONFIGFS_PHONET
>
>   config USB_CONFIGFS_MASS_STORAGE
>   	boolean "Mass storage"
> -	depends on USB_CONFIGFS
> +	depends on USB_CONFIGFS && BLOCK
>   	select USB_F_MASS_STORAGE
>   	help
>   	  The Mass Storage Gadget acts as a USB Mass Storage disk drive.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

