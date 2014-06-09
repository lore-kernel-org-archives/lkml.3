Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaFIURl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:17:41 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55327 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFIURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <1400787733.16407.21.camel@x220>
References: <1400787733.16407.21.camel@x220>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 9 Jun 2014 21:17:07 +0100
Message-ID: <CA+V-a8swG6V+LgDYDxY7u-sqQ_vCqvTxdaQi=bH2=s=O5YTcQA@mail.gmail.com>
Subject: Re: [PATCH] [media] dm644x_ccdc: remove check for CONFIG_DM644X_VIDEO_PORT_ENABLE
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thanks for the patch.

On Thu, May 22, 2014 at 8:42 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> A check for CONFIG_DM644X_VIDEO_PORT_ENABLE was added in v2.6.32. The
> related Kconfig symbol was never added so this check has always
> evaluated to false. Remove that check.
>
Applied.

Thanks,
--Prabhakar Lad

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
>
> Related, trivial, cleanup: make ccdc_enable_vport() a oneliner.
>
>  drivers/media/platform/davinci/dm644x_ccdc.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
> index 30fa08405d61..07e98df3d867 100644
> --- a/drivers/media/platform/davinci/dm644x_ccdc.c
> +++ b/drivers/media/platform/davinci/dm644x_ccdc.c
> @@ -581,13 +581,8 @@ void ccdc_config_raw(void)
>              config_params->alaw.enable)
>                 syn_mode |= CCDC_DATA_PACK_ENABLE;
>
> -#ifdef CONFIG_DM644X_VIDEO_PORT_ENABLE
> -       /* enable video port */
> -       val = CCDC_ENABLE_VIDEO_PORT;
> -#else
>         /* disable video port */
>         val = CCDC_DISABLE_VIDEO_PORT;
> -#endif
>
>         if (config_params->data_sz == CCDC_DATA_8BITS)
>                 val |= (CCDC_DATA_10BITS & CCDC_FMTCFG_VPIN_MASK)
> --
> 1.9.0
>
