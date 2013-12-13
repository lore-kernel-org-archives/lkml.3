Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LMDai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:30:38 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:62006 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LMDaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:30:21 -0500
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTye7SIrkDrg==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH] drm/bochs: new driver
Date: Fri, 13 Dec 2013 03:30:07 +0000
User-Agent: KMail/1.13.7 (Linux/3.12-4.slh.1-aptosid-686; KDE/4.8.4; i686; ; )
Cc: David Airlie <airlied@linux.ie>, open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>
References: <1386858246-4470-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1386858246-4470-1-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201312130330.14647.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 12 December 2013, Gerd Hoffmann wrote:
> DRM driver for (virtual) vga cards using the bochs dispi
> interface, such as the qemu standard vga (qemu -vga std).
> 
> Don't bother supporting anything but 32bpp for now, even
> though the virtual hardware is able to do that.
> 
> Known issue: mmap(/dev/fb0) doesn't work.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
[…]
> diff --git a/drivers/gpu/drm/bochs/bochs_mm.c b/drivers/gpu/drm/bochs/bochs_mm.c
> new file mode 100644
> index 0000000..afe104f
> --- /dev/null
> +++ b/drivers/gpu/drm/bochs/bochs_mm.c
[…]
> +int bochs_gem_create(struct drm_device *dev, u32 size, bool iskernel,
> +		     struct drm_gem_object **obj)
> +{
> +	struct bochs_bo *bochsbo;
> +	int ret;
> +
> +	*obj = NULL;
> +
> +	size = roundup(size, PAGE_SIZE);
[…]

Using roundup() this way will fail to build in 32 bit architectures/ 
i386:

ERROR: "__udivdi3" [drivers/gpu/drm/bochs/bochs-drm.ko] undefined!
ERROR: "__umoddi3" [drivers/gpu/drm/bochs/bochs-drm.ko] undefined!

[drm/bochs works pretty nicely for me on amd64]

Regards
	Stefan Lippers-Hollmann
