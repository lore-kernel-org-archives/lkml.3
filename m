Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3JaPMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:12:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3JaPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:12:46 -0400
Date: Thu, 31 Oct 2013 15:12:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        dri-devel@lists.freedesktop.org,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH 2/5] DRM: Armada: Use devm_ioremap_resource
Message-ID: <20131031151233.GC16735@n2100.arm.linux.org.uk>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org> <1383217687-12037-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383217687-12037-3-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 04:38:04PM +0530, Tushar Behera wrote:
> While at it, propagate the error code.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: dri-devel@lists.freedesktop.org
> CC: Russell King <rmk+kernel@arm.linux.org.uk>
> CC: David Airlie <airlied@linux.ie>
> ---
>  drivers/gpu/drm/armada/armada_crtc.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
> index d8e3982..2b6e7b7 100644
> --- a/drivers/gpu/drm/armada/armada_crtc.c
> +++ b/drivers/gpu/drm/armada/armada_crtc.c
> @@ -1037,11 +1037,9 @@ int armada_drm_crtc_create(struct drm_device *dev, unsigned num,
>  	if (ret)
>  		return ret;
>  
> -	base = devm_request_and_ioremap(dev->dev, res);
> -	if (!base) {
> -		DRM_ERROR("failed to ioremap register\n");
> -		return -ENOMEM;
> -	}
> +	base = devm_ioremap_resource(dev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);

David,

Do you want to take this directly, or shall I and send you another pull?
I have a few other minor patches for armada as well (implementing the
lastclose callback, and destroying the framebuffer associated with the
fb helper only after the fb helper has been finalised.

Thanks.
