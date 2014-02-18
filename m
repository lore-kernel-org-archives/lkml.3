Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaBRKwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:52:36 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43103 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbaBRKwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:52:35 -0500
Message-ID: <53033B69.5050909@mev.co.uk>
Date: Tue, 18 Feb 2014 10:52:25 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v2] Staging: comedi: addi-data: convert printk() to
 dev_err()
References: <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com> <1392705279-29692-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392705279-29692-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-18 06:34, Chase Southwood wrote:
> This patch for hwdrv_apci035.c changes a printk() call to a dev_err() call
> since this is generally preferred.  It also removes a newline from the start
> of the error message.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: Removed leading newline, per Ian's request.
>
>   drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 90d5801..ff64540 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -227,7 +227,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   			ui_Command = ui_Command & 0xFFF819E2UL;
>
>   		} else {
> -			printk("\n The parameter for Timer/watchdog selection is in error\n");
> +			dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
>   			return -EINVAL;
>   		}
>   	}
>

That's better!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
