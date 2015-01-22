Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbAVNdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:33:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50577 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbAVNdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:33:02 -0500
Date: Thu, 22 Jan 2015 14:27:27 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark yao <mark.yao@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 1/2] drm/rockchip: vop use is_enabled instead of dpms mode
Message-ID: <20150122132727.GV10113@phenom.ffwll.local>
Mail-Followup-To: Mark yao <mark.yao@rock-chips.com>,
	David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org
References: <1421910333-5576-1-git-send-email-mark.yao@rock-chips.com>
 <1421910333-5576-2-git-send-email-mark.yao@rock-chips.com>
 <20150122073334.GU10113@phenom.ffwll.local>
 <54C0BB29.3050104@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C0BB29.3050104@rock-chips.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:56:09PM +0800, Mark yao wrote:
> On 2015年01月22日 15:33, Daniel Vetter wrote:
> >On Thu, Jan 22, 2015 at 03:05:32PM +0800, Mark Yao wrote:
> >>drm dpms have many power modes: ON,OFF,SUSPEND,STANDBY, etc.
> >>but vop only have enable/disable mode, maybe case such bug:
> >>  --> DRM_DPMS_ON: power on vop
> >>  --> DRM_DPMS_SUSPEND: power off vop
> >>  --> DRM_DPMS_OFF: already power off at SUSPEND, crash
> >>so use a bool val is more suitable.
> >>
> >>Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> >Long term I highly suggest you switch to atomic, since with atomic all the
> >legacy dpms modes are remapped to a simple on/off. Also the new atomic
> >helpers make sure that your backend isn't called multiple times, so you
> >can ditch all your is_enabled tracking with that.
> >-Daniel
> Hi Daniel
> is there some documents teach me how to switch to atomic easily?
> I found many other drivers which use atomic also remap dpms modes to simple
> on/off at its driver,
> and I don't know where atomic helper do the remapped, can you give me some
> suggestions?

The dpms remapping patches are still in-flight. But for the general atomic
conversion please look at

http://blog.ffwll.ch/2014/11/atomic-modeset-support-for-kms-drivers.html

If you want to look at an actual driver there's msm already merged, tegra
(conversion just posted) and exynos (iirc not yet published all, but
Gustavo should have a branch for you to look at somewhere).

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
