Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaGGOln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:41:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:50175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaGGOlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:41:42 -0400
Message-ID: <53BAB19C.7080703@infradead.org>
Date: Mon, 07 Jul 2014 07:41:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kieran Kunhya <kieran@kunhya.com>, axboe@kernel.dk
CC: akpm@linux-foundation.org, jmoyer@redhat.com, fabf@skynet.be,
        minchan@kernel.org, linus.walleij@linaro.org, abhansali@stec-inc.com,
        gnomes@lxorguk.ukuu.org.uk, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Add support for Sony SxS cards Signed-off-by:
 Kieran Kunhya <kieran@kunhya.com>
References: <1404726794-8964-1-git-send-email-kieran@kunhya.com> <1404726794-8964-2-git-send-email-kieran@kunhya.com>
In-Reply-To: <1404726794-8964-2-git-send-email-kieran@kunhya.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 02:53 AM, Kieran Kunhya wrote:

Signed-off-by: should be here,
not in the Subject line.

> ---
>  drivers/block/Kconfig  |    9 +
>  drivers/block/Makefile |    1 +
>  drivers/block/sxs.c    |  491 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 501 insertions(+)
>  create mode 100644 drivers/block/sxs.c
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 014a1cf..50ed13e 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -356,6 +356,15 @@ config BLK_DEV_SX8
>  
>  	  Use devices /dev/sx8/$N and /dev/sx8/$Np$M.
>  
> +config BLK_DEV_SXS
> +        tristate "Sony SxS card support"
> +        depends on PCI
> +        ---help---
> +          Saying Y or M here will enable support for reading
> +          from Sony SxS cards.
> +
> +          It creates a device called /dev/sxs
> +

Use tab to indent tristate, depends, and help.
Use tab + 2 spaces to indent the help text.

>  config BLK_DEV_RAM
>  	tristate "RAM block device support"
>  	---help---
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 02b688d..1e10fb6 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
>  
>  obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
>  obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
> +obj-$(CONFIG_BLK_DEV_SXS)       += sxs.o

Use tab(s) here             ^^^^^^
not spaces.

>  
>  obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
>  obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/


-- 
~Randy
