Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaHUSEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:04:37 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50229 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaHUSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:04:35 -0400
Message-ID: <53F634AF.1010303@cogentembedded.com>
Date: Thu, 21 Aug 2014 22:04:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Addy Ke <addy.ke@rock-chips.com>, wsa@the-dreams.de, max.schwarz@online.de,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org
CC: huangtao@rock-chips.com, hl@rock-chips.com, yzq@rock-chips.com,
        zyw@rock-chips.com, linux-kernel@vger.kernel.org,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, linux-i2c@vger.kernel.org,
        caesar.wang@rock-chips.com, cf@rock-chips.com, hj@rock-chips.com,
        zhengsq@rock-chips.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
References: <1408643457-7126-1-git-send-email-addy.ke@rock-chips.com>
In-Reply-To: <1408643457-7126-1-git-send-email-addy.ke@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/21/2014 09:50 PM, Addy Ke wrote:

> In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
> in one transaction, so the size of data to be write/read to/from
> TXDATAx/RXDATAx must be less than or equal 32 bytes at a time.

> Test on pinky board, elan receive 158 bytes data.

> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>   drivers/i2c/busses/i2c-rk3x.c | 3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index 69e1185..dc0aa64 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -323,6 +323,9 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
>   	/* ack interrupt */
>   	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
>
> +	/* Can only handle a maximum of 32 bytes at a time */
> +	len = (len > 32) ? 32 : len;

    Why not min(len, 32)? Or even:

	if (len > 32)
		len = 32;

WBR, Sergei

