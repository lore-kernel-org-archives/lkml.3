Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaIXUhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:37:10 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:64569 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaIXUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <1411575342-31048-8-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
	<1411575342-31048-8-git-send-email-vinod.koul@intel.com>
Date: Wed, 24 Sep 2014 16:37:07 -0400
Message-ID: <CADnq5_OmJh-p=HpMWQkAQUE=Z9TiCe2y9yhnhQxoO8KtzaTqhQ@mail.gmail.com>
Subject: Re: [PATCH 07/27] vga_switcheroo: use pm_runtime_last_busy_and_autosuspend
 helper
From: Alex Deucher <alexdeucher@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, subhransu.s.prusty@intel.com,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:14 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/vga/vga_switcheroo.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
> index 6866448..697ffbd 100644
> --- a/drivers/gpu/vga/vga_switcheroo.c
> +++ b/drivers/gpu/vga/vga_switcheroo.c
> @@ -682,10 +682,9 @@ static int vga_switcheroo_runtime_resume_hdmi_audio(struct device *dev)
>         ret = dev->bus->pm->runtime_resume(dev);
>
>         /* put the reference for the gpu */
> -       if (found) {
> -               pm_runtime_mark_last_busy(&found->pdev->dev);
> -               pm_runtime_put_autosuspend(&found->pdev->dev);
> -       }
> +       if (found)
> +               pm_runtime_last_busy_and_autosuspend(&found->pdev->dev);
> +
>         return ret;
>  }
>
> --
> 1.7.0.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
