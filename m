Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3CKUqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:46:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46830 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3CKUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:46:44 -0400
Message-ID: <513E42B1.3030108@lwfinger.net>
Date: Mon, 11 Mar 2013 15:46:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrei Epure <epure.andrei@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless:rtlwifi: replaced kmalloc+memcpy with kmemdup
References: <1362920987-6679-1-git-send-email-epure.andrei@gmail.com>
In-Reply-To: <1362920987-6679-1-git-send-email-epure.andrei@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 08:09 AM, Andrei Epure wrote:
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/usb.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index 156b527..b5c80b5 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -224,10 +224,9 @@ static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
>   	u8 *buffer;
>
>   	wvalue = (u16)(addr & 0x0000ffff);
> -	buffer = kmalloc(len, GFP_ATOMIC);
> +	buffer = kmemdup(data, len, GFP_ATOMIC);
>   	if (!buffer)
>   		return;
> -	memcpy(buffer, data, len);
>   	usb_control_msg(udev, pipe, request, reqtype, wvalue,
>   			index, buffer, len, 50);

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry


