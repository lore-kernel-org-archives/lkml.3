Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbbAXArb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:47:31 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48448 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAXAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:47:29 -0500
Date: Fri, 23 Jan 2015 16:47:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: khoroshilov@ispras.ru, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: (gtco) use sign_extend32() for sign extension
Message-ID: <20150124004724.GA16356@dtor-ws>
References: <1422016176-6299-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422016176-6299-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 01:29:36PM +0100, Martin Kepplinger wrote:
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> Despite it's name, sign_extend32() is safe to use for 8 and 16 bit types too.


Applied, thank you, but I am sure it can be cleaned up even more.

> 
> 
>  drivers/input/tablet/gtco.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
> index 8580456..272a838 100644
> --- a/drivers/input/tablet/gtco.c
> +++ b/drivers/input/tablet/gtco.c
> @@ -59,7 +59,7 @@ Scott Hill shill@gtcocalcomp.com
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
>  #include <asm/byteorder.h>
> -
> +#include <linux/bitops.h>
>  
>  #include <linux/usb/input.h>
>  
> @@ -666,13 +666,8 @@ static void gtco_urb_callback(struct urb *urbinfo)
>  		case 4:
>  			/* Tilt */
>  
> -			/* Sign extend these 7 bit numbers.  */
> -			if (device->buffer[6] & 0x40)
> -				device->buffer[6] |= 0x80;
> -
> -			if (device->buffer[7] & 0x40)
> -				device->buffer[7] |= 0x80;
> -
> +			device->buffer[6] = sign_extend32(device->buffer[6], 6);
> +			device->buffer[7] = sign_extend32(device->buffer[7], 6);
>  
>  			valsigned = (device->buffer[6]);
>  			input_report_abs(inputdev, ABS_TILT_X, (s32)valsigned);
> -- 
> 2.1.4
> 

-- 
Dmitry
