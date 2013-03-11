Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab3CKEov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 00:44:51 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49337 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3CKEot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 00:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <1362917693-29589-1-git-send-email-gheorghiuandru@gmail.com>
References: <1362917693-29589-1-git-send-email-gheorghiuandru@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Mar 2013 10:14:27 +0530
Message-ID: <CA+V-a8sjKVu_ASQEwYUjK2fqU7tWg3DUheY9cxgEfkjwoe+9Ng@mail.gmail.com>
Subject: Re: [PATCH] Drivers: staging: media: davinci_vpfe: Use resource_size function
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandru,

Thanks for the patch!

On Sun, Mar 10, 2013 at 5:44 PM, Alexandru Gheorghiu
<gheorghiuandru@gmail.com> wrote:
> Use resource_size function on resource object instead of explicit
> computation.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> index c8cae51..b2f4ef8 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> @@ -1065,7 +1065,6 @@ vpfe_ipipeif_cleanup(struct vpfe_ipipeif_device *ipipeif,
>         iounmap(ipipeif->ipipeif_base_addr);
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
>         if (res)
> -               release_mem_region(res->start,
> -                                       res->end - res->start + 1);
> +               release_mem_region(res->start, resource_size(res));
>
>  }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
