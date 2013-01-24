Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3AXJ7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:59:07 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58446 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3AXJ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:59:00 -0500
Date: Thu, 24 Jan 2013 10:55:12 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fbdev-devel@lists.sourceforge.net,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 2/2] drm/i915: fixup per-crtc locking in
 intel_release_load_detect_pipe
Message-ID: <20130124095512.GU31870@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fbdev-devel@lists.sourceforge.net
References: <1358958309-5342-1-git-send-email-daniel.vetter@ffwll.ch>
 <1358958309-5342-3-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358958309-5342-3-git-send-email-daniel.vetter@ffwll.ch>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 05:25:09PM +0100, Daniel Vetter wrote:
> One of the early return cases missed the mutex unlocking. Hilarity
> ensued.
> 
> This regression has been introduced in
> 
> commit 7b24056be6db7ce907baffdd4cf142ab774ea60c
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Wed Dec 12 00:35:33 2012 +0100
> 
>     drm: don't hold crtc mutexes for connector ->detect callbacks
> 
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59750
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Tested-by: Cancan Feng <cancan.feng@intel.com>

Dave, please pick this one up for your drm-next tree since the issue only
happens there due to the modeset locking rework.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
