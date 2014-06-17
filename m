Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaFQPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:13:22 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46531 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbaFQPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <1402784666-20300-1-git-send-email-fabf@skynet.be>
References: <1402784666-20300-1-git-send-email-fabf@skynet.be>
Date: Tue, 17 Jun 2014 11:13:20 -0400
Message-ID: <CAF6AEGvau+w=M9-Qj1GnBUUT9AC5VU71uPeygv+2vULF2jsmhQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/gpu/drm/msm/msm_iommu.c: use PAGE_ALIGNED
 instead of IS_ALIGNED(PAGE_SIZE
From: Rob Clark <robdclark@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 6:24 PM, Fabian Frederick <fabf@skynet.be> wrote:
> use mm.h definition
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks, I've got this queued up

BR,
-R

> ---
>  drivers/gpu/drm/msm/msm_iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
> index 92b7459..198ed84 100644
> --- a/drivers/gpu/drm/msm/msm_iommu.c
> +++ b/drivers/gpu/drm/msm/msm_iommu.c
> @@ -110,7 +110,7 @@ static int msm_iommu_unmap(struct msm_mmu *mmu, uint32_t iova,
>
>                 VERB("unmap[%d]: %08x(%x)", i, iova, bytes);
>
> -               BUG_ON(!IS_ALIGNED(bytes, PAGE_SIZE));
> +               BUG_ON(!PAGE_ALIGNED(bytes));
>
>                 da += bytes;
>         }
> --
> 1.8.4.5
>
