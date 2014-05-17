Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaEQN77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:59:59 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:33560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbaEQN76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:59:58 -0400
Message-ID: <53776B57.5050504@iki.fi>
Date: Sat, 17 May 2014 16:59:51 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, gregkh@linuxfoundation.org
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: as102: replace custom dprintk() with
 dev_dbg()
References: <1400332591-27528-1-git-send-email-martink@posteo.de>
In-Reply-To: <1400332591-27528-1-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.23.164.239
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you forget to remove debug parameter itself.

Antti


On 05/17/2014 04:16 PM, Martin Kepplinger wrote:
> don't reinvent dev_dbg(). use the common kernel coding style.
>
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> this applies to next-20140516.
>
>   drivers/staging/media/as102/as102_drv.c |   11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
> index 09d64cd..99c3ed93 100644
> --- a/drivers/staging/media/as102/as102_drv.c
> +++ b/drivers/staging/media/as102/as102_drv.c
> @@ -74,7 +74,8 @@ static void as102_stop_stream(struct as102_dev_t *dev)
>   			return;
>
>   		if (as10x_cmd_stop_streaming(bus_adap) < 0)
> -			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
> +			dev_dbg(&dev->bus_adap.usb_dev->dev,
> +				"as10x_cmd_stop_streaming failed\n");
>
>   		mutex_unlock(&dev->bus_adap.lock);
>   	}
> @@ -112,14 +113,16 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
>   	int ret = -EFAULT;
>
>   	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
> -		dprintk(debug, "mutex_lock_interruptible(lock) failed !\n");
> +		dev_dbg(&dev->bus_adap.usb_dev->dev,
> +			"amutex_lock_interruptible(lock) failed !\n");
>   		return -EBUSY;
>   	}
>
>   	switch (onoff) {
>   	case 0:
>   		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
> -		dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
> +		dev_dbg(&dev->bus_adap.usb_dev->dev,
> +			"DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
>   			index, pid, ret);
>   		break;
>   	case 1:
> @@ -131,7 +134,7 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
>   		filter.pid = pid;
>
>   		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
> -		dprintk(debug,
> +		dev_dbg(&dev->bus_adap.usb_dev->dev,
>   			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
>   			index, filter.idx, filter.pid, ret);
>   		break;
>


-- 
http://palosaari.fi/
