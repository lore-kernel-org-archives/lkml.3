Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3H2Kz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:55:26 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60861 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3H2KzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:55:25 -0400
Date: Thu, 29 Aug 2013 13:55:21 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] radeon kms: fix uninitialised hotplug work usage in
 r100_irq_process()
In-Reply-To: <20130829092935.GB2235@swordfish>
Message-ID: <alpine.SOC.1.00.1308291250350.2723@math.ut.ee>
References: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee> <alpine.SOC.1.00.1308191158220.19642@math.ut.ee> <alpine.SOC.1.00.1308291017030.2723@math.ut.ee> <20130829092935.GB2235@swordfish>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reported-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

It works, thank you for quick response!

Tested-by: Meelis Roos <mroos@linux.ee>

>  drivers/gpu/drm/radeon/radeon_irq_kms.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
> index 081886b..cc9e848 100644
> --- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
> @@ -275,17 +275,19 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
>  			dev_info(rdev->dev, "radeon: using MSI.\n");
>  		}
>  	}
> +
> +	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
> +	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
> +	INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
> +
>  	rdev->irq.installed = true;
>  	r = drm_irq_install(rdev->ddev);
>  	if (r) {
>  		rdev->irq.installed = false;
> +		flush_work(&rdev->hotplug_work);
>  		return r;
>  	}
>  
> -	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
> -	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
> -	INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
> -
>  	DRM_INFO("radeon: irq initialized.\n");
>  	return 0;
>  }
> 

-- 
Meelis Roos (mroos@linux.ee)
