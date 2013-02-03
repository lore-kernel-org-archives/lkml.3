Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3BCV6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:58:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3BCV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:58:35 -0500
Message-ID: <510EDD85.60909@canonical.com>
Date: Sun, 03 Feb 2013 22:58:29 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Christian Konig <deathsimple@vodafone.de>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: fix compile failure by including <linux/swiotlb.h>
References: <201302012045.r11KjctX014737@farm-0002.internal.tilera.com>
In-Reply-To: <201302012045.r11KjctX014737@farm-0002.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-02-13 19:44, Chris Metcalf schreef:
> On tile architecture (with "make allyesconfig") including
> <linux/swiotlb.h> is required to call swiotlb_nr_tbl().
I'll take your word for the need, since I lack the hardware to verify the failure. :-)
Applying your patch doesn't seem to break compilation on x86 though, which is good enough for me.

Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c |    1 +
>  drivers/gpu/drm/radeon/radeon_ttm.c  |    1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 69d7b1d..1699a90 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -28,6 +28,7 @@
>   */
>  
>  #include <core/engine.h>
> +#include <linux/swiotlb.h>
>  
>  #include <subdev/fb.h>
>  #include <subdev/vm.h>
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 1d8ff2f..93f760e 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -38,6 +38,7 @@
>  #include <drm/radeon_drm.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> +#include <linux/swiotlb.h>
>  #include "radeon_reg.h"
>  #include "radeon.h"
>  
