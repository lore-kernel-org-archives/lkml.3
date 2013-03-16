Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3CPCUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:20:16 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49171 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3CPCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:20:14 -0400
Message-ID: <5143D6C4.9060503@gmail.com>
Date: Sat, 16 Mar 2013 13:19:48 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        rpurdie@rpsys.net, FlorianSchandinat@gmx.de
Subject: Re: [PATCH 1/3] backlight: ep93xx_bl: fix section mismatch
References: <201303151803.08774.hartleys@visionengravers.com>
In-Reply-To: <201303151803.08774.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/13 12:03, H Hartley Sweeten wrote:

> Remove the __init tag from ep93xxbl_probe() to fix the section
> mismatch warning.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>


There is a patch for this already queued in Andrew Morton's tree.

~Ryan

> ---
>  drivers/video/backlight/ep93xx_bl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
> index ef3e21e..17b8abb 100644
> --- a/drivers/video/backlight/ep93xx_bl.c
> +++ b/drivers/video/backlight/ep93xx_bl.c
> @@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
>  	.get_brightness	= ep93xxbl_get_brightness,
>  };
>  
> -static int __init ep93xxbl_probe(struct platform_device *dev)
> +static int ep93xxbl_probe(struct platform_device *dev)
>  {
>  	struct ep93xxbl *ep93xxbl;
>  	struct backlight_device *bl;
> @@ -145,7 +145,6 @@ static struct platform_driver ep93xxbl_driver = {
>  	.suspend	= ep93xxbl_suspend,
>  	.resume		= ep93xxbl_resume,
>  };
> -
>  module_platform_driver(ep93xxbl_driver);
>  
>  MODULE_DESCRIPTION("EP93xx Backlight Driver");


