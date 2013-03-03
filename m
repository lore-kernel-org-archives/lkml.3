Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3CCRR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 12:17:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35607 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3CCRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 12:17:55 -0500
Date: Sun, 3 Mar 2013 18:20:26 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie, daniel.vetter@ffwll.ch,
        Paulo Zanoni <przanoni@gmail.com>
Subject: Re: [PATCH] drm/i915: Fix missing variable initilization
Message-ID: <20130303172026.GG9021@phenom.ffwll.local>
Mail-Followup-To: Syam Sidhardhan <syamsidhardh@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	airlied@linux.ie, Paulo Zanoni <przanoni@gmail.com>
References: <1361745338-28522-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361745338-28522-1-git-send-email-s.syam@samsung.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:05:38AM +0530, Syam Sidhardhan wrote:
> Need to initialize the variable wait to false.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>

Looks sane, thanks for the patch. Cc'ing Paulo in case I've missed
something.
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_ddi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
> index fc95ef0..5d0a687 100644
> --- a/drivers/gpu/drm/i915/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/intel_ddi.c
> @@ -1391,8 +1391,8 @@ void intel_ddi_prepare_link_retrain(struct drm_encoder *encoder)
>  	struct intel_dp *intel_dp = &intel_dig_port->dp;
>  	struct drm_i915_private *dev_priv = encoder->dev->dev_private;
>  	enum port port = intel_dig_port->port;
> -	bool wait;
>  	uint32_t val;
> +	bool wait = false;
>  
>  	if (I915_READ(DP_TP_CTL(port)) & DP_TP_CTL_ENABLE) {
>  		val = I915_READ(DDI_BUF_CTL(port));
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
