Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3BFRqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:46:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40215 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727Ab3BFRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:46:15 -0500
X-Sasl-enc: lvxJa+6G4DN+adcxiY7oZOFEMlzwJfkNR2HwL9zMxCU/ 1360172774
Date: Wed, 6 Feb 2013 09:46:13 -0800
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: [PATCH 1/1]linux-usb: fix the product IDs to be little endian in
 initializers.c
Message-ID: <20130206174613.GA18681@kroah.com>
References: <fe6feaa260b9.60b9fe6feaa2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6feaa260b9.60b9fe6feaa2@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 05:24:12PM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. The idProduct is little endian, so make the product ID's value to be little endian. Make no break on big endian processors.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------
> 
> diff -uprN linux-3.8-rc6_orig/drivers/usb/storage/initializers.c linux-3.8-rc6/drivers/usb/storage/initializers.c
> --- linux-3.8-rc6_orig/drivers/usb/storage/initializers.c	2013-02-06 14:48:51.564355283 +0800
> +++ linux-3.8-rc6/drivers/usb/storage/initializers.c	2013-02-06 15:11:40.925434289 +0800
> @@ -152,12 +152,15 @@ static int usb_stor_huawei_dongles_pid(s
>  	 * means the dongle in the single port mode,
>  	 * and a switch command is required to be sent. */
>  	if (idesc && idesc->bInterfaceNumber == 0) {
> -		if ((idProduct == 0x1001)
> -			|| (idProduct == 0x1003)
> -			|| (idProduct == 0x1004)
> -			|| (idProduct >= 0x1401 && idProduct <= 0x1500)
> -			|| (idProduct >= 0x1505 && idProduct <= 0x1600)
> -			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> +		if ((idProduct == cpu_to_le16(0x1001))

No, this doesn't fix the sparse warning, and is way too complex (and
doesn't really work well either.)

Please do the conversion on the value when you assign it to idProduct
and then you will be fine.

Please run sparse on your patch to ensure you got it right, if you would
have done so here, it would have been pretty obvious.

thanks,

greg k-h
