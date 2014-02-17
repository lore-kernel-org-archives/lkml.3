Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaBQNSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:18:16 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39681 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaBQNR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:17:58 -0500
Message-ID: <53020BFE.9020400@mev.co.uk>
Date: Mon, 17 Feb 2014 13:17:50 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Staging: comedi: addi-data: convert printk() to dev_err()
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-16 08:41, Chase Southwood wrote:
> This patch for hwdrv_apci035.c changes a printk() call to a dev_err call
> since this is generally preferred.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 90d5801..f02b714 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -227,7 +227,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   			ui_Command = ui_Command & 0xFFF819E2UL;
>
>   		} else {
> -			printk("\n The parameter for Timer/watchdog selection is in error\n");
> +			dev_err(dev->class_dev, "\n The parameter for Timer/watchdog selection is in error\n");
>   			return -EINVAL;
>   		}
>   	}
>

It'd be great if you could get rid of the initial "\n " in the error 
string too.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
