Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552Ab3E2DeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:34:20 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3E2DeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:34:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] media: davinci: vpif_capture: use module_platform_driver()
Date: Wed, 29 May 2013 05:34:16 +0200
Message-ID: <1695975.sHT276StBG@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369569612-30915-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-6-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 May 2013 17:30:08 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch uses module_platform_driver() to simplify the code.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/davinci/vpif_capture.c |   28 +---------------------
>  1 files changed, 1 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index f8b7304..38c1fba
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2338,30 +2338,4 @@ static __refdata struct platform_driver vpif_driver =
> { .remove = vpif_remove,
>  };
> 
> -/**
> - * vpif_init: initialize the vpif driver
> - *
> - * This function registers device and driver to the kernel, requests irq
> - * handler and allocates memory
> - * for channel objects
> - */
> -static __init int vpif_init(void)
> -{
> -	return platform_driver_register(&vpif_driver);
> -}
> -
> -/**
> - * vpif_cleanup : This function clean up the vpif capture resources
> - *
> - * This will un-registers device and driver to the kernel, frees
> - * requested irq handler and de-allocates memory allocated for channel
> - * objects.
> - */
> -static void vpif_cleanup(void)
> -{
> -	platform_driver_unregister(&vpif_driver);
> -}
> -
> -/* Function for module initialization and cleanup */
> -module_init(vpif_init);
> -module_exit(vpif_cleanup);
> +module_platform_driver(vpif_driver);
-- 
Regards,

Laurent Pinchart

