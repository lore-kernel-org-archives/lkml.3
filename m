Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbaGCRfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:35:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60606 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaGCRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:34:58 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 3 Jul 2014 19:34:21 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>, cooloney@gmail.com
Cc: johan@kernel.org, cooloney@gmail.com, jkosina@suse.cz, greg@kroah.com,
        bjorn@mork.no, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] HID: gt683r: fix race condition
Message-ID: <20140703173421.GO16590@localhost>
References: <20140703082830.GB16590@localhost>
 <1404407829-1815-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404407829-1815-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 08:17:08PM +0300, Janne Kanniainen wrote:
> This will fix race condition noticed by Oliver Neukum. Sysfs files are
> created before mutex and work are initialized.
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>

Reviewed-by: Johan Hovold <johan@kernel.org>

> ---
>  drivers/hid/hid-gt683r.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
> index 077f7a1..073bd80 100644
> --- a/drivers/hid/hid-gt683r.c
> +++ b/drivers/hid/hid-gt683r.c
> @@ -227,6 +227,9 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  	if (!led)
>  		return -ENOMEM;
>  
> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
> +
>  	led->mode = GT683R_LED_NORMAL;
>  	led->hdev = hdev;
>  	hid_set_drvdata(hdev, led);
> @@ -271,9 +274,6 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		goto fail;
>  	}
>  
> -	mutex_init(&led->lock);
> -	INIT_WORK(&led->work, gt683r_led_work);
> -
>  	return 0;
>  
>  fail:
