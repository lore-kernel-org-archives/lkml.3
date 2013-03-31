Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3CaHZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:25:12 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63151 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3CaHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:25:10 -0400
Date: Sun, 31 Mar 2013 00:25:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sebastien Royen <sebastien.royen@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        seb <sebastien.royen@armadeus.com>
Subject: Re: [PATCH 1/1] Input: mma8450 - fix signed 12bits to 32bits
 conversion
Message-ID: <20130331072506.GA7919@core.coreip.homeip.net>
References: <1364480189-15062-1-git-send-email-sebastien.royen@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364480189-15062-1-git-send-email-sebastien.royen@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 03:16:29PM +0100, Sebastien Royen wrote:
> From: seb <sebastien.royen@armadeus.com>
> 
> Event value is wrong. Should be in range -2048 to 2047, but is in range 0 to 4095.
> Use s8 to int conversion and remove 0xfff mask.
> 
> Signed-off-by: Sebastien Royen <sebastien.royen@armadeus.com>

Applied, thank you Sebastien.

> ---
>  drivers/input/misc/mma8450.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
> index 480557f..f330969 100644
> --- a/drivers/input/misc/mma8450.c
> +++ b/drivers/input/misc/mma8450.c
> @@ -123,9 +123,9 @@ static void mma8450_poll(struct input_polled_dev *dev)
>  	if (ret < 0)
>  		return;
>  
> -	x = ((buf[1] << 4) & 0xff0) | (buf[0] & 0xf);
> -	y = ((buf[3] << 4) & 0xff0) | (buf[2] & 0xf);
> -	z = ((buf[5] << 4) & 0xff0) | (buf[4] & 0xf);
> +	x = ((int)(s8)buf[1] << 4) | (buf[0] & 0xf);
> +	y = ((int)(s8)buf[3] << 4) | (buf[2] & 0xf);
> +	z = ((int)(s8)buf[5] << 4) | (buf[4] & 0xf);
>  
>  	input_report_abs(dev->input, ABS_X, x);
>  	input_report_abs(dev->input, ABS_Y, y);
> -- 
> 1.7.9.5
> 

-- 
Dmitry
