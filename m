Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3KUQKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:10:32 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:65492 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KUQKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <1385048986-14478-1-git-send-email-bp@alien8.de>
References: <1385048986-14478-1-git-send-email-bp@alien8.de>
Date: Thu, 21 Nov 2013 17:10:30 +0100
Message-ID: <CAFLxGvzcAYwdcdNmZt4stTSCueRmStFYt+MqvNAS3BJX7CnUoQ@mail.gmail.com>
Subject: Re: [PATCH] i915, debugfs: Fix uninitialized warning
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 4:49 PM, Borislav Petkov <bp@alien8.de> wrote:
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
>         struct drm_i915_private *dev_priv = dev->dev_private;
>         struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
> -       u32 val;
> +       u32 val = 0; /* shut up gcc */

Wouldn't it be better to use uninitialized_var() here?

>         int ret;
>
>         if (pipe_crc->source == source)
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
