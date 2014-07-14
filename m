Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaGNHNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:13:50 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58804 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbaGNHNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:13:43 -0400
Message-ID: <1405322020.19403.0.camel@x220>
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B
 but is still active"
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2014 09:13:40 +0200
In-Reply-To: <20140714065610.GA15237@phenom.ffwll.local>
References: <1404140703.2978.13.camel@x41> <87egy5h1yz.fsf@intel.com>
	 <1404291203.12021.18.camel@x220> <1405283561.2103.9.camel@x41>
	 <20140714065610.GA15237@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2014 07:13:41.0430 (UTC) FILETIME=[24115D60:01CF9F33]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 08:56 +0200, Daniel Vetter wrote:
> Please test the below patch, thanks.
> -Daniel
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 82e7d57f0a8a..f0be855ddf45 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -11914,6 +11914,7 @@ static void intel_sanitize_crtc(struct intel_crtc *crtc)
>  		 * ...  */
>  		plane = crtc->plane;
>  		crtc->plane = !plane;
> +		crtc->primary_enabled = true;
>  		dev_priv->display.crtc_disable(&crtc->base);
>  		crtc->plane = plane;
>  

Instead of the revert or on top of the revert?

Thanks,


Paul Bolle

