Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaC3Vbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:31:37 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51122 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaC3Vbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:31:35 -0400
Message-ID: <53388D35.8080902@lwfinger.net>
Date: Sun, 30 Mar 2014 16:31:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_probe()
References: <1396038375-18122-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1396038375-18122-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 03:26 PM, Alexey Khoroshilov wrote:
> If allocation of io_dmabuf fails, rtl8187_probe() calls usb_put_dev(udev)
> while usb_get_dev(udev) is not called yet. As a result refcnt is decremented
> incorrectly and usb_dev can be used after memory deallocation.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>   drivers/net/wireless/rtl818x/rtl8187/dev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> index fd78df813a85..d7f540a9dc9b 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> @@ -1636,10 +1636,10 @@ static int rtl8187_probe(struct usb_interface *intf,
>
>    err_free_dmabuf:
>   	kfree(priv->io_dmabuf);
> - err_free_dev:
> -	ieee80211_free_hw(dev);
>   	usb_set_intfdata(intf, NULL);
>   	usb_put_dev(udev);
> + err_free_dev:
> +	ieee80211_free_hw(dev);
>   	return err;
>   }
>
>

