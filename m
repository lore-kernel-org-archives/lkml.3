Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3KUU6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:58:17 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63456 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3KUU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:58:14 -0500
Date: Thu, 21 Nov 2013 21:58:51 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915, debugfs: Fix uninitialized warning
Message-ID: <20131121205851.GO27344@phenom.ffwll.local>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <1385048986-14478-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385048986-14478-1-git-send-email-bp@alien8.de>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 04:49:46PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> gcc complains that:
> 
> drivers/gpu/drm/i915/i915_debugfs.c: In function ‘display_crc_ctl_write’:
> drivers/gpu/drm/i915/i915_debugfs.c:2393:2: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
> drivers/gpu/drm/i915/i915_debugfs.c:2350:6: note: ‘val’ was declared here
> 
> but it can't see that we're going to use val only in the success case.
> So shut it up.
> 
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@linux.ie>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Borislav Petkov <bp@suse.de>

Queued for -next, thanks for the patch.
-Daniel
> ---
>  drivers/gpu/drm/i915/i915_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 6ed45a984230..1191aa47adc9 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
> -	u32 val;
> +	u32 val = 0; /* shut up gcc */
>  	int ret;
>  
>  	if (pipe_crc->source == source)
> -- 
> 1.8.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
