Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaFQLYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:24:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55942 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbaFQLY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:24:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f5-b7f626d000004b39-7f-53a02569762a
Content-transfer-encoding: 8BIT
Message-id: <53A0256A.2000904@samsung.com>
Date: Tue, 17 Jun 2014 13:24:26 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, trblinux@gmail.com
Subject: Re: [PATCH] usb: misc: usb3503: Update error code in print message
References: <1403003330-17553-1-git-send-email-tushar.b@samsung.com>
In-reply-to: <1403003330-17553-1-git-send-email-tushar.b@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xq7qZqguCDT42G1k0L17PZnF51xw2
	i0XLWpktNkzezW5xY/tXFgdWj52z7rJ77J+7ht2jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mm787WQp+M1ZcfnqZaYGxmaOLkZODgkBE4mH79+yQdhiEhfurQeyuTiEBJYySnz5d4gdJMEr
	ICjxY/I9li5GDg5mAXmJI5eyQcLMAmYSj1rWMUPUf2KUaL/2nQ2iXkviR/tcJhCbRUBV4vS2
	yWA2m4ChRNfbLrAaUYEYiTO9n5lBZooIJEvs3hQAMdNI4seNq8wgtrCAt8T8bSvByoUEXCRu
	LpzBAmJzCrhKzG09xDaBUWAWkutmIVw3C8l1CxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKEhPDXHYxLj1kdYhTgYFTi4VX4NydYiDWxrLgy9xCjBAezkghvifiCYCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2MbFFSD19U7l9SNXl1SNuqi/7zV5ln7z93+YeBOT9jwJU1cxv1n3aWHf93
	cM56n8b+T/av2HL+imum126Xfq109eb+GtepfxzfC+9a6+6V0q1bpzClkV9lu0qb4i7Z5PyZ
	H+5qqemuerN3fsd5NpvrVXvilQxK+Nj0w1UXnfS2aXNYaFGrcf2uEktxRqKhFnNRcSIAyKfK
	Jj8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-06-17 13:08, Tushar Behera wrote:
> 'err' is uninitialized, rather print the error code directly.
>
> This also fixes following warning.
> drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
> drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>      dev_err(dev, "unable to request refclk (%d)\n", err);
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
> Based on next-20140616.
>
>   drivers/usb/misc/usb3503.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index f43c619..652855b 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
>   
>   		clk = devm_clk_get(dev, "refclk");
>   		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
> -			dev_err(dev, "unable to request refclk (%d)\n", err);
> +			dev_err(dev, "unable to request refclk (%ld)\n",
> +					PTR_ERR(clk));
>   			return PTR_ERR(clk);
>   		}
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

