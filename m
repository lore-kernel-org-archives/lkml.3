Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaKXNsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:48:15 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61424 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXNsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <1416831903-5138-1-git-send-email-mike.looijmans@topic.nl>
References: <1416831903-5138-1-git-send-email-mike.looijmans@topic.nl>
Date: Mon, 24 Nov 2014 08:48:13 -0500
Message-ID: <CAF6AEGsP2s2S=FecxoPP0V_f_eMXbFC-+Nui5cRotJLhC+YD9A@mail.gmail.com>
Subject: Re: [PATCH] gpu/drm/drm_sysfs.c: Export drm_sysfs_connector_add and drm_sysfs_connector_remove
From: Rob Clark <robdclark@gmail.com>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: David Airlie <airlied@linux.ie>, Lars-Peter Clausen <lars@metafoo.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 7:25 AM, Mike Looijmans <mike.looijmans@topic.nl> wrote:
> Building the adi_axi_hdmi driver as a module failed:
> ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/adi_axi_hdmi/adi_axi_hdmi.ko] undefined!
>
> Mark drm_sysfs_connector_remove for export to fix this. Also mark
> drm_sysfs_connector_add for export, for symetry and because at least
> one other module uses it (xylon_connector.c).

no.. you should be using drm_connector_{register,unregister}() now,
and not calling the drm_sysfs_connector_{add,remove}() fxns directly..

BR,
-R

> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>  drivers/gpu/drm/drm_sysfs.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
> index ab1a5f6..d0296cc 100644
> --- a/drivers/gpu/drm/drm_sysfs.c
> +++ b/drivers/gpu/drm/drm_sysfs.c
> @@ -438,6 +438,7 @@ err_out_files:
>  out:
>         return ret;
>  }
> +EXPORT_SYMBOL(drm_sysfs_connector_add);
>
>  /**
>   * drm_sysfs_connector_remove - remove an connector device from sysfs
> @@ -467,6 +468,7 @@ void drm_sysfs_connector_remove(struct drm_connector *connector)
>         device_unregister(connector->kdev);
>         connector->kdev = NULL;
>  }
> +EXPORT_SYMBOL(drm_sysfs_connector_remove);
>
>  /**
>   * drm_sysfs_hotplug_event - generate a DRM uevent
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
