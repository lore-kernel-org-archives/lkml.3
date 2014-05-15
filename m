Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaEOMiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:38:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54399 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaEOMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:38:52 -0400
Date: Thu, 15 May 2014 14:38:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ingo Molnar <mingo@kernel.org>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] drm: Missed clflushopt in drm_clflush_virt_range
Message-ID: <20140515123846.GQ8790@phenom.ffwll.local>
Mail-Followup-To: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Ingo Molnar <mingo@kernel.org>,
	H Peter Anvin <h.peter.anvin@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1400082072-22482-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400082072-22482-1-git-send-email-ross.zwisler@linux.intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 09:41:12AM -0600, Ross Zwisler wrote:
> With this commit:
> 
> 2a0788dc9bc4 x86: Use clflushopt in drm_clflush_virt_range
> 
> If clflushopt is available on the system, we use it instead of clflush
> in drm_clflush_virt_range.  There were two calls to clflush in this
> function, but only one was changed to clflushopt.  This patch changes
> the other clflush call to clflushopt.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: H Peter Anvin <h.peter.anvin@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Picked to my topic/core-stuff drm branch so it doesn't get lost.
-Daniel

> 
> ---
>  drivers/gpu/drm/drm_cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
> index 534cb89..041b73b 100644
> --- a/drivers/gpu/drm/drm_cache.c
> +++ b/drivers/gpu/drm/drm_cache.c
> @@ -138,7 +138,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
>  		char *end = addr + length;
>  		mb();
>  		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
> -			clflush(addr);
> +			clflushopt(addr);
>  		clflushopt(end - 1);
>  		mb();
>  		return;
> -- 
> 1.9.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
