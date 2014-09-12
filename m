Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaILODV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:03:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47191 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaILODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:03:17 -0400
Date: Fri, 12 Sep 2014 16:03:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/9] drm/exynos/crtc: fix framebuffer reference sequence
Message-ID: <20140912140338.GF4740@phenom.ffwll.local>
Mail-Followup-To: Andrzej Hajda <a.hajda@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	"moderated list:ARM/S5P EXYNOS AR..." <linux-samsung-soc@vger.kernel.org>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	open list <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
 <1410268573-2297-6-git-send-email-a.hajda@samsung.com>
 <5412B02A.6040609@samsung.com>
 <20140912085710.GD4740@phenom.ffwll.local>
 <5412BC8D.2030007@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5412BC8D.2030007@samsung.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:27:41AM +0200, Andrzej Hajda wrote:
> On 09/12/2014 10:57 AM, Daniel Vetter wrote:
> > On Fri, Sep 12, 2014 at 05:34:50PM +0900, Inki Dae wrote:
> >> Hi Andrzej,
> >>
> >> On 2014년 09월 09일 22:16, Andrzej Hajda wrote:
> >>> Adding reference to framebuffer should be accompanied with removing
> >>> reference to old framebuffer assigned to the plane.
> >>> This patch removes following warning:
> >>>
> >>> [   95.038017] WARNING: CPU: 1 PID: 3067 at drivers/gpu/drm/drm_crtc.c:5115 drm_mode_config_cleanup+0x258/0x268()
> >>> [   95.048086] Modules linked in:
> >>> [   95.051430] CPU: 1 PID: 3067 Comm: bash Tainted: G        W      3.16.0-11355-g7a6eca5-dirty #3015
> >>> [   95.060058] [<c0013e90>] (unwind_backtrace) from [<c0011128>] (show_stack+0x10/0x14)
> >>> [   95.067766] [<c0011128>] (show_stack) from [<c04a5dc4>] (dump_stack+0x70/0xbc)
> >>> [   95.074953] [<c04a5dc4>] (dump_stack) from [<c0021784>] (warn_slowpath_common+0x64/0x88)
> >>> [   95.083005] [<c0021784>] (warn_slowpath_common) from [<c00217c4>] (warn_slowpath_null+0x1c/0x24)
> >>> [   95.091780] [<c00217c4>] (warn_slowpath_null) from [<c0275fa0>] (drm_mode_config_cleanup+0x258/0x268)
> >>> [   95.100983] [<c0275fa0>] (drm_mode_config_cleanup) from [<c0281724>] (exynos_drm_unload+0x38/0x50)
> >>> [   95.109915] [<c0281724>] (exynos_drm_unload) from [<c026e248>] (drm_dev_unregister+0x24/0x98)
> >>> [   95.118414] [<c026e248>] (drm_dev_unregister) from [<c026ecb0>] (drm_put_dev+0x28/0x64)
> >>> [   95.126412] [<c026ecb0>] (drm_put_dev) from [<c02947c4>] (take_down_master+0x24/0x44)
> >>> [   95.134218] [<c02947c4>] (take_down_master) from [<c0294870>] (component_del+0x8c/0xc8)
> >>> [   95.142201] [<c0294870>] (component_del) from [<c0286c10>] (exynos_dsi_remove+0x18/0x2c)
> >>> [   95.150294] [<c0286c10>] (exynos_dsi_remove) from [<c0299e04>] (platform_drv_remove+0x18/0x1c)
> >>> [   95.158872] [<c0299e04>] (platform_drv_remove) from [<c02987a4>] (__device_release_driver+0x70/0xc4)
> >>> [   95.167981] [<c02987a4>] (__device_release_driver) from [<c0298818>] (device_release_driver+0x20/0x2c)
> >>> [   95.177268] [<c0298818>] (device_release_driver) from [<c02979d0>] (unbind_store+0x5c/0x94)
> >>> [   95.185597] [<c02979d0>] (unbind_store) from [<c0297278>] (drv_attr_store+0x20/0x2c)
> >>> [   95.193323] [<c0297278>] (drv_attr_store) from [<c012aa90>] (sysfs_kf_write+0x4c/0x50)
> >>> [   95.201224] [<c012aa90>] (sysfs_kf_write) from [<c0129e94>] (kernfs_fop_write+0xc4/0x184)
> >>> [   95.209393] [<c0129e94>] (kernfs_fop_write) from [<c00d03ec>] (vfs_write+0xa0/0x1a8)
> >>> [   95.217111] [<c00d03ec>] (vfs_write) from [<c00d07f8>] (SyS_write+0x40/0x8c)
> >>> [   95.224146] [<c00d07f8>] (SyS_write) from [<c000e660>] (ret_fast_syscall+0x0/0x48)
> >>>
> >>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>> ---
> >>>  drivers/gpu/drm/exynos/exynos_drm_crtc.c | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> >>> index b68e58f..bde19f4 100644
> >>> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> >>> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> >>> @@ -145,10 +145,16 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
> >>>  	if (ret)
> >>>  		return ret;
> >>>  
> >>> +	/* we need to unreference current fb after replacing it with new one */
> >>> +	old_fb = plane->fb;
> >>> +
> >>>  	plane->crtc = crtc;
> >>>  	plane->fb = crtc->primary->fb;
> >>>  	drm_framebuffer_reference(plane->fb);
> >>>  
> >>> +	if (old_fb)
> >>> +		drm_framebuffer_unreference(old_fb);
> >> This time would be a good chance that we can consider drm flip queue to
> >> make sure that whole memory region to old_fb is scanned out completely
> >> before dropping a reference of old_fb. the reference of old_fb should be
> >> dropped at irq handler of each crtc devices, fimd and mixer.
> > Generally it's not a good idea to drop fb references from irq context,
> > since if you actually drop the last reference it'll blow up: fb cleanup
> > needs a bunch of mutexes.
> 
> I agree with that.
> 
> >
> > Also the drm core really should be taking care of this for you, you only
> > need to grab references yourself for async flips if you want the buffer to
> > survive a bit. crtc_mode_set has not need for this. I expect that the
> > refcounting bug is somewhere else, at least from my experience chasing
> > such issues in i915 ;-)
> 
> Hmm, maybe I miss something but I do not see the core grabbing fb reference
> on plane->fb update. On the other side drm_framebuffer_remove calls
> drm_plane_force_disable which drops plane->fb reference.
> I am not yet familiar with this code so maybe there is better solution.

It does, see e.g. drm_mode_set_config_internal. All the other places also
do it.

> If not I guess it would be better to move this code to
> exynos_plane_mode_set.
> At least it is done this way in omap and msm, in fact it seems better place
> for such things. What do you think?

Drivers _only_ need to do their own refcounting if they do asynchronous
updates (pageflips or asynchronous modesets). Which omap does (and iirc
msm for pageflips). But if that need is common we should have some helpers
for this (like the drm flip queue as guidelines or in the future atomic
helpers which will take care of everything).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
