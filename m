Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaLUO7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:59:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60346 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLUO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:59:24 -0500
Message-ID: <5496E040.5060408@gmail.com>
Date: Sun, 21 Dec 2014 14:59:12 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mike Krinkin <krinkin.m.u@gmail.com>, gregkh@linuxfoundation.org,
        forest@alittletooquiet.net, gclement@baobob.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: fix sparse warnings: incorrect argument
 type
References: <1419170207-2585-1-git-send-email-krinkin.m.u@gmail.com>
In-Reply-To: <1419170207-2585-1-git-send-email-krinkin.m.u@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/12/14 13:56, Mike Krinkin wrote:
> this patch fixes following sparse warnings:
>
> drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
> drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
> drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
> drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
> drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
> drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
> drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
> drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
Good catch

also needed for 3.19

Thanks

Malcolm

>
> Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
> ---
>   drivers/staging/vt6655/device_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index 83e4162..ce616f9 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -1500,9 +1500,11 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
>   		if (conf->enable_beacon) {
>   			vnt_beacon_enable(priv, vif, conf);
>
> -			MACvRegBitsOn(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
> +			MACvRegBitsOn(priv->PortOffset, MAC_REG_TCR,
> +				      TCR_AUTOBCNTX);
>   		} else {
> -			MACvRegBitsOff(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
> +			MACvRegBitsOff(priv->PortOffset, MAC_REG_TCR,
> +				       TCR_AUTOBCNTX);
>   		}
>   	}
>
>
