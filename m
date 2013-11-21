Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3KUQZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:25:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44984 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3KUQZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:25:43 -0500
Date: Thu, 21 Nov 2013 17:25:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] i915, debugfs: Fix uninitialized warning
Message-ID: <20131121162535.GK26009@pd.tnic>
References: <1385048986-14478-1-git-send-email-bp@alien8.de>
 <CAFLxGvzcAYwdcdNmZt4stTSCueRmStFYt+MqvNAS3BJX7CnUoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFLxGvzcAYwdcdNmZt4stTSCueRmStFYt+MqvNAS3BJX7CnUoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:10:30PM +0100, Richard Weinberger wrote:
> > diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> > index 6ed45a984230..1191aa47adc9 100644
> > --- a/drivers/gpu/drm/i915/i915_debugfs.c
> > +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> > @@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
> >  {
> >         struct drm_i915_private *dev_priv = dev->dev_private;
> >         struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
> > -       u32 val;
> > +       u32 val = 0; /* shut up gcc */
> 
> Wouldn't it be better to use uninitialized_var() here?

I remember Linus' rant about this macro so that's why I don't use it
anymore.

In this specific case, it doesn't matter whichever we do so I'll let the
maintainer make a wish :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
