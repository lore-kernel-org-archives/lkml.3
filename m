Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHaXUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:20:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaHaXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:20:19 -0400
Message-ID: <5403ADAF.1000909@infradead.org>
Date: Sun, 31 Aug 2014 16:20:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/vmwgfx: select FB when DRM_VMWGFX is selected
References: <1409526467-20944-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1409526467-20944-1-git-send-email-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/14 16:07, Max Filippov wrote:
> Otherwise, if FB is not selected build fails at linking step:
>   vmwgfx_fb.c:(.text+0x4098b): undefined reference to `register_framebuffer'
>   vmwgfx_fb.c:(.text+0x409c0): undefined reference to `framebuffer_release'
>   vmwgfx_fb.c:(.text+0x409f4): undefined reference to `unregister_framebuffer'
>   vmwgfx_fb.c:(.text+0x40a0e): undefined reference to `framebuffer_release'
> 
> Patch ae6445ac7475ff05 drm/vmwgfx: depends on FB
> added dependency on FB that was subsequently removed in patch
> 04381b987292256d drm: Move plane helpers into drm_kms_helper.ko
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  drivers/gpu/drm/vmwgfx/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/Kconfig b/drivers/gpu/drm/vmwgfx/Kconfig
> index 67720f7..4fba548 100644
> --- a/drivers/gpu/drm/vmwgfx/Kconfig
> +++ b/drivers/gpu/drm/vmwgfx/Kconfig
> @@ -1,6 +1,7 @@
>  config DRM_VMWGFX
>  	tristate "DRM driver for VMware Virtual GPU"
>  	depends on DRM && PCI
> +	select FB
>  	select FB_DEFERRED_IO
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
> 

My experience with these "select FB_*" things is that this symbol (DRM_VMWGFX)
should still depend on FB.  Has something changed recently to negate that?


-- 
~Randy
