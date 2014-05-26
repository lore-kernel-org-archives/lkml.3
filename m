Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaEZX5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:57:51 -0400
Received: from shell.v3.sk ([195.168.3.45]:60730 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaEZX5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:57:48 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 19:57:47 EDT
Message-ID: <1401148238.1590.2.camel@odvarok>
Subject: Re: [PATCH] [media] usbtv: fix leak at failure path in usbtv_probe()
From: Lubomir Rintel <lkundrak@v3.sk>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Date: Tue, 27 May 2014 01:50:38 +0200
In-Reply-To: <1400878027-22954-1-git-send-email-khoroshilov@ispras.ru>
References: <1400878027-22954-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 00:47 +0400, Alexey Khoroshilov wrote:
> Error handling code in usbtv_probe() misses usb_put_dev().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Thank you!
Lubo

> ---
>  drivers/media/usb/usbtv/usbtv-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> index 2f87ddfa469f..473fab81b602 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -91,6 +91,8 @@ static int usbtv_probe(struct usb_interface *intf,
>  	return 0;
>  
>  usbtv_video_fail:
> +	usb_set_intfdata(intf, NULL);
> +	usb_put_dev(usbtv->udev);
>  	kfree(usbtv);
>  
>  	return ret;


