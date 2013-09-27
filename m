Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3I0P2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:28:38 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55832 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3I0P2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <1380120582-9068-3-git-send-email-joro@8bytes.org>
References: <1380120582-9068-1-git-send-email-joro@8bytes.org>
	<1380120582-9068-3-git-send-email-joro@8bytes.org>
Date: Fri, 27 Sep 2013 11:28:36 -0400
Message-ID: <CAF6AEGsf3eM1pXhgWeiV8kJOQyvhRSmp7RkETRgBWSzBPEwjGQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Fix compile error in drivers/gpu/drm/msm/msm_drv.c
 with IOMMU disabled
From: Rob Clark <robdclark@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:49 AM, Joerg Roedel <joro@8bytes.org> wrote:
> The function msm_iommu_get_ctx() is needed buy the MSM-GPU
> driver with and wiithout IOMMU compiled in. Make the
> function available when no IOMMU driver is there.
>

For this one,

Reviewed-by: Rob Clark <robdclark@gmail.com>

But I am not the right one to merge this one.  And, well, if there is
a way to make this work without msm_iommu_get_ctx(), I am interested
in some hints ;-)

Of the other two, 1/3 looks fine and I'll pull that in.  And I'll see
if I can come up with a better way for 2/3

BR,
-R

> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>  drivers/iommu/msm_iommu.h |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/iommu/msm_iommu.h b/drivers/iommu/msm_iommu.h
> index 5c7c955..da53558 100644
> --- a/drivers/iommu/msm_iommu.h
> +++ b/drivers/iommu/msm_iommu.h
> @@ -108,7 +108,14 @@ struct msm_iommu_ctx_drvdata {
>   * Useful for testing and drivers that do not yet fully have IOMMU stuff in
>   * their platform devices.
>   */
> +#ifdef CONFIG_MSM_IOMMU
>  struct device *msm_iommu_get_ctx(const char *ctx_name);
> +#else
> +static inline struct device *msm_iommu_get_ctx(const char *ctx_name)
> +{
> +       return NULL;
> +}
> +#endif
>
>  /*
>   * Interrupt handler for the IOMMU context fault interrupt. Hooking the
> --
> 1.7.9.5
>
>
