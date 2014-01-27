Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaA0URm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:17:42 -0500
Received: from gloria.sntech.de ([95.129.55.99]:38631 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbaA0URk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:17:40 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Luis Ortega <luiorpe1@upv.es>
Cc: dmitry.torokhov@gmail.com, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Input: zforce - Remove unnecessary payload data checks
Date: Mon, 27 Jan 2014 21:16:56 +0100
Message-ID: <1792639.WIegrEEhpK@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1390848373-7723-4-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es> <1390848373-7723-4-git-send-email-luiorpe1@upv.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27. January 2014 19:46:12 Luis Ortega wrote:
> The function zforce_read_packet() reads 2 values (bytes) of payload
> header, validates them and then proceeds to read the payload body.
> The function stores all these in a u8 buffer.
> 
> The PAYLOAD_LENGTH check seems to be trying to detect an overflow error.
> However, since we are just reading a u8 value from the buffer, these
> checks are unnecessary and we should simply compare against zero.
> 
> Signed-off-by: Luis Ortega <luiorpe1@upv.es>

Acked-by: Heiko Stuebner <heiko@sntech.de>

on a bq Cervantes (imx6sl)
Tested-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  drivers/input/touchscreen/zforce_ts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/zforce_ts.c
> b/drivers/input/touchscreen/zforce_ts.c index c1b6b82..e082d5c 100644
> --- a/drivers/input/touchscreen/zforce_ts.c
> +++ b/drivers/input/touchscreen/zforce_ts.c
> @@ -423,7 +423,7 @@ static int zforce_read_packet(struct zforce_ts *ts, u8
> *buf) goto unlock;
>  	}
> 
> -	if (buf[PAYLOAD_LENGTH] <= 0 || buf[PAYLOAD_LENGTH] > 255) {
> +	if (buf[PAYLOAD_LENGTH] == 0) {
>  		dev_err(&client->dev, "invalid payload length: %d\n",
>  			buf[PAYLOAD_LENGTH]);
>  		ret = -EIO;

