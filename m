Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3GZNYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:24:09 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3464 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3GZNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:24:07 -0400
Message-ID: <51F27868.1010104@xs4all.nl>
Date: Fri, 26 Jul 2013 15:23:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 1/4] [media] em28xx: fix assignment of the eeprom data.
References: <1374015476-26197-1-git-send-email-prahal@yahoo.com>
In-Reply-To: <1374015476-26197-1-git-send-email-prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ouch. I'll take this for 3.11 and CC linux-stable for 3.10.

I'm amazed that this hasn't been discovered earlier.

Thanks!

	Hans

On 07/17/2013 12:57 AM, Alban Browaeys wrote:
> Set the config structure pointer to the eeprom data pointer (data,
> here eedata dereferenced) not the pointer to the pointer to
> the eeprom data (eedata itself).
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 4851cc2..c4ff973 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  
>  	*eedata = data;
>  	*eedata_len = len;
> -	dev_config = (void *)eedata;
> +	dev_config = (void *)*eedata;
>  
>  	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>  	case 0:
> 
