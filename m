Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3C0Pp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:45:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:59769 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3C0Pp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:45:56 -0400
From: Ilya Tumaykin <itumaykin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 74/75] Revert "drm/i915: enable irqs earlier when resuming"
Date: Wed, 27 Mar 2013 19:45:42 +0400
Message-ID: <1889932.BuDOlJCg10@photon>
User-Agent: KMail/4.10.1 (Linux/3.8.4-ACER-1830T; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130318210515.597927833@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org> <20130318210515.597927833@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.13 14:07:37 Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

Hello, Greg.

The original "drm/i915: enable irqs earlier when resuming" commit was 
introduced in order to fix bug appeared in 3.8 kernels. Reverting this commit 
you also bring back that bug. Bugzilla link:
https://bugzilla.kernel.org/show_bug.cgi?id=54691#c17

Sorry for late reply, I wasn't sure if this is simple revert or another 
mechanism was introduced by devs to avoid mentioned bug and that fix became 
unnecessary. Please undo this revert.

> ------------------
> 
> This reverts commit 31f14f4219d2a74b7a6d86c7798f49141b5eccbe which was
> commit 15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 upstream.
> 
> It caused problems in the 3.8-stable series, but 3.9-rc is just fine.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@intel.com>
> Cc: Ilya Tumaykin <itumaykin@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> ---
>  drivers/gpu/drm/i915/i915_drv.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -486,7 +486,6 @@ static int i915_drm_freeze(struct drm_de
>  		intel_modeset_disable(dev);
> 
>  		drm_irq_uninstall(dev);
> -		dev_priv->enable_hotplug_processing = false;
>  	}
> 
>  	i915_save_state(dev);
> @@ -563,19 +562,9 @@ static int __i915_drm_thaw(struct drm_de
>  		error = i915_gem_init_hw(dev);
>  		mutex_unlock(&dev->struct_mutex);
> 
> -		/* We need working interrupts for modeset enabling ... */
> -		drm_irq_install(dev);
> -
>  		intel_modeset_init_hw(dev);
>  		intel_modeset_setup_hw_state(dev, false);
> -
> -		/*
> -		 * ... but also need to make sure that hotplug processing
> -		 * doesn't cause havoc. Like in the driver load code we don't
> -		 * bother with the tiny race here where we might loose hotplug
> -		 * notifications.
> -		 * */
> -		dev_priv->enable_hotplug_processing = true;
> +		drm_irq_install(dev);
>  	}
> 
>  	intel_opregion_init(dev);
-- 
Best regards.
Tumaykin Ilya.
