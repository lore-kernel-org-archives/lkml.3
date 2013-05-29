Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932Ab3E2Dek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:34:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53152 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3E2Dei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:34:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] media: davinci: vpif_display: use module_platform_driver()
Date: Wed, 29 May 2013 05:34:36 +0200
Message-ID: <1376035.joGO8knslg@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369569612-30915-9-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-9-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 May 2013 17:30:11 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch uses module_platform_driver() to simplify the code.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/davinci/vpif_display.c |   18 +-----------------
>  1 files changed, 1 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_display.c
> b/drivers/media/platform/davinci/vpif_display.c index 9c308e7..7bcfe7d
> 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -2005,20 +2005,4 @@ static __refdata struct platform_driver vpif_driver =
> { .remove	= vpif_remove,
>  };
> 
> -static __init int vpif_init(void)
> -{
> -	return platform_driver_register(&vpif_driver);
> -}
> -
> -/*
> - * vpif_cleanup: This function un-registers device and driver to the
> kernel, - * frees requested irq handler and de-allocates memory allocated
> for channel - * objects.
> - */
> -static void vpif_cleanup(void)
> -{
> -	platform_driver_unregister(&vpif_driver);
> -}
> -
> -module_init(vpif_init);
> -module_exit(vpif_cleanup);
> +module_platform_driver(vpif_driver);
-- 
Regards,

Laurent Pinchart

