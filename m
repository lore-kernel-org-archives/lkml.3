Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab3ANTMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:12:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:60067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3ANTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:12:13 -0500
Message-ID: <50F458D2.6070000@infradead.org>
Date: Mon, 14 Jan 2013 11:13:22 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 14 (mtd)
References: <20130114154649.cb077b499876da60463fb304@canb.auug.org.au> <50F43197.6010308@infradead.org> <874nija8ry.fsf@free.fr>
In-Reply-To: <874nija8ry.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/13 11:01, Robert Jarzmik wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
>> ERROR: "byte_rev_table" [drivers/mtd/devices/docg3.ko] undefined!
> 
> Thanks for the report. I have a trivial patch attached. Should it go through
> Artem's tree or do you want to take it directly ?

Acked-by: Randy Dunlap <rdunlap@infradead.org>

I suppose that it should go thru Artem's tree.

Thanks.


> Cheers.
> 
> --
> Robert
> 
> ---8>---
> 
> From 771d13b0094421b98310171d8794f2a793ec5d4d Mon Sep 17 00:00:00 2001
> From: Robert Jarzmik <robert.jarzmik@free.fr>
> Date: Mon, 9 Apr 2012 13:19:08 +0200
> Subject: [PATCH] mtd: docg3 fix missing bitreverse lib
> 
> Fix missing dependency which can cause a build error such
> as: ERROR: "byte_rev_table" [drivers/mtd/devices/docg3.ko]
> undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/mtd/devices/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 27f80cd..46dcb54 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -272,6 +272,7 @@ config MTD_DOCG3
>  	tristate "M-Systems Disk-On-Chip G3"
>  	select BCH
>  	select BCH_CONST_PARAMS
> +	select BITREVERSE
>  	---help---
>  	  This provides an MTD device driver for the M-Systems DiskOnChip
>  	  G3 devices.
> 


-- 
~Randy
