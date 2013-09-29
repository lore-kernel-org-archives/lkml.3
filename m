Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3I2PFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:05:12 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:53359 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277Ab3I2PFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:05:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Sun, 29 Sep 2013 16:05:02 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel Haswell kernel warning (3.11.2)
Message-ID: <20130929150502.GG744@nuc-i3427.alporthouse.com>
References: <20130928185023.GA21672@animx.eu.org>
 <20130929141734.GA8370@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929141734.GA8370@animx.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 10:17:34AM -0400, Wakko Warner wrote:
> Wakko Warner wrote:
> > Please keep me in CC.
> > 
> > I receive a warning in drivers/gpu/drm/i915/intel_display.c:3869.  This
> > happens when I'm on a console, the screen has gone into power save and I
> > press a key to wake it up.
> > 
> > This doesn't happen when I'm in X.
> > 
> > Kernel is Vanilla 3.11.2.

Try,

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index bd3e115..dacde4e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4043,8 +4043,6 @@ static void intel_connector_check_state(struct intel_connector *connector)
  * consider. */
 void intel_connector_dpms(struct drm_connector *connector, int mode)
 {
-       struct intel_encoder *encoder = intel_attached_encoder(connector);
-
        /* All the simple cases only support two dpms states. */
        if (mode != DRM_MODE_DPMS_ON)
                mode = DRM_MODE_DPMS_OFF;
@@ -4055,10 +4053,8 @@ void intel_connector_dpms(struct drm_connector *connector, int mode)
        connector->dpms = mode;
 
        /* Only need to change hw state when actually enabled */
-       if (encoder->base.crtc)
-               intel_encoder_dpms(encoder, mode);
-       else
-               WARN_ON(encoder->connectors_active != false);
+       if (connector->encoder)
+               intel_encoder_dpms(to_intel_encoder(connector->encoder), mode);
 
        intel_modeset_check_state(connector->dev);
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
