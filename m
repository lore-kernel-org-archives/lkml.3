Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3HHSP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:15:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37528 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab3HHSPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <1375956092-29386-1-git-send-email-vincent.stehle@freescale.com>
References: <1375956092-29386-1-git-send-email-vincent.stehle@freescale.com>
Date: Thu, 8 Aug 2013 20:15:24 +0200
Message-ID: <CANq1E4Tyodf9DBPapCPLsQkxmiBC8Hsn3Z9N7-LL3qOSAZ2K1g@mail.gmail.com>
Subject: Re: drm/agp linux-next build broken for non-AGP platform
From: David Herrmann <dh.herrmann@gmail.com>
To: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@freescale.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Aug 8, 2013 at 12:01 PM, Vincent Stehlé
<vincent.stehle@freescale.com> wrote:
> Hi,
>
> Linux next-20130808 link breaks for me with ARM config multi_v7defconfig.
>
> It seems this is due to the following commit:
>
>   28ec711 drm/agp: move AGP cleanup paths to drm_agpsupport.c
>
> ...which calls drm_agp_clear() without "gating" it with __OS_HAS_AGP.
> As the code of drm_agpsupport.c is only "emited" when __OS_HAS_AGP,
> which is not the case for me, link breaks.
>
> As a "hint", see the patch below, which "repairs" the link for me. This is
> probably not functional; please DO NOT APPLY.
>
> Best regards,
>
> V.
>

Yepp, I missed that, sorry. There is already a patch pending on dri-devel:
  http://lists.freedesktop.org/archives/dri-devel/2013-August/043077.html

Thanks
David

> ---
>  drivers/gpu/drm/drm_drv.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index dddd799..58f7f39 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -195,7 +195,9 @@ int drm_lastclose(struct drm_device * dev)
>
>         mutex_lock(&dev->struct_mutex);
>
> +#if __OS_HAS_AGP
>         drm_agp_clear(dev);
> +#endif
>
>         if (drm_core_check_feature(dev, DRIVER_SG) && dev->sg &&
>             !drm_core_check_feature(dev, DRIVER_MODESET)) {
> --
> 1.7.10.4
>
>
>
