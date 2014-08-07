Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaHGOuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:50:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34606 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbaHGOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:50:08 -0400
Date: Thu, 7 Aug 2014 16:50:18 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: read HEAD register back in init_ring_common()
 to enforce ordering
Message-ID: <20140807145018.GG8727@phenom.ffwll.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1408071628340.6219@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1408071628340.6219@pobox.suse.cz>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 04:29:53PM +0200, Jiri Kosina wrote:
> Withtout this, ring initialization fails reliabily during resume with
> 
> 	[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head ffffff8804 tail 00000000 start 000e4000
> 
> This is not a complete fix, but it is verified to make the ring 
> initialization failures during resume much less likely.
> 
> We were not able to root-cause this bug (likely HW-specific to Gen4 chips) 
> yet. This is therefore used as a ducttape before problem is fully 
> understood and proper fix created, so that people don't suffer from 
> completely unusable systems in the meantime.
> 
> The discussion and debugging is happening at
> 
> 	https://bugs.freedesktop.org/show_bug.cgi?id=76554
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Ok, picked this one here, has the nicer commit message ;-)
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_ringbuffer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> index 279488a..7add7ee 100644
> --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> @@ -517,6 +517,9 @@ static int init_ring_common(struct intel_engine_cs *ring)
>  	else
>  		ring_setup_phys_status_page(ring);
>  
> +	/* Enforce ordering by reading HEAD register back */
> +	I915_READ_HEAD(ring);
> +
>  	/* Initialize the ring. This must happen _after_ we've cleared the ring
>  	 * registers with the above sequence (the readback of the HEAD registers
>  	 * also enforces ordering), otherwise the hw might lose the new ring
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
