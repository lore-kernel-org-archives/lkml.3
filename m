Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaGGUmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:42:55 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51873 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGGUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <1404502629-32229-1-git-send-email-fabf@skynet.be>
References: <1404502629-32229-1-git-send-email-fabf@skynet.be>
Date: Mon, 7 Jul 2014 16:42:53 -0400
Message-ID: <CADnq5_N2b9eUFPMJJDitn6W2s=7f43MkEFL1OhOntGZVxJESqg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/radeon: remove null test before kfree
From: Alex Deucher <alexdeucher@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 3:37 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.  thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_pm.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
> index e447e39..a06afee 100644
> --- a/drivers/gpu/drm/radeon/radeon_pm.c
> +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> @@ -1400,9 +1400,7 @@ static void radeon_pm_fini_old(struct radeon_device *rdev)
>         }
>
>         radeon_hwmon_fini(rdev);
> -
> -       if (rdev->pm.power_state)
> -               kfree(rdev->pm.power_state);
> +       kfree(rdev->pm.power_state);
>  }
>
>  static void radeon_pm_fini_dpm(struct radeon_device *rdev)
> @@ -1421,9 +1419,7 @@ static void radeon_pm_fini_dpm(struct radeon_device *rdev)
>         radeon_dpm_fini(rdev);
>
>         radeon_hwmon_fini(rdev);
> -
> -       if (rdev->pm.power_state)
> -               kfree(rdev->pm.power_state);
> +       kfree(rdev->pm.power_state);
>  }
>
>  void radeon_pm_fini(struct radeon_device *rdev)
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
