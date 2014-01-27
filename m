Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaA0UXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:23:25 -0500
Received: from gloria.sntech.de ([95.129.55.99]:38667 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbaA0UXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:23:23 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Luis Ortega <luiorpe1@upv.es>
Cc: dmitry.torokhov@gmail.com, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Input: zforce - reduce stack memory allocated to frames
Date: Mon, 27 Jan 2014 21:22:39 +0100
Message-ID: <4535379.f73S9IDmJi@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1390848373-7723-5-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es> <1390848373-7723-5-git-send-email-luiorpe1@upv.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27. January 2014 19:46:13 Luis Ortega wrote:
> A frame is a u8 array with the following structure:
> [PAYLOAD_HEADER, PAYLOAD_LENGTH, ...PAYLOAD_BODY...]
> 
> PAYLOAD_BODY can be at most 255 bytes long, as it's size is represented
> by PAYLOAD_LENGTH. Therefore we can reduce the stack memory allocated to
> payload_buffer[] roughly by half, from 512 to 257 bytes.

Nice catch, thanks

Acked-by: Heiko Stuebner <heiko@sntech.de>

on a bq Cervantes (imx6sl)
Tested-by: Heiko Stuebner <heiko@sntech.de>


As a side-note, this change conflicts with one of my patches adding devicetree 
support to the driver [0], which Dmitry will hopefully also look at soon.

So one of us might need to respin his series depending on the ordering.



[0] http://permalink.gmane.org/gmane.linux.kernel.input/33587




> 
> Signed-off-by: Luis Ortega <luiorpe1@upv.es>
> ---
>  drivers/input/touchscreen/zforce_ts.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/zforce_ts.c
> b/drivers/input/touchscreen/zforce_ts.c index e082d5c..afb2492 100644
> --- a/drivers/input/touchscreen/zforce_ts.c
> +++ b/drivers/input/touchscreen/zforce_ts.c
> @@ -33,6 +33,7 @@
>  #define WAIT_TIMEOUT		msecs_to_jiffies(1000)
> 
>  #define FRAME_START		0xee
> +#define FRAME_MAXSIZE		257
> 
>  /* Offsets of the different parts of the payload the controller sends */
>  #define PAYLOAD_HEADER		0
> @@ -475,7 +476,7 @@ static irqreturn_t zforce_irq_thread(int irq, void
> *dev_id) struct i2c_client *client = ts->client;
>  	const struct zforce_ts_platdata *pdata = dev_get_platdata(&client->dev);
>  	int ret;
> -	u8 payload_buffer[512];
> +	u8 payload_buffer[FRAME_MAXSIZE];
>  	u8 *payload;
> 
>  	/*

