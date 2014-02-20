Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaBTLfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:35:48 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:55884 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBTLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:35:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        prabhakar.csengg@gmail.com, yongjun_wei@trendmicro.com.cn,
        sakari.ailus@iki.fi, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
Date: Thu, 20 Feb 2014 12:36:57 +0100
Message-ID: <4210530.AR5GZgidVz@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1386584182-5400-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com> <1386584182-5400-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

What's the status of this patch ? Do expect Prabhakar to pick it up, or do you 
plan to push all your IRQF_DISABLED removal patches in one go ?

On Monday 09 December 2013 11:16:22 Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c index
> d8ce20d2fbda..cda8388cbb89 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> @@ -298,7 +298,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
> {
>  	int ret = 0;
> 
> -	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
> +	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, 0,
>  			  "vpfe_capture0", vpfe_dev);
>  	if (ret < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev,
> @@ -306,7 +306,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
> return ret;
>  	}
> 
> -	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, IRQF_DISABLED,
> +	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, 0,
>  			  "vpfe_capture1", vpfe_dev);
>  	if (ret < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev,
> @@ -316,7 +316,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
> }
> 
>  	ret = request_irq(vpfe_dev->imp_dma_irq, vpfe_imp_dma_isr,
> -			  IRQF_DISABLED, "Imp_Sdram_Irq", vpfe_dev);
> +			  0, "Imp_Sdram_Irq", vpfe_dev);
>  	if (ret < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev,
>  			 "Error: requesting IMP IRQ interrupt\n");

-- 
Regards,

Laurent Pinchart

