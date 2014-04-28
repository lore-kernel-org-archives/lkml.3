Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaD1Nin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:38:43 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62401 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaD1Nij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:38:39 -0400
Date: Mon, 28 Apr 2014 15:38:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH][linux-next] Revert "drm/i915: fix build warning
 on 32-bit (v2)"
Message-ID: <20140428133743.GA32404@phenom.ffwll.local>
Mail-Followup-To: Jan Moskyto Matejka <mq@suse.cz>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1396868876-7372-1-git-send-email-mq@suse.cz>
 <20140428130323.GC2641@moskyto.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428130323.GC2641@moskyto.dyndns.org>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:03:23PM +0200, Jan Moskyto Matejka wrote:
> This reverts commit 60f2b4af1258c05e6b037af866be81abc24438f7.
> 
> The same warning has been fixed in e5081a538a565284fec5f30a937d98e460d5e780 and
> these two commits got merged in 74e99a84de2d0980320612db8015ba606af42114 which
> caused another warning. Simply, the reverted commit casted the pointer
> difference to unsigned long and the other commit changed the output type from
> long to ptrdiff_t.
> 
> The other commit fixes the original warning the better way so I'm reverting
> this commit now.
> 
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>

My apologies for missing this the first time around. Queued for -next,
thanks for the patch.
-Daniel
> ---
>  drivers/gpu/drm/i915/i915_cmd_parser.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
> index 4cf6d02..0eaed44 100644
> --- a/drivers/gpu/drm/i915/i915_cmd_parser.c
> +++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
> @@ -405,7 +405,7 @@ int i915_parse_cmds(struct intel_ring_buffer *ring,
>  			DRM_DEBUG_DRIVER("CMD: Command length exceeds batch length: 0x%08X length=%d batchlen=%td\n",
>  					 *cmd,
>  					 length,
> -					 (unsigned long)(batch_end - cmd));
> +					 batch_end - cmd);
>  			ret = -EINVAL;
>  			break;
>  		}
> -- 
> 1.8.4.5

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
