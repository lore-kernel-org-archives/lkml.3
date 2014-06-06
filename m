Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaFFUtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:49:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:1841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbaFFUtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:49:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,991,1392192000"; 
   d="scan'208";a="524221827"
Date: Fri, 6 Jun 2014 13:51:05 -0700
From: Matt Roper <matthew.d.roper@intel.com>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        dri-devel@lists.freedesktop.org, patches@linaro.org
Subject: Re: [PATCH 1/2] drm/plane-helper: storage class should be before
 const qualifier
Message-ID: <20140606205105.GL29031@intel.com>
References: <1401989458-450-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401989458-450-1-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 06:30:57PM +0100, Peter Griffin wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.

This is definitely the right change to make, but I believe Thierry
already included a fix for this in patch

        http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=233fd4ec92b90a2d3bb5104d17835072ba2fde4b

which also cleans up some whitespace problems.


Matt

> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_plane_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_plane_helper.c b/drivers/gpu/drm/drm_plane_helper.c
> index d2b1c03..88a6c49 100644
> --- a/drivers/gpu/drm/drm_plane_helper.c
> +++ b/drivers/gpu/drm/drm_plane_helper.c
> @@ -36,7 +36,7 @@
>   * creating the primary plane.  However drivers that still call
>   * drm_plane_init() will use this minimal format list as the default.
>   */
> -const static uint32_t safe_modeset_formats[] = {
> +static const uint32_t safe_modeset_formats[] = {
>         DRM_FORMAT_XRGB8888,
>         DRM_FORMAT_ARGB8888,
>  };
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Matt Roper
Graphics Software Engineer
IoTG Platform Enabling & Development
Intel Corporation
(916) 356-2795
