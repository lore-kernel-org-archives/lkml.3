Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaAHHfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:35:43 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60358 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAHHfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:35:36 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1389146191-2096-1-git-send-email-ying.xue@windriver.com>
References: <1389146191-2096-1-git-send-email-ying.xue@windriver.com>
Date: Wed, 8 Jan 2014 08:35:35 +0100
Message-ID: <CAKMK7uH1PjT7mfZunhFdftNe0WKHEYMU_xm7mMJCWR8CtDA--g@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: silence compiler warning
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Ying Xue <ying.xue@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 2:56 AM, Ying Xue <ying.xue@windriver.com> wrote:
> drivers/gpu/drm/i915/i915_debugfs.c: In function ‘display_crc_ctl_write’:
> drivers/gpu/drm/i915/i915_debugfs.c:2393:2: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
> drivers/gpu/drm/i915/i915_debugfs.c:2350:6: note: ‘val’ was declared here
>
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

I already have such a patch in my -next queue, thanks anyway.
-Daniel


> ---
>  drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 6ed45a9..7963ba5 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
>  {
>         struct drm_i915_private *dev_priv = dev->dev_private;
>         struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
> -       u32 val;
> +       u32 val = 0;
>         int ret;
>
>         if (pipe_crc->source == source)
> --
> 1.7.9.5
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
