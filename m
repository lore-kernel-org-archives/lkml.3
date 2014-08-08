Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaHHKNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:13:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36503 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbaHHKNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:13:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: wsa@the-dreams.de, max.schwarz@online.de, olof@lixom.net,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, hl@rock-chips.com,
        caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH] i2c: rk3x: fix interrupt handling issue
Date: Fri, 08 Aug 2014 12:15:11 +0200
Message-ID: <1676136.zY2YY7tt5d@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1407490900-4718-1-git-send-email-addy.ke@rock-chips.com>
References: <1407490900-4718-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 8. August 2014, 17:41:40 schrieb Addy Ke:
> If slave holds scl, I2C_IPD[7] will be set 1 by controller
> for debugging. Driver must ignore it.
> 
> [    5.752391] rk3x-i2c ff160000.i2c: unexpected irq in WRITE: 0x80
> [    5.939027] rk3x-i2c ff160000.i2c: timeout, ipd: 0x80, state: 4
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

I checked the manuals, bits [31:7] are marked as reserved in all of them, so

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/i2c/busses/i2c-rk3x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index 9e3084c..eab49e6 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -399,7 +399,7 @@ static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
> }
> 
>  	/* is there anything left to handle? */
> -	if (unlikely(ipd == 0))
> +	if (unlikely((ipd & REG_INT_ALL) == 0))
>  		goto out;
> 
>  	switch (i2c->state) {

