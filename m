Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3I2RNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 13:13:49 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:48881 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3I2RNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 13:13:46 -0400
Date: Sun, 29 Sep 2013 13:13:43 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: Intel Haswell kernel warning (3.11.2)
Message-ID: <20130929171343.GA20148@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
References: <20130928185023.GA21672@animx.eu.org>
 <20130929141734.GA8370@animx.eu.org>
 <20130929150502.GG744@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929150502.GG744@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Please keep me in CC.

CCing Borislav Petkov <bp@alien8.de>, intel-gfx@lists.freedesktop.org,
dri-devel@lists.freedesktop.org as they were on another part of this thread.

Chris Wilson wrote:
> > > I receive a warning in drivers/gpu/drm/i915/intel_display.c:3869.  This
> > > happens when I'm on a console, the screen has gone into power save and I
> > > press a key to wake it up.
> > > 
> > > Kernel is Vanilla 3.11.2.
> 
> Try,
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index bd3e115..dacde4e 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -4043,8 +4043,6 @@ static void intel_connector_check_state(struct intel_connector *connector)
>   * consider. */
>  void intel_connector_dpms(struct drm_connector *connector, int mode)
>  {
> -       struct intel_encoder *encoder = intel_attached_encoder(connector);
> -
>         /* All the simple cases only support two dpms states. */
>         if (mode != DRM_MODE_DPMS_ON)
>                 mode = DRM_MODE_DPMS_OFF;
> @@ -4055,10 +4053,8 @@ void intel_connector_dpms(struct drm_connector *connector, int mode)
>         connector->dpms = mode;
>  
>         /* Only need to change hw state when actually enabled */
> -       if (encoder->base.crtc)
> -               intel_encoder_dpms(encoder, mode);
> -       else
> -               WARN_ON(encoder->connectors_active != false);
> +       if (connector->encoder)
> +               intel_encoder_dpms(to_intel_encoder(connector->encoder), mode);
>  
>         intel_modeset_check_state(connector->dev);
>  }

Manually appied to 3.11.2.  It doesn't give me a warning now and I can go
back to the VT where X is running (I forgot to mention that detail in the
original message I think).

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
