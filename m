Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3D1WW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 18:22:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:50180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3D1WW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 18:22:57 -0400
Message-ID: <517DA123.10005@infradead.org>
Date: Sun, 28 Apr 2013 15:22:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: wei_wang@realsil.com.cn
CC: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] linux-next:usb-stor:realtek_cr:Fix compile error
References: <1367030953-24707-1-git-send-email-wei_wang@realsil.com.cn>
In-Reply-To: <1367030953-24707-1-git-send-email-wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/13 19:49, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> To fix the compile error when CONFIG_PM_RUNTIME is not enabled,
> move the declaration of us out of CONFIG_REALTEK_AUTOPM macro in rts51x_chip.
> 
> drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
> drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/usb/storage/realtek_cr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
> index 4797228..64c2b28 100644
> --- a/drivers/usb/storage/realtek_cr.c
> +++ b/drivers/usb/storage/realtek_cr.c
> @@ -105,8 +105,9 @@ struct rts51x_chip {
>  	int status_len;
>  
>  	u32 flag;
> -#ifdef CONFIG_REALTEK_AUTOPM
>  	struct us_data *us;
> +
> +#ifdef CONFIG_REALTEK_AUTOPM
>  	struct timer_list rts51x_suspend_timer;
>  	unsigned long timer_expires;
>  	int pwr_state;
> @@ -991,6 +992,7 @@ static int init_realtek_cr(struct us_data *us)
>  	us->extra = chip;
>  	us->extra_destructor = realtek_cr_destructor;
>  	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
> +	chip->us = us;
>  
>  	usb_stor_dbg(us, "chip->max_lun = %d\n", chip->max_lun);
>  
> @@ -1013,10 +1015,8 @@ static int init_realtek_cr(struct us_data *us)
>  			SET_AUTO_DELINK(chip);
>  	}
>  #ifdef CONFIG_REALTEK_AUTOPM
> -	if (ss_en) {
> -		chip->us = us;
> +	if (ss_en)
>  		realtek_cr_autosuspend_setup(us);
> -	}
>  #endif
>  
>  	usb_stor_dbg(us, "chip->flag = 0x%x\n", chip->flag);
> 


-- 
~Randy
