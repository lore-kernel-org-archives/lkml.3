Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaBKUcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:32:04 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62813 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBKUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <1392150119-21132-1-git-send-email-galak@codeaurora.org>
References: <1392150119-21132-1-git-send-email-galak@codeaurora.org>
Date: Tue, 11 Feb 2014 15:32:00 -0500
Message-ID: <CAF6AEGtQRhwRS+GpGqrGUNts26X=sfOKWUjbbxwUmkPs2btbYw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: drop ARCH_MSM Kconfig depend
From: Rob Clark <robdclark@gmail.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 3:21 PM, Kumar Gala <galak@codeaurora.org> wrote:
> The ARCH_MSM depend is redundant with ARCH_MSM8960, so we can remove it.
> Additionally, we are splitting Qualcomm MSM support into legacy (ARCH_MSM)
> and multiplatform (ARCH_QCOM).  The MSM8960 with be ARCH_QCOM going forward
> so dropping ARCH_MSM will work properly for the new ARCH_QCOM multiplatform
> build.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Acked-by: Rob Clark <robdclark@gmail.com>


> ---
> David/Rob,
>
> If you can ack this I'll send it via linux-qcom/arm-soc tree's
>
> thanks
>
> - k
>  drivers/gpu/drm/msm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
> index c69d1e0..b698497 100644
> --- a/drivers/gpu/drm/msm/Kconfig
> +++ b/drivers/gpu/drm/msm/Kconfig
> @@ -3,7 +3,7 @@ config DRM_MSM
>         tristate "MSM DRM"
>         depends on DRM
>         depends on MSM_IOMMU
> -       depends on (ARCH_MSM && ARCH_MSM8960) || (ARM && COMPILE_TEST)
> +       depends on ARCH_MSM8960 || (ARM && COMPILE_TEST)
>         select DRM_KMS_HELPER
>         select SHMEM
>         select TMPFS
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
