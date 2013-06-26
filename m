Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3FZU6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:58:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42316 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3FZU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:58:06 -0400
Message-ID: <51CB55DB.6040306@wwwdotorg.org>
Date: Wed, 26 Jun 2013 14:58:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 3/6] drm: add SimpleDRM driver
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 PM, David Herrmann wrote:
> The SimpleDRM driver binds to simple-framebuffer devices and provides a
> DRM/KMS API. It provides only a single CRTC+encoder+connector combination
> plus one initial mode.
> 
> Userspace can create one dumb-buffer and attach it to the CRTC. Only if
> the buffer is destroyed, a new buffer can be created. The buffer is
> directly mapped into user-space, so we have only resources for a single
> buffer. Otherwise, shadow buffers plus damage-request would be needed.

> diff --git a/drivers/gpu/drm/simpledrm/Kconfig b/drivers/gpu/drm/simpledrm/Kconfig

> +config DRM_SIMPLEDRM
> +	tristate "Simple firmware framebuffer DRM driver"
> +	depends on DRM && !FB_SIMPLE
> +	help
> +	  SimpleDRM can run on all systems with pre-initialized graphics
> +	  hardware. It uses a framebuffer that was initialized during
> +	  firmware boot. No page-flipping, modesetting or other advanced
> +	  features are available. However, other DRM drivers can be loaded
> +	  later and take over from SimpleDRM if they provide real hardware
> +	  support.
> +
> +	  SimpleDRM supports: "simple-framebuffer" DeviceTree objects, x86 VESA
> +	  BIOS Extensions (VBE), EFI framebuffers

DT objects, yes. I'm not sure it's quite true to say it actually
directly supports VBE or EFI FBs; it's more the code in patch 2/6 that
supports those. I guess this is a bit nit-picky of a distinction though.

> diff --git a/drivers/gpu/drm/simpledrm/simpledrm_drv.c b/drivers/gpu/drm/simpledrm/simpledrm_drv.c

> +static int parse_dt(struct platform_device *pdev,
> +		    struct simplefb_platform_data *mode)

> +	strlcpy(mode->format, format, sizeof(mode->format));

Even here, I believe the DT data sticks around so just copying the
pointer should be safe. It'd be worth validating that for sure though.

I didn't review the DRM stuff here since I'm not at all familiar with DRM.
