Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457Ab3LIT1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:27:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54689 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342Ab3LIT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:27:34 -0500
Message-ID: <52A619A3.7020705@infradead.org>
Date: Mon, 09 Dec 2013 11:27:31 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] gadget: make USB_CONFIGFS_MASS_STORAGE depend on BLOCK
References: <52A61781.6070708@infradead.org> <20131209192157.GA28441@saruman.home>
In-Reply-To: <20131209192157.GA28441@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 11:21, Felipe Balbi wrote:
> On Mon, Dec 09, 2013 at 11:18:25AM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Make USB_CONFIGFS_MASS_STORAGE depend on BLOCK just like the other
>> gadget MASS_STORAGE options do.  This fixes the following build errors
>> that occur when BLOCK is not enabled:
>>
>> drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
>> drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration of function 'bdev_logical_block_size' [-Werror=implicit-function-declaration]
>> drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration of function 'blksize_bits' [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Cc: Felipe Balbi <balbi@ti.com>
> 
> Already have a patch for that

Thanks.

It wouldn't hurt to fix mainline so that it builds without this error, eh?


> commit bc912b0d237c1d376214616ae0c9d12b7d542ab4
> Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Date:   Mon Nov 4 13:46:17 2013 +0100
> 
>     usb: gadget: f_mass_storage: fix mass storage dependency
>     
>     Legacy gadgets supporting mass storage (g_mass_storage, g_acm_ms, g_multi)
>     all depend on BLOCK.
>     
>     Make the standalone compilation of f_mass_storage (without any legacy
>     gadget) dependent no BLOCK, too.
>     
>     Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index a91e642..f66d96a 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -682,6 +682,7 @@ config USB_CONFIGFS_PHONET
>  config USB_CONFIGFS_MASS_STORAGE
>  	boolean "Mass storage"
>  	depends on USB_CONFIGFS
> +	depends on BLOCK
>  	select USB_F_MASS_STORAGE
>  	help
>  	  The Mass Storage Gadget acts as a USB Mass Storage disk drive.
> 


-- 
~Randy
