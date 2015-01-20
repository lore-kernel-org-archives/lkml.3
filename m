Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbbATLEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:04:10 -0500
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:43960 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbbATLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:04:07 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54BE3624.5060302@mev.co.uk>
Date: Tue, 20 Jan 2015 11:04:04 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: das1800: prefer kmalloc_array over kmalloc
 with multiply
References: <1421721769-28482-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1421721769-28482-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 02:42, Chase Southwood wrote:
> Checkpatch doesn't like kmalloc with multiply very much:
> drivers/staging/comedi/drivers/das1800.c:1377: WARNING: Prefer kmalloc_array over kmalloc with multiply
>
> So this patch swaps that use out for kmalloc_array instead.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> ---
>   drivers/staging/comedi/drivers/das1800.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
> index 381ae94..13ed31c 100644
> --- a/drivers/staging/comedi/drivers/das1800.c
> +++ b/drivers/staging/comedi/drivers/das1800.c
> @@ -1374,7 +1374,7 @@ static int das1800_attach(struct comedi_device *dev,
>   	if (dev->irq & it->options[2])
>   		das1800_init_dma(dev, it);
>
> -	devpriv->fifo_buf = kmalloc(FIFO_SIZE * sizeof(uint16_t), GFP_KERNEL);
> +	devpriv->fifo_buf = kmalloc_array(FIFO_SIZE, sizeof(uint16_t), GFP_KERNEL);
>   	if (!devpriv->fifo_buf)
>   		return -ENOMEM;
>
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
