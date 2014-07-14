Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaGNG4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:56:14 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:34012 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaGNG4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:56:06 -0400
Date: Mon, 14 Jul 2014 08:56:10 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B
 but is still active"
Message-ID: <20140714065610.GA15237@phenom.ffwll.local>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1404140703.2978.13.camel@x41>
 <87egy5h1yz.fsf@intel.com>
 <1404291203.12021.18.camel@x220>
 <1405283561.2103.9.camel@x41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405283561.2103.9.camel@x41>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 10:32:41PM +0200, Paul Bolle wrote:
> Paul Bolle schreef op wo 02-07-2014 om 10:53 [+0200]:
> > On Tue, 2014-07-01 at 12:17 +0300, Jani Nikula wrote:
> > > This does not ring any bells to me (but that doesn't prove anything). A
> > > bisect result would be awesome.
> 
> The bisect (which took me quite some time) points at commit 98ec77397a5c
> ("drm/i915: Make primary_enabled match the actual hardware state"). The
> bisect log is pasted at the end of this message.
> 
> Commit 98ec77397a5c reverts cleanly on top of v3.16-rc4. Booting
> v3.16-rc4 with that revert added makes the WARNING go away. But note
> that I have no idea whether that revert actually is a proper fix here.
> 
> Feel free to prod me for further testing, etc.

Please test the below patch, thanks.
-Daniel

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 82e7d57f0a8a..f0be855ddf45 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11914,6 +11914,7 @@ static void intel_sanitize_crtc(struct intel_crtc *crtc)
 		 * ...  */
 		plane = crtc->plane;
 		crtc->plane = !plane;
+		crtc->primary_enabled = true;
 		dev_priv->display.crtc_disable(&crtc->base);
 		crtc->plane = plane;
 
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
