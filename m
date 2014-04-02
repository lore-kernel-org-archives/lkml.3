Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbaDBP0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:26:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770AbaDBP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:26:33 -0400
Message-ID: <533C2C1F.5010303@infradead.org>
Date: Wed, 02 Apr 2014 08:26:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915: fix command parser debug print format mismatches
References: <533B106B.8090408@infradead.org> <1396427060-12539-1-git-send-email-jani.nikula@intel.com>
In-Reply-To: <1396427060-12539-1-git-send-email-jani.nikula@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 01:24 AM, Jani Nikula wrote:
> Drop the cast from the pointer diff to fix:
> 
> drivers/gpu/drm/i915/i915_cmd_parser.c:405:4: warning: format '%td' expects
> argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int'
> [-Wformat]
> 
> While at it, use %u for u32.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> 
> ---
> 
> Randy, try as I might, I wasn't able to coerce gcc to spit out that
> warning. Please enlighten me! (Does this fix the warn?)

Yes, it does.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> Thanks for the report.
> ---
>  drivers/gpu/drm/i915/i915_cmd_parser.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
> index 71ac3b4eaa0d..e5c4e99a22fb 100644
> --- a/drivers/gpu/drm/i915/i915_cmd_parser.c
> +++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
> @@ -811,10 +811,10 @@ int i915_parse_cmds(struct intel_ring_buffer *ring,
>  			length = ((*cmd & desc->length.mask) + LENGTH_BIAS);
>  
>  		if ((batch_end - cmd) < length) {
> -			DRM_DEBUG_DRIVER("CMD: Command length exceeds batch length: 0x%08X length=%d batchlen=%td\n",
> +			DRM_DEBUG_DRIVER("CMD: Command length exceeds batch length: 0x%08X length=%u batchlen=%td\n",
>  					 *cmd,
>  					 length,
> -					 (unsigned long)(batch_end - cmd));
> +					 batch_end - cmd);
>  			ret = -EINVAL;
>  			break;
>  		}
> 


-- 
~Randy
