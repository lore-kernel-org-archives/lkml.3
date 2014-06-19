Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbaFSTAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:00:23 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63666 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaFSTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:00:22 -0400
Date: Thu, 19 Jun 2014 21:00:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers/i915: Fix unnoticed failure of
 init_ring_common()
Message-ID: <20140619190011.GA5821@phenom.ffwll.local>
Mail-Followup-To: Konrad Zapalowicz <bergo.torino@gmail.com>,
	jani.nikula@linux.intel.com, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
 <1403197635-14598-1-git-send-email-bergo.torino@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403197635-14598-1-git-send-email-bergo.torino@gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 07:07:15PM +0200, Konrad Zapalowicz wrote:
> This commit add check for return value of init_ring_common() in the
> init_render_ring(). Now, when failure is detected the error code is
> propagated to the caller instead of being ignored.
> 
> Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>

Queued for -next, thanks for the patch.
-Daniel

> ---
>  
>  v2:
>    - remove from commit message references to the Oops.
> 
>  drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> index 279488a..d205b0d 100644
> --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> @@ -604,6 +604,8 @@ static int init_render_ring(struct intel_engine_cs *ring)
>  	struct drm_device *dev = ring->dev;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	int ret = init_ring_common(ring);
> +	if (ret)
> +		return ret;
>  
>  	/* WaTimedSingleVertexDispatch:cl,bw,ctg,elk,ilk,snb */
>  	if (INTEL_INFO(dev)->gen >= 4 && INTEL_INFO(dev)->gen < 7)
> -- 
> 1.8.1.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
