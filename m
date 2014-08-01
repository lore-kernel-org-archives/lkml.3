Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaHAOIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:08:55 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:34880 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:08:54 -0400
Message-ID: <53DB9F77.6000102@cogentembedded.com>
Date: Fri, 01 Aug 2014 18:08:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: dmaengine@vger.kernel.org, Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma: at_hdmac: fix invalid remaining bytes detection
References: <1406887406-10567-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1406887406-10567-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/01/2014 02:03 PM, Alexandre Belloni wrote:

> Found using smatch:
> drivers/dma/at_hdmac.c:299 atc_get_bytes_left() warn: unsigned
> 'atchan->remain_desc' is never less than zero.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   drivers/dma/at_hdmac.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index c13a3bb0f594..9ec84ee2fa25 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -294,14 +294,16 @@ static int atc_get_bytes_left(struct dma_chan *chan)
>   			ret = -EINVAL;
>   			goto out;
>   		}
> -		atchan->remain_desc -= (desc_cur->lli.ctrla & ATC_BTSIZE_MAX)
> -						<< (desc_first->tx_width);
> -		if (atchan->remain_desc < 0) {
> +
> +		count = (desc_cur->lli.ctrla & ATC_BTSIZE_MAX)
> +			<< (desc_first->tx_width);

    Parens not needed here.

[...]

WBR, Sergei

