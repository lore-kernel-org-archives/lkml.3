Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3FLXhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:37:48 -0400
Received: from numidia.opendz.org ([98.142.220.152]:43840 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab3FLXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:37:47 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 19:37:46 EDT
Date: Thu, 13 Jun 2013 00:31:58 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH 5/6] kthread: avoid parsing names as format strings
Message-ID: <20130612233158.GA19948@dztty>
References: <1370649055-12830-1-git-send-email-keescook@chromium.org>
 <1370649055-12830-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370649055-12830-6-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Fri, Jun 07, 2013 at 04:50:54PM -0700, Kees Cook wrote:
> Calling kthread_run with a single name parameter causes it to be handled
> as a format string. Many callers are passing potentially dynamic string
> content, so use "%s" in those cases to avoid any potential accidents.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/block/aoe/aoecmd.c           |    2 +-
>  drivers/block/mtip32xx/mtip32xx.c    |    3 ++-
[...]
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index 847107e..81ce4c0 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -4085,7 +4085,8 @@ skip_create_disk:
>  start_service_thread:
>  	sprintf(thd_name, "mtip_svc_thd_%02d", index);
We can also save some bytes here, remove the sprintf() and thd_name[]

>  	dd->mtip_svc_handler = kthread_create_on_node(mtip_service_thread,
> -						dd, dd->numa_node, thd_name);
> +						dd, dd->numa_node, "%s",
> +						thd_name);
>  
>  	if (IS_ERR(dd->mtip_svc_handler)) {
>  		dev_err(&dd->pdev->dev, "service thread failed to start\n");

Thanks!

-- 
Djalal Harouni
http://opendz.org
