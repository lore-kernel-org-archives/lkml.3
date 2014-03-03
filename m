Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaCCJCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:02:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26370 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaCCJCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:02:38 -0500
Date: Mon, 3 Mar 2014 12:02:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Axel Rasmussen <axel.rasmussen1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers: staging: rtl8187se: wrap excessively long
 lines
Message-ID: <20140303090207.GJ26722@mwanda>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
 <1393737773-13937-5-git-send-email-axel.rasmussen1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393737773-13937-5-git-send-email-axel.rasmussen1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 10:22:48PM -0700, Axel Rasmussen wrote:
> Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
> ---
>  drivers/staging/rtl8187se/r8180_core.c | 73 ++++++++++++++++++++--------------
>  1 file changed, 44 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index b6c8c00..cd22ba3 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -1021,7 +1021,8 @@ inline u16 ieeerate2rtlrate(int rate)
>  	}
>  }
>  
> -static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540, 720};
> +static u16 rtl_rate[] = {10, 20, 55, 110, 60,
> +	90, 120, 180, 240, 360, 480, 540, 720};
>  
>  inline u16 rtl8180_rate2rate(short rate)
>  {
> @@ -1236,7 +1237,8 @@ static void rtl8180_rx(struct net_device *dev)
>  		tmp = priv->rxringtail;
>  		do {
>  			if (tmp == priv->rxring)
> -				tmp  = priv->rxring + (priv->rxringcount - 1)*rx_desc_size;
> +				tmp  = priv->rxring + (priv->rxringcount - 1) *
> +					rx_desc_size;
>  			else
>  				tmp -= rx_desc_size;
>  
> @@ -1322,21 +1324,26 @@ static void rtl8180_rx(struct net_device *dev)
>  			priv->rx_skb_complete = 1;
>  		}
>  
> -		signal = (unsigned char)(((*(priv->rxringtail+3)) & (0x00ff0000))>>16);
> +		signal = (unsigned char)(*(priv->rxringtail + 3) &
> +			0x00ff0000) >> 16;

Nope.  This introduces a bug.

I have not reviewed any further into this patch.

regards,
dan carpenter
