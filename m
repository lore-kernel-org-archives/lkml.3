Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3LBKAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:00:34 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64094 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab3LBKAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:00:31 -0500
Message-ID: <1385978429.2972.8.camel@x41.thuisdomein>
Subject: Re: [PATCH] drm/i915: Take modeset locks around
 intel_modeset_setup_hw_state()
From: Paul Bolle <pebolle@tiscali.nl>
To: ville.syrjala@linux.intel.com
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Mon, 02 Dec 2013 11:00:29 +0100
In-Reply-To: <1385975286-25392-1-git-send-email-ville.syrjala@linux.intel.com>
References: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
	 <1385975286-25392-1-git-send-email-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Dec 2013 10:00:29.0795 (UTC) FILETIME=[54FCAB30:01CEEF45]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 11:08 +0200, ville.syrjala@linux.intel.com wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Some lower level things get angry if we don't have modeset locks
> during intel_modeset_setup_hw_state(). Actually the resume and
> lid_notify codepaths alreday hold the locks, but the init codepath
> doesn't, so fix that.
> 
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
> Totally untested, but looks correct to me.

I assume I need to test this, on top of 7c063c725987 ("drm/i915: take
mode config lock around crtc disable at suspend"), to see if this makes
the WARNING that I currently see at boot go away?


Paul Bolle

>  drivers/gpu/drm/i915/intel_display.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 080f6fd..114db51 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -11046,7 +11046,9 @@ void intel_modeset_gem_init(struct drm_device *dev)
>  
>  	intel_setup_overlay(dev);
>  
> +	drm_modeset_lock_all(dev);
>  	intel_modeset_setup_hw_state(dev, false);
> +	drm_modeset_unlock_all(dev);
>  }
>  
>  void intel_modeset_cleanup(struct drm_device *dev)

