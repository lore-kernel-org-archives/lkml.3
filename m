Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3KVPKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:10:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:25219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab3KVPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:10:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,752,1378882800"; 
   d="scan'208";a="438059014"
Date: Fri, 22 Nov 2013 17:09:59 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] i915, debugfs: Fix uninitialized warning
Message-ID: <20131122150959.GD10036@intel.com>
References: <1385048986-14478-1-git-send-email-bp@alien8.de>
 <CAFLxGvzcAYwdcdNmZt4stTSCueRmStFYt+MqvNAS3BJX7CnUoQ@mail.gmail.com>
 <20131121162535.GK26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131121162535.GK26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:25:35PM +0100, Borislav Petkov wrote:
> On Thu, Nov 21, 2013 at 05:10:30PM +0100, Richard Weinberger wrote:
> > > diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> > > index 6ed45a984230..1191aa47adc9 100644
> > > --- a/drivers/gpu/drm/i915/i915_debugfs.c
> > > +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> > > @@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
> > >  {
> > >         struct drm_i915_private *dev_priv = dev->dev_private;
> > >         struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
> > > -       u32 val;
> > > +       u32 val = 0; /* shut up gcc */
> > 
> > Wouldn't it be better to use uninitialized_var() here?
> 
> I remember Linus' rant about this macro so that's why I don't use it
> anymore.
> 
> In this specific case, it doesn't matter whichever we do so I'll let the
> maintainer make a wish :)

IIRC this warning was there for me too on gcc 4.6, but it disappeared
on gcc 4.7, which is why I decided not to send a patch for it.

-- 
Ville Syrjälä
Intel OTC
